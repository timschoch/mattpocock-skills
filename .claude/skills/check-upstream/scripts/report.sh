#!/usr/bin/env bash
# Read-only. Prints what upstream has that this fork does not, and what merging it would cost.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 2
. "$(dirname "$0")/lib.sh"

REMOTE="${1:-upstream}"
UB="$(resolve_upstream "$REMOTE")" || exit 2
U="$(git rev-parse "$UB")"
B="$(git merge-base HEAD "$U")"

echo "## Refs"
echo "upstream:   $UB @ $(git rev-parse --short "$U")"
echo "local:      $(git rev-parse --abbrev-ref HEAD) @ $(git rev-parse --short HEAD)"
echo "fork point: $(git rev-parse --short "$B")  ($(git rev-list --count "$B..HEAD") local commits ahead)"

if [ "$B" = "$U" ]; then
  echo
  echo "## Verdict"
  echo "up to date"
  exit 0
fi

echo
echo "## Upstream commits since the fork point (oldest first)"
git log --reverse --oneline --no-merges "$B..$U"

echo
echo "## Files upstream changed"
git diff --stat "$B" "$U"

echo
echo "## Release state"
echo "version: local $(pkg_version HEAD) -> upstream $(pkg_version "$U")"
REL="$(git log --format=%H -1 --grep='^chore: version skills' "$U")"
if [ -n "$REL" ]; then
  echo "last release commit: $(git log --oneline -1 "$REL")"
  TAIL="$(git log --oneline --no-merges "$REL..$U")"
  if [ -n "$TAIL" ]; then
    echo "unreleased tail (ships in the next version):"
    echo "$TAIL" | sed 's/^/  /'
  else
    echo "unreleased tail: none — every upstream commit is released"
  fi
else
  echo "last release commit: none found"
fi
PEND="$(git ls-tree -r --name-only "$U" -- .changeset | grep -v -e 'README.md$' -e 'config.json$')"
if [ -n "$PEND" ]; then
  echo "pending changesets upstream:"
  echo "$PEND" | sed 's/^/  /'
else
  echo "pending changesets upstream: none"
fi

echo
echo "## Fork-only paths (must survive the merge)"
fork_only_paths HEAD "$U" | sed 's/^/  /'

echo
echo "## Merge preview"
MT="$(git merge-tree --write-tree --name-only HEAD "$U")"; MT_RC=$?
if [ "$MT_RC" -eq 0 ]; then
  echo "clean — no conflicts"
else
  echo "conflicts in:"
  echo "$MT" | sed -n '2,/^$/p' | sed '/^$/d' | sed 's/^/  /'
fi
