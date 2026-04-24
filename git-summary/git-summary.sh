#!/usr/bin/env bash
# Usage: git-summary.sh <hash>
# Emits a deployment summary block: project folder header + one line per commit
# from <hash> (inclusive) through HEAD, in `    - <short>: <subject>` form.
set -euo pipefail

if [[ $# -lt 1 || -z "${1:-}" ]]; then
  echo "usage: git-summary.sh <hash>" >&2
  exit 1
fi

hash="$1"

if ! git rev-parse --verify "${hash}^{commit}" >/dev/null 2>&1; then
  echo "error: '${hash}' is not a valid commit in this repo" >&2
  exit 1
fi

project="$(basename "$(git rev-parse --show-toplevel)")"

printf '%s:\n' "$project"
git log --format='  - %h: %s' "${hash}^..HEAD"
