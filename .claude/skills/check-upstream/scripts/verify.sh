#!/usr/bin/env bash
# Post-merge check on the fork's work:
#   - every path the fork owned before the merge still exists, byte-identical
#   - every fork-only skill is still named in every file that named it before
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

# A fork-only skill also lives as an entry inside shared index files (READMEs,
# plugin.json, ask-matt). Merging upstream's version of those files can drop the
# entry while every fork-only file stays intact, so check the names too.
while IFS= read -r name; do
  [ -n "$name" ] || continue
  gone="$(comm -23 \
    <(git grep -l -F -- "$name" "$PRE" | sed "s|^$PRE:||" | sort) \
    <(git grep -l -F -- "$name" HEAD | sed 's|^HEAD:||' | sort))"
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    echo "UNINDEXED  $name no longer named in $f"
    drift=1
  done <<<"$gone"
done < <(fork_only_paths "$PRE" "$U" | sed -n 's|^skills/[^/]*/\([^/]*\)/SKILL.md$|\1|p')

if [ "$drift" -eq 0 ]; then
  echo "ok — every fork-only path intact, every fork-only skill still indexed"
fi
exit "$drift"
