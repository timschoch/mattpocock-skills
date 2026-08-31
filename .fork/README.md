# `.fork/`: this fork's own documentation

Everything in here is written by the fork ([timschoch/mattpocock-skills](https://github.com/timschoch/mattpocock-skills)) and never by upstream ([mattpocock/skills](https://github.com/mattpocock/skills)). Upstream has no `.fork/`, so nothing in this directory can ever conflict on a sync, and `check-upstream`'s "fork-only paths must survive the merge" check covers it by construction.

Do **not** put fork material in `.agents/adr/` or extend the top-level `CONTEXT.md`. Those are upstream's: our next ADR number and Matt's next ADR number are the same number, and the top-level glossary is his vocabulary.

| Path | Holds |
| --- | --- |
| `adr/` | Fork ADRs, own numbering, independent of `.agents/adr/` |
| `CONTEXT.md` | Fork-only vocabulary; upstream's `CONTEXT.md` stays upstream's |

`check-upstream` itself stays at `.claude/skills/check-upstream/`, where the harness looks for it. `.fork/` is documentation, not code.

## What earns an ADR

A divergence from upstream that carries **behaviour**: a rule the fork added, relaxed, or reversed in one of Matt's skills. Not a `.gitignore` line or an action version pin; the list of edited files is derivable and needs no prose:

```bash
git diff --diff-filter=M --name-only "$(git merge-base HEAD upstream/main)" HEAD
```

An ADR exists so a future merge conflict can be resolved on intent rather than on guesswork. Name the files it governs, so the person resolving the conflict finds it.

## ADRs

- [0001: Specs and tickets link to their parent as native sub-issues](./adr/0001-native-sub-issue-links-for-specs-and-tickets.md)

## Behaviour still to record

Two fork behaviours diverge from upstream with no ADR yet:

- **`in-progress` as the claim signal**, in `skills/engineering/implement/SKILL.md` (claim/release an issue around the work) and `skills/engineering/wayfinder/SKILL.md` (label alongside the assignee).
- **`Related:` as a non-blocking edge**, in `skills/engineering/wayfinder/SKILL.md` and the github and local variants of `skills/engineering/setup-matt-pocock-skills/issue-tracker-*.md`. The gitlab variant deliberately stays at upstream's version: we do not use GitLab, so it is not worth a recurring conflict.
