#!/usr/bin/env bash
# Shared by report.sh and verify.sh.

# Fetch the remote and echo its default branch ref (e.g. "upstream/main").
resolve_upstream() {
  local remote="${1:-upstream}" ref
  git remote get-url "$remote" >/dev/null 2>&1 || {
    echo "error: no '$remote' remote. Add it:" >&2
    echo "  git remote add upstream https://github.com/mattpocock/skills.git" >&2
    return 2
  }
  git fetch "$remote" --quiet || return 2
  ref="$(git symbolic-ref --quiet --short "refs/remotes/$remote/HEAD" 2>/dev/null)"
  echo "${ref:-$remote/main}"
}

# Paths present in $1 but absent from $2 — the fork's own files.
fork_only_paths() {
  comm -23 <(git ls-tree -r --name-only "$1" | sort) <(git ls-tree -r --name-only "$2" | sort)
}

# Value of "version" in a rev's package.json.
pkg_version() {
  git show "$1:package.json" 2>/dev/null | sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' | sed -n 1p
}
