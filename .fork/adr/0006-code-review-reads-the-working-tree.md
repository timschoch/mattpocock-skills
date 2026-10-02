# `code-review` reads the working tree, and its Standards reviewer hears only the standards

Three edits to `skills/engineering/code-review/SKILL.md`:

1. The diff command is `git diff --merge-base <fixed-point>`, not `git diff <fixed-point>...HEAD`.
2. Both sub-agent briefs end with: "Do not invoke `/code-review` or spawn more agents: do this review directly."
3. The Standards prompt list gains one bullet: pass nothing else, not the user's request, the spec, or the caller's notes.

## Why the diff reads the working tree

The three-dot form compares commits only. A change that is staged but not committed gives an empty diff, and the review has nothing to read.

That is the normal state of work in this fork's setup. skilly's sign-off rule (`workflow-sign-off.md`) says staged means "the agent is done" and committed means "the user signed it off". So the review has to run on staged work, before the commit. `/implement` has the same shape: it calls `/code-review` before it commits.

`git diff --merge-base <fixed-point>` compares the merge-base with the working tree. It shows committed, staged and unstaged changes to tracked files. With a clean working tree its output equals the three-dot diff, so a review of a pushed branch is unchanged.

The working tree, not the index (`--cached`): the sub-agents open the cited files on disk, so the diff and the files they read must be the same state. skilly's naming gate takes its file list the same way.

One gap stays: git leaves an untracked file out of the diff. The skill says to stage a new file first.

## Why the briefs forbid more reviews

A sub-agent that finds the skill can start its own review and fan out. Upstream's docs page reports a run that reached 50-plus agents. In this fork the risk is higher: a reviewer reads the same sign-off rule that started the review. One sentence in each brief stops it.

## Why the Standards reviewer gets nothing but the standards

The agent that wrote the code also writes the reviewer's prompt. In one test run it told the Standards reviewer that the code had to stay "exactly as written", and the reviewer reported 0 blocking findings. The same task without that hint gave blocking findings.

In this fork's setup the coding agent does not carry the detailed coding guidelines. The Standards reviewer is the only place they are applied, so a softened reviewer leaves nothing. This edit is not tested on its own: it comes from that one run.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/code-review/SKILL.md` | Diff command in step 1; one sentence in each brief and one bullet in the Standards list in step 4 |
| `docs/engineering/code-review.md` | Prerequisites, and two answers under Common questions (sub-agents that spawn more agents, uncommitted work) |
| `docs/engineering/implement.md` | The answer to "`code-review` says it cannot see my changes" |

Provenance: timschoch/mattpocock-skills#26 (2026-10-02). Evidence for edits 1 and 2: 16 of 16 subagent runs on a fixture repo reviewed a non-empty staged diff with two review agents and no more. Those runs used `git diff --cached --merge-base`. The shipped command drops `--cached`: it shows the same staged changes, plus unstaged ones.

## Resolving a conflict here

- Diff command: take the fork's side unless upstream's command also covers staged work. Then take upstream's and delete this ADR's first section.
- Brief sentence: additive. If upstream adds its own guard against recursion, take upstream's wording and drop the fork's sentence.
- Standards bullet: additive, keep it.
- Docs pages: take upstream's text, then make the three answers match the skill again.
