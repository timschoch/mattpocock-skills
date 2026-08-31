# Fork vocabulary

Extends the top-level [CONTEXT.md](../CONTEXT.md), which is upstream's and stays upstream's. Only terms this fork needs live here.

## Language

**Upstream**:
[mattpocock/skills](https://github.com/mattpocock/skills), reachable as the `upstream` git remote. The source of every file in this repo except the **fork-only paths**.
_Avoid_: origin (that is the fork), Matt's repo

**Fork**:
[timschoch/mattpocock-skills](https://github.com/timschoch/mattpocock-skills), the `origin` remote and this working copy.

**Fork-only path**:
A path that exists in the fork and not in **Upstream** — computed, never listed by hand, as `fork_only_paths` in `.claude/skills/check-upstream/scripts/lib.sh`. `check-upstream` requires every one to survive a sync byte-identical.

**Fork edit**:
A change to a file the fork shares with **Upstream**. This is what the fork is actually for, and the whole conflict surface of a sync. Derivable as `git diff --diff-filter=M --name-only "$(git merge-base HEAD upstream/main)" HEAD`.
_Avoid_: patch, customisation, override

**Sync**:
One run of `check-upstream`: merge **Upstream** into the fork, resolve, verify, open a PR. Distinct from the `skills-sync` workflow, which pushes *from* this fork to consumers.

## Relationships

- A **Sync** must leave every **Fork-only path** intact and every **Fork edit** still doing its job
- A **Fork edit** that carries behaviour earns an ADR in [`.fork/adr/`](./adr/); a **Fork-only path** does not need one
