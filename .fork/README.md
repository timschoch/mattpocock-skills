# `.fork/`: this fork's own documentation

Everything in here is written by the fork ([timschoch/mattpocock-skills](https://github.com/timschoch/mattpocock-skills)) and never by upstream ([mattpocock/skills](https://github.com/mattpocock/skills)). Upstream has no `.fork/`, so nothing in this directory can ever conflict on a sync, and `check-upstream`'s "fork-only paths must survive the merge" check covers it by construction.

Do **not** put fork material in `.agents/adr/` or extend the top-level `CONTEXT.md`. Those are upstream's: our next ADR number and Matt's next ADR number are the same number, and the top-level glossary is his vocabulary.

| Path | Holds |
| --- | --- |
| `adr/` | Fork ADRs, own numbering, independent of `.agents/adr/` |
| `CONTEXT.md` | Fork-only vocabulary; upstream's `CONTEXT.md` stays upstream's |

`check-upstream` itself stays at `.claude/skills/check-upstream/`, where the harness looks for it. `.fork/` is documentation, not code.

## What earns an ADR

**Every fork edit to a skill or its docs page.** No exceptions: an unexplained edit to one of Matt's skills is indistinguishable from a merge artefact, and the next sync deletes it or keeps it by coin flip. If a change is worth carrying through every future merge, it is worth a paragraph saying why.

Infrastructure edits are the one thing outside this rule, and they are enumerated below instead. The line is not "how big" but "does a human resolving a conflict need intent": a version pin resolves itself, a relaxed rule does not.

The list of edited files is derivable, so it is never written down by hand:

```bash
git diff --diff-filter=M --name-only "$(git merge-base HEAD upstream/main)" HEAD
```

Every path that command prints is either covered by an ADR below or listed under Infrastructure edits. Anything else is a bug in this directory. `check-upstream`'s `REVIEW` check reads the same list.

An ADR exists so a future merge conflict can be resolved on intent rather than on guesswork. Name the files it governs, so the person resolving the conflict finds it.

## ADRs

- [0001: Specs and tickets link to their parent as native sub-issues](./adr/0001-native-sub-issue-links-for-specs-and-tickets.md)
- [0002: `/implement` runs concurrently: its own worktree, and `in-progress` as the claim](./adr/0002-concurrent-implement-sessions.md)
- [0003: `Related:` records the edge that does not block](./adr/0003-related-as-a-non-blocking-edge.md)
- [0004: `/implement` closes the Chrome tabs it opened](./adr/0004-implement-closes-its-chrome-tabs.md)
- [0005: `ask-matt` routes to skills that live in another repo](./adr/0005-ask-matt-routes-to-skills-from-elsewhere.md)

## Infrastructure edits

Four fork edits touch no skill and carry no behaviour. Each is one line with a self-evident reason, so each gets a row here rather than a document.

| File | Fork edit | Why | On conflict |
| --- | --- | --- | --- |
| `README.md` | Two-line fork banner after the header block | Says which repo you are looking at and which one to install | Take upstream's file whole, re-insert the banner. `check-upstream` step 5 has the exact rule |
| `.changeset/config.json` | `changelog.repo` points at `timschoch/mattpocock-skills` | The fork's releases must link to the fork's PRs. Taking upstream's side silently repoints the changelog at Matt's repo | Always the fork's side |
| `.github/workflows/release.yml` | `actions/checkout` and `actions/setup-node` pinned to v7 | Upstream still runs v4 | Take the higher pin |
| `.gitignore` | `.temp`, and un-ignore `.claude/skills/check-upstream/` | Upstream ignores `.claude` whole, which would hide `check-upstream` itself | Keep both fork rules |

## What is deliberately *not* carried

- **`skills/engineering/setup-matt-pocock-skills/issue-tracker-gitlab.md`** stays byte-identical to upstream, while the github and local variants take the `Related:` edit from [0003](./adr/0003-related-as-a-non-blocking-edge.md). The fork does not use GitLab, so the edit would buy nothing and cost a conflict on every upstream touch of that file.

The general rule: revert to upstream wherever the fork gains nothing. Every carried edit is a merge conflict the fork pays for forever.
