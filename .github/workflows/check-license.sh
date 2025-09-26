#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

mapfile -t candidates < <(git ls-files '*.ps1' '*.psm1' '*.psd1' '*.sh')

missing=()
for file in "${candidates[@]}"; do
  [[ -f "$file" ]] || continue
  header="$(head -n 5 "$file")"
  if [[ "$header" != *"SPDX-License-Identifier: Apache-2.0"* ]]; then
    missing+=("$file")
    continue
  fi
  if [[ "$header" != *"Copyright (c"* ]]; then
    missing+=("$file")
    continue
  fi
done

if (( ${#missing[@]} )); then
  echo "Missing required SPDX header in the following files:"
  for file in "${missing[@]}"; do
    echo " - $file"
  done
  echo ""
  echo "If this job failed due to a missing SPDX header, add the following within the first 5 lines:"
  echo "# SPDX-License-Identifier: Apache-2.0"
  echo "# Copyright (c) CHOOVIO Inc."
  exit 1
fi

echo "All checked files contain the required SPDX header."
