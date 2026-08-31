# `Related:` records the edge that does not block

Upstream's tracker vocabulary has exactly two edges between tickets: **parent/child** (a ticket belongs to a map) and **blocked by** (a ticket cannot start until another closes). Both are load-bearing, and both are native relationships in a real tracker.

Neither describes the edge that shows up most often in practice: two tickets whose outcomes bear on each other, where neither has to wait. A prototype ticket that will probably invalidate a task ticket. A decision on one map that changes the shape of another. Recording that as `Blocked by:` is a lie that stalls the frontier; recording it nowhere loses it.

## Why it cannot be inferred later

The connection is obvious to the session holding both contexts and invisible to everyone after. Months later a reader sees two open tickets that happen to touch the same area and cannot tell whether that is a real dependency, a coincidence, or a decision somebody already made. Re-deriving it costs more than writing it did, and the answer is a guess.

So the *why* is part of the record, not an optional note: **`Related: #n (why)`**. A bare `Related: #n` is the failure case, because it preserves only the half a reader could have worked out on their own.

## Decision

- Declare the edge in the ticket body as `Related: #n (why)` (`Related: NN (why)` on a local tracker). One wire format across every tracker doc.
- It is a body convention on purpose. GitHub has no native "related" relationship, and inventing one out of labels or task lists would make it look like a gate.
- **It never gates the frontier.** The frontier query drops tickets with an open blocker or an assignee, and `Related:` is neither. A related ticket stays grabbable.
- Written once, by the session that has the context, and never inferred afterwards.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/wayfinder/SKILL.md` | `Related:` bullet in the edge vocabulary |
| `docs/engineering/wayfinder.md` | The human-facing paragraph on why the edge exists |
| `skills/engineering/setup-matt-pocock-skills/issue-tracker-github.md` | `Related:` entry, with "no native GitHub relationship" stated |
| `skills/engineering/setup-matt-pocock-skills/issue-tracker-local.md` | `Related:` entry for the local `.scratch/` tracker |

**`issue-tracker-gitlab.md` is deliberately left at upstream's version.** The fork does not use GitLab, so carrying a fourth copy of this edit would buy nothing and cost a merge conflict on every upstream touch of that file. If the fork ever adopts GitLab, add it then.

Provenance: `6b23ea3` (#10, 2026-07-31). The wire format was unified to `Related: #n (why)` across all three files in `f8d6f50` (2026-08-31); before that the three docs disagreed on punctuation.

## Resolving a conflict here

Purely additive: one bullet per tracker doc, one paragraph in the docs page. Apply upstream's edit and keep the bullet. Keep the wire format identical across all files, since a skill reading one doc and a human reading another must produce the same line.

If upstream adds a native "related" relationship, take upstream's side whole and delete this ADR.
