# Specs and tickets link to their parent as native sub-issues, by default

Upstream's `to-spec` publishes a spec issue and `to-tickets` publishes one issue per ticket. Neither is required to attach the result to the issue it came from. `to-tickets` says to use "the platform's native blocking / sub-issue relationship **where it has one**", which in practice reads as optional, and the tickets land as a flat set of issues that merely mention their epic in prose.

Upstream knows this fails: [issue #554](https://github.com/mattpocock/skills/issues/554) reports it across a dozen runs and several models, worse on Codex than on Claude, and upstream's own docs page calls it "known and unfixed".

## Why prose is not enough

A parent link written into a body is invisible to everything that matters. The tracker cannot render it, so a human scanning the issue list cannot see which epic a ticket belongs to. The frontier query cannot use it. Closing the last child does not surface the epic. And an agent picking up a ticket has no cheap way back to the spec that produced it — the exact context it needs most.

The native relationship — GitHub's sub-issues, Linear's parent — costs one flag at creation time and gives all of that for free. `gh` has supported it since v2.94: `gh issue create --parent <n>`, and `gh issue edit <parent> --add-sub-issue <n>` after the fact.

## Decision

- `to-spec`: when the spec refines an existing parent issue — the conversation started from an epic, or the user passed its reference — link the published spec as a **native sub-issue** of that parent.
- `to-tickets`: link **every** ticket to its parent as a native sub-issue, by default, not "where convenient". When the source was an existing epic or spec issue, that issue is the parent. Wire each blocker as a native blocking edge the same way.
- The `## Parent` / `## Blocked by` body sections stay, demoted to a **fallback** for trackers with no native relationship.

## Consequence: the parent rule had to be relaxed

Upstream's `to-tickets` ends with **"Do NOT close or modify any parent issue."** Adding a sub-issue modifies the parent, so the rule as written forbids the decision above.

The fork narrows it instead of dropping it: **"Do NOT close the parent issue or edit its title, body, or state — linking tickets under it as native sub-issues is expected, nothing more."** The intent upstream is guarding — an agent must not resolve or rewrite work it was only asked to decompose — survives intact. Only the sub-issue link is carved out.

This is the load-bearing half of the ADR. A future sync that takes upstream's side on that one line reinstates a rule that contradicts the rest of the fork's behaviour, and nothing will fail loudly when it does.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/to-tickets/SKILL.md` | Sub-issue link by default; blocking edges native; body sections demoted to fallback; the parent rule narrowed |
| `skills/engineering/to-spec/SKILL.md` | Link the spec under its parent when it refines one |
| `docs/engineering/to-tickets.md` | The "known and unfixed" note rewritten as fixed in this fork |
| `docs/engineering/to-spec.md` | Prerequisites mention the parent link |

Provenance: `be70efb` (2026-07-07), written against the skills' former names `to-prd` / `to-issues`; carried through upstream's rename in `386d4ff` and reconciled inside merge `18059c0`. Recorded here after the fact — the behaviour existed for weeks with no stated reason anywhere, which is what this directory exists to prevent.

## Resolving a conflict here

Take the fork's side on the sub-issue instruction and on the parent rule. Apply upstream's edit around them. If upstream ever adopts native sub-issues itself, take upstream's side whole and delete this ADR — the divergence is gone.
