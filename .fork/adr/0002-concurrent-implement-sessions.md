# `/implement` runs concurrently: its own worktree, and `in-progress` as the claim

Upstream's `/implement` assumes one agent, in one checkout, on one ticket. It says "Implement the work described by the user in the spec or tickets" and "Commit your work to the current branch", and nothing else about where the work happens or who else might be doing it.

This fork runs several `/implement` sessions at once, one per ticket off a `/to-tickets` run. Two things break immediately at that scale, and both are fixed here.

## Isolation: a worktree per session

Two agents editing one checkout corrupt each other's work in a way neither can detect: agent A's uncommitted edit is on disk when agent B runs its tests, so B's green run proves nothing about B's change.

`/implement` therefore starts on **a separate worktree, based off the current branch**. That is the whole change to the opening line, and it is a precondition for everything below: a claim is only meaningful if the claimant has somewhere private to work.

## Mutual exclusion: `in-progress` is the claim

Isolation stops agents from corrupting each other. It does not stop two agents from doing the same ticket twice. The tracker is the only thing both agents can see, so the claim lives there.

- **Claim before editing.** Check `gh issue view N --json labels,comments` first. If `in-progress` is already set, another agent may be on it: read the latest `🤖 in-progress` comment, inspect *that branch's* real state, and skip or coordinate. Then `gh issue edit N --add-label in-progress --remove-label ready-for-agent` and post a claim comment.
- **The claim comment names the branch**, not a worktree path. A colliding agent needs to inspect what the other one actually produced (an open PR? commits? an abandoned branch?), and only the branch survives long enough to answer that. A worktree path on another machine tells it nothing.
- **Claiming is idempotent.** Re-running `/implement` on the same issue must not error: adding a label already present, removing a `ready-for-agent` already gone, and re-commenting are all tolerated. An agent that dies mid-run gets retried, and a retry that errors on its own previous claim is worse than no claim.
- **Release on PR.** `gh issue edit N --remove-label in-progress` when the work is handed to review. If the flow ends without a PR, the label stays: an abandoned claim is a fact worth leaving visible, and the `cleanup-merged-branches` reaper releases it.
- **Never restore `ready-for-agent` on success.** The issue closes on merge; putting it back would re-offer finished work.

## `/wayfinder` uses the same label

`/wayfinder` already claims a ticket by **assigning** it. The fork adds the `in-progress` label alongside, and removes it on resolution.

The assignee alone is not enough once `/implement` is in the picture. An assignee says *a human owns this*; `in-progress` says *an agent is writing code against this right now*. They are different states with different recovery, and one signal cannot carry both. Sharing the label across both skills means one query answers "what is being worked on" regardless of which skill claimed it.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/implement/SKILL.md` | Opening line adds the worktree; "Claim the issue first" and "Release the claim" sections added whole |
| `skills/engineering/wayfinder/SKILL.md` | Steps 2 and 4 of the loop add and remove `in-progress` |

Provenance: `97288ac` (2026-07-06, worktree), `7603ea5` (2026-07-07, claim/release), refined in `8ca5928` (#1) and `c40f14a` (#2), and `d8e73eb` (#9, 2026-07-09) for `/wayfinder`.

## Resolving a conflict here

Both edits are additive: upstream's lines are untouched, the fork's sit next to them. Apply upstream's edit and keep both blocks. The dependency runs one way, so if either has to go, drop the claim protocol and keep the worktree, never the reverse: a claim with no isolation is a lock protecting nothing.

If upstream ever adds its own claim mechanism, take upstream's side whole and delete this ADR, but check first that `/wayfinder` and `/implement` still agree on one signal.
