#!/usr/bin/env bash
# Post-merge check: every path the fork owned before the merge still exists, byte-identical.
# usage: verify.sh <pre-merge-sha> [remote]
set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 2
. "$(dirname "$0")/lib.sh"

PRE="${1:-}"
[ -n "$PRE" ] || { echo "usage: verify.sh <pre-merge-sha> [remote]" >&2; exit 2; }
UB="$(resolve_upstream "${2:-upstream}")" || exit 2
U="$(git rev-parse "$UB")"

drift=0
while IFS= read -r p; do
  [ -n "$p" ] || continue
  if ! git cat-file -e "HEAD:$p" 2>/dev/null; then
    echo "MISSING  $p"
    drift=1
    continue
  fi
  if [ "$(git rev-parse "$PRE:$p")" != "$(git rev-parse "HEAD:$p")" ]; then
    echo "CHANGED  $p"
    drift=1
  fi
done < <(fork_only_paths "$PRE" "$U")

if [ "$drift" -eq 0 ]; then
  echo "ok — every fork-only path intact"
fi
exit "$drift"
