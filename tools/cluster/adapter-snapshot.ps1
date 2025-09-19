# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 CHOOVIO Inc
# Purpose: Snapshot adapters and print a compact orange RESULTS block

param(
  [string]$Namespace = "magistrala"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ns = $Namespace

function Invoke-Json { param([scriptblock]$Cmd) $o = & $Cmd 2>$null; if(-not $? -or -not $o){return $null}; try{$o|ConvertFrom-Json}catch{$null} }
function Get-JsonProp { param([object]$obj,[string]$name,[object]$def=$null) if($null -eq $obj){return $def}; $p=$obj.PSObject.Properties[$name]; if($p){$p.Value}else{$def} }
function Has-JsonProp { param([object]$obj,[string]$name) if($null -eq $obj){return $false}; $obj.PSObject.Properties[$name] -ne $null }
function Compact-Join { param([object[]]$arr,[int]$max=3) $a=@($arr); if($a.Count -le $max){return ($a -join "; ")} ($a[0..($max-1)] -join "; ") + "; ... +" + ($a.Count-$max) }

# Deployments (*-adapter)
$depRows=@(); $dep = Invoke-Json { kubectl get deploy -n $ns -o json }
if($dep){ foreach($d in $dep.items){
  $dn = Get-JsonProp -obj $d.metadata -name "name" -def ""
  if($dn -notmatch "(?i)\b(http|ws)-adapter\b"){ continue }
  $des   = Get-JsonProp -obj $d.spec   -name "replicas"     -def 0
  $ready = Get-JsonProp -obj $d.status -name "readyReplicas" -def 0
  $c0    = ($d.spec.template.spec.containers | Select-Object -First 1)
  $img   = Get-JsonProp -obj $c0 -name "image" -def ""
  $lp    = Get-JsonProp -obj (Get-JsonProp -obj $c0 -name "livenessProbe"  -def @{}) -name "httpGet" -def @{}
  $rp    = Get-JsonProp -obj (Get-JsonProp -obj $c0 -name "readinessProbe" -def @{}) -name "httpGet" -def @{}
  $lpath = if($lp){ Get-JsonProp -obj $lp -name "path" -def "" } else { "" }
  $rpath = if($rp){ Get-JsonProp -obj $rp -name "path" -def "" } else { "" }
  $depRows += [pscustomobject]@{ Deploy=$dn; Replicas="$ready/$des"; Image=$img; Live=$lpath; Ready=$rpath }
}}

# Pods (*adapter*)
$podRows=@(); $pods = Invoke-Json { kubectl get pods -n $ns -o json }
if($pods){ foreach($p in $pods.items){
  $pn = Get-JsonProp -obj $p.metadata -name "name" -def ""
  if($pn -notmatch "(?i)adapter"){ continue }
  $phase = Get-JsonProp -obj $p.status -name "phase" -def ""
  $cs    = Get-JsonProp -obj $p.status -name "containerStatuses" -def @()
  $total = ($cs|Measure-Object).Count
  $ok    = ($cs|Where-Object {$_.ready}|Measure-Object).Count
  $reason = Get-JsonProp -obj $p.status -name "reason" -def ""
  if(-not $reason -and $cs){
    $first = $cs|Select-Object -First 1
    if($first -and (Has-JsonProp -obj $first -name "state")){
      $st = $first.state
      if(Has-JsonProp -obj $st -name "waiting"){    $reason = Get-JsonProp -obj $st.waiting    -name "reason" -def "" }
      elseif(Has-JsonProp -obj $st -name "terminated"){ $reason = Get-JsonProp -obj $st.terminated -name "reason" -def "" }
    }
  }
  if(-not $reason){
    $cf = (Get-JsonProp -obj $p.status -name "conditions" -def @()) | Where-Object {$_.status -eq "False"} | Select-Object -First 1
    if($cf){ $reason = $cf.reason }
  }
  if(-not $reason){ $reason = "" }
  $podRows += [pscustomobject]@{ Pod=$pn; Phase=$phase; Ready="$ok/$total"; Reason=$reason }
}}

# Services (*-adapter*)
$svcRows=@(); $svc = Invoke-Json { kubectl get svc -n $ns -o json }
if($svc){ foreach($s in $svc.items){
  $sn = Get-JsonProp -obj $s.metadata -name "name" -def ""
  if($sn -notmatch "(?i)\b(http|ws)-adapter\b"){ continue }
  $type  = Get-JsonProp -obj $s.spec -name "type" -def ""
  $ports=@()
  foreach($pr in (Get-JsonProp -obj $s.spec -name "ports" -def @())){ $ports += "$(Get-JsonProp -obj $pr -name "port" -def 0)->$(Get-JsonProp -obj $pr -name "targetPort" -def 0)" }
  $svcRows += [pscustomobject]@{ Service=$sn; Type=$type; Ports=($ports -join ",") }
}}

# Ingresses (routes to those services)
$ingRows=@(); $ing = Invoke-Json { kubectl get ingress -n $ns -o json }
if($ing){ foreach($i in $ing.items){
  $ingName = Get-JsonProp -obj $i.metadata -name "name" -def ""
  foreach($r in (Get-JsonProp -obj $i.spec -name "rules" -def @())){
    $hhost = Get-JsonProp -obj $r -name "host" -def ""
    $http  = Get-JsonProp -obj $r -name "http" -def $null
    foreach($p in (Get-JsonProp -obj $http -name "paths" -def @())){
      $b  = Get-JsonProp -obj $p  -name "backend" -def @{}
      $bs = Get-JsonProp -obj $b  -name "service" -def @{}
      $svcName = Get-JsonProp -obj $bs -name "name" -def ""
      if($svcName -match "(?i)\b(http|ws)-adapter\b"){
        $ingRows += [pscustomobject]@{
          Ingress=$ingName
          Host=$hhost
          Path=(Get-JsonProp -obj $p -name "path" -def "")
          Service=$svcName
          SvcPort=(Get-JsonProp -obj (Get-JsonProp -obj $bs -name "port" -def @{}) -name "number" -def 0)
        }
      }
    }
  }
}}

# Heuristics
$cause = "Unknown - use: kubectl describe deploy/pod svc/ingress"
if($svcRows.Count -eq 0){ $cause = "No adapter Services" }
if(($svcRows.Count -gt 0) -and ($ingRows.Count -eq 0)){ $cause = "No Ingress routes to adapters" }
$httpPending = ($podRows | Where-Object { $_.Pod -match "(?i)http-adapter" -and $_.Phase -ne "Running" } | Measure-Object).Count
if(($svcRows.Count -gt 0) -and ($ingRows.Count -gt 0) -and ($httpPending -gt 0)){ $cause = "Adapter pods Pending - check scheduling/image/PVC/events" }

# Samples
$depSample = if($depRows){ ($depRows|ForEach-Object{ "$($_.Deploy) $($_.Replicas) img=$($_.Image)" }) } else { @() }
$svcSample = if($svcRows){ ($svcRows|ForEach-Object{ "$($_.Service) $($_.Type) $($_.Ports)" }) } else { @() }
$ingSample = if($ingRows){ ($ingRows|ForEach-Object{ "$($_.Ingress) $($_.Host)$($_.Path) -> $($_.Service):$($_.SvcPort)" }) } else { @() }
$podSample = if($podRows){ ($podRows|ForEach-Object{ "$($_.Ready) $($_.Phase) $($_.Pod) [$($_.Reason)]" }) } else { @() }

# Print orange RESULTS
$kctx = (& kubectl config current-context 2>$null); if(-not $kctx){$kctx="(no kubectl context)"}
$lines = @()
$lines += "`e[38;5;208m==== RESULTS ==== `e[0m"
$lines += "KubeContext: $kctx"
$lines += "Namespace: $ns"
$lines += "Deployments: $($depRows.Count)"
$lines += "Services: $($svcRows.Count)"
$lines += "Ingresses: $($ingRows.Count)"
$lines += "Pods(Adapter): $($podRows.Count)"
$lines += "HTTP_PendingCount: $httpPending"
$lines += "WS_DeploymentsPresent: " + ( ($depRows|Where-Object { $_.Deploy -match '(?i)ws-adapter' }|Measure-Object).Count )
$lines += "LikelyCause: $cause"
$lines += "DeploySample: $(Compact-Join $depSample)"
$lines += "SvcSample: $(Compact-Join $svcSample)"
$lines += "IngSample: $(Compact-Join $ingSample)"
$lines += "PodSample: $(Compact-Join $podSample)"
$lines += "`e[38;5;208m==== END RESULTS ==== `e[0m"
$lines -join "`n"