# `code-review` reviewers stay in their lane, and `implement` commits before it reviews

Three fork edits:

1. Both `code-review` sub-agent briefs end with: "Do not invoke `/code-review` or spawn more agents: do this review directly."
2. The Standards prompt list gains one bullet: pass nothing else, not the user's request, the spec, or the caller's notes.
3. `implement` commits first, then calls `/code-review`. Upstream reviews first and commits after.

## Why the briefs forbid more reviews

A sub-agent that finds the skill can start its own review and fan out. Upstream's docs page reports a run that reached 50-plus agents. In this fork the risk is higher: a reviewer reads the same sign-off rule that started the review.

Upstream rejects this guard on purpose (`.out-of-scope/subagent-recursion.md`): loops are the harness's job. The fork keeps it anyway. The harnesses this fork runs in do not stop the fan-out, and this fork has hit it in real sessions. One sentence per brief is cheaper than one runaway review.

## Why the Standards reviewer gets nothing but the standards

The agent that wrote the code also writes the reviewer's prompt. In one test run it told the Standards reviewer that the code had to stay "exactly as written", and the reviewer reported 0 blocking findings. The same task without that hint gave blocking findings.

In this fork's setup the coding agent does not carry the detailed coding guidelines. The Standards reviewer is the only place they are applied, so a softened reviewer leaves nothing. This edit is not tested on its own: it comes from that one run.

## Why `implement` commits before it reviews

`code-review` diffs `<fixed-point>...HEAD`, which holds committed work only. Upstream's `implement` calls the review before its commit, so unless an interim commit exists the review reads an empty diff. Upstream's own docs page says "Commit first, then review". The fork puts the two lines in that order.

skilly's sign-off rule matches: the review runs on committed work. An earlier fork edit made `code-review` read the working tree instead, for a sign-off rule where staged meant done. That rule moved to committed work, so the fork takes upstream's diff command.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/code-review/SKILL.md` | One sentence in each brief and one bullet in the Standards list in step 4 |
| `skills/engineering/implement/SKILL.md` | Commit line before the `code-review` line |
| `docs/engineering/code-review.md` | Prerequisites, and the answer on sub-agents that spawn more agents |

Provenance: timschoch/mattpocock-skills#26 (2026-10-02) for edits 1 and 2: 16 of 16 subagent runs on a fixture repo reviewed with two review agents and no more. Edit 3 and the return to upstream's diff command: the 2026-10-17 sync.

## Resolving a conflict here

- Brief sentence: additive. If upstream adds its own guard against recursion, take upstream's wording and drop the fork's sentence.
- Standards bullet: additive, keep it.
- Commit order: if upstream moves its commit line above the review, take upstream's side and drop edit 3.
- Docs pages: take upstream's text, then make the answers match the skill again.
