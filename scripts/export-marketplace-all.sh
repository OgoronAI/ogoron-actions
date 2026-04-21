#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <marketplace-root-dir>" >&2
  exit 2
fi

MARKETPLACE_ROOT="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A REPO_NAMES=(
  [setup]="ogoron-setup-action"
  [exec]="ogoron-exec-action"
  [generate]="ogoron-generate-action"
  [heal]="ogoron-heal-action"
  [run]="ogoron-run-action"
)

for action in setup exec generate heal run; do
  target="${MARKETPLACE_ROOT}/${REPO_NAMES[$action]}"
  "${SCRIPT_DIR}/export-marketplace-action.sh" "${action}" "${target}"
done
