# `ask-matt` routes to skills that live in another repo

`ask-matt` is the router: it maps every user-reachable skill and how they relate. The fork added three routes to skills it wrote itself, `/orchestrate`, `/step-by-step`, and (from `/implement`) the `cleanup-merged-branches` reaper.

Those skills used to live here, under a `skills/fork/` bucket. They do not any more: they moved to a personal skills hub that composes skills from several sources into one install. The routes stayed.

## Why the routes stayed after the skills left

A router that omits a skill the user has installed is a router that lies, in exactly the way this repo's `CLAUDE.md` warns about. The reader of `ask-matt` is a human deciding what to reach for next, and what they can reach for is decided by what they installed, not by which repository a file happens to sit in.

Anyone installing this fork installs it through the hub, which also carries those three skills. So the names resolve for every real reader, and the routes are accurate. Splitting the router along repository lines would make it wrong for the only audience it has.

Each mention is marked **"(installed separately)"**, so a reader who somehow has this repo alone can tell a missing skill from a broken route. That is the whole accommodation. No "install the hub first" caveat, no conditional prose, no per-skill availability check: routes are descriptive, and the distribution model makes them true.

## What the routes say

- **`/orchestrate`**, in step 3 of the main flow, is the parallel alternative to running `/implement` per ticket by hand. The added sub-bullet answers "serial or parallel?": `/implement` per ticket is the default and the only option on a local tracker; `/orchestrate` takes a parent issue whose sub-issues are genuinely independent, spawns one `/implement` agent per sub-issue on its own worktree, and owns the mechanical tail. It never re-slices the work. This is the payoff of [0001](./0001-native-sub-issue-links-for-specs-and-tickets.md): native sub-issues are what make the packages addressable, so `/orchestrate` needs GitHub, not local files.
- **`/step-by-step`**, in the off-the-main-flow list, is the human-procedure walkthrough, contrasted with `/wizard`: `/wizard` bottles a procedure into a re-runnable bash script, `/step-by-step` walks you through it once.
- **`cleanup-merged-branches`** is named in `skills/engineering/implement/SKILL.md` as the reaper that releases abandoned claims. Its behaviour belongs to [0002](./0002-concurrent-implement-sessions.md); it is listed here only because it is the third reference pointing out of this repo.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/ask-matt/SKILL.md` | `/orchestrate` in step 3 plus the serial-or-parallel sub-bullet; `/step-by-step` in the off-flow list |

Provenance: `776ff6a` (2026-07-30, `/orchestrate`), `2eb4016` (#14, 2026-08-15, `/step-by-step`). Both predate the move to the hub; the skills left in the sync that landed as `origin/main` PR #20, and the routes were kept on purpose.

## Resolving a conflict here

`ask-matt` is the one index file resolved as a **union**, and this is why: every other index (`skills/*/README.md`, `.claude-plugin/plugin.json`) takes upstream's side whole, because the fork ships no skills of its own here. `ask-matt` is different because it describes what the reader can reach, not what this repo contains.

Apply upstream's edit and keep both fork mentions. If a route ever points at a skill the hub no longer carries, delete the route rather than adding a caveat.
