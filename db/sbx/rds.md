# Copyright (c) CHOOVIO
# SPDX-License-Identifier: Apache-2.0

Engine: Amazon RDS PostgreSQL (v16.x/17.x acceptable; SBX launched as selected in console)

Instance: db.t3.micro, gp3 20 GiB (+ autoscaling)

DB identifier: gobee-sbx-pg

DB name: gobee

Master user: gobee

Endpoint: to be pasted from AWS console after Available

Port: 5432

VPC/Subnets: SBX VPC, private subnets

Public access: No

Security group: eks-cluster-sg-gobee-sbx-1538475434 (allows EKS→DB)

Secrets: NOT stored in repo. Password kept outside git (AWS Secrets Manager/K8s secret).

Cutover plan: set PGHOST in SBX overlay for bootstrap, users, domains, certs, provision; then delete in-cluster Postgres deploy/svc/pvc after verification.
