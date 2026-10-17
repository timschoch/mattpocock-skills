# Tickets carry a finish line, and blocking review findings are checked

Two fork edits from `c22c4aa` (2026-09-27), recorded here at the 2026-10-17 sync.

## `to-tickets`: "Done means" and "Stop and ask only if"

Each ticket carries two sections instead of upstream's "Acceptance criteria":

- **Done means**: the acceptance criteria, each one an observation that is false at the starting commit and true when the work is finished.
- **Stop and ask only if**: the one situation the implementer cannot decide alone, or "None: decide and note it in the PR".

Why: this fork runs tickets with agents that work alone (`/implement`, `/orchestrate`). An agent alone needs to know when it is done and when to stop. Without a stop condition it either asks about everything or decides everything. Anthropic's Opus 5.5 prompting guide names both as the first things to put in a task. "False at the starting commit" stops the failure upstream's docs page lists: a criterion already true at the base commit.

## `code-review`: check every blocking finding

Before it presents the reports, the skill opens the cited file and line of every **blocking** finding and confirms the finding. A finding it cannot confirm is marked **unconfirmed**, with where it looked. Each finding gives file and line, and a blocking one says how to show it fails. Blocking findings come first within each axis.

Why: sub-agent output is a hypothesis. A wrong blocking finding costs a fix round on code that was fine. skilly's sign-off rule sends blocking findings to a fresh fix agent with no second review, so a false one is acted on with nobody checking it. Only blocking findings are checked: they are the ones that trigger work.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/to-tickets/SKILL.md` | Finish-line paragraph before publishing; "Done means" and "Stop and ask only if" in the ticket template |
| `skills/engineering/code-review/SKILL.md` | Finding format in the Standards brief; evidence check and ordering in step 5 |
| `docs/engineering/to-tickets.md` | The criteria answer: the skill now asks for criteria that fail at the base commit |
| `docs/engineering/code-review.md` | The "trust the findings" answer, and the finding line in "It's working if" |

## Resolving a conflict here

All additive. Apply upstream's edit and keep the fork sections. If upstream adds its own stop condition or evidence check, take upstream's and drop the fork's.
