---
name: check-upstream
description: Compare this fork with its upstream and merge upstream in. Use when the user asks whether upstream has changes, wants the upstream diff reviewed, or wants upstream merged into the fork.
---

Compare `upstream` (mattpocock/skills) with this fork, recommend what to do, and — on an explicit go — merge it in as a PR that leaves every fork-only change standing.

Repo-local by design: it lives in `.claude/skills/`, outside `skills/`, so neither `scripts/link-skills.sh` nor a consumer's `skills update` distributes it. Keep it here.

Steps 1–3 are read-only. Nothing merges before a clear yes.

## Steps

1. **Report.** Run `bash .claude/skills/check-upstream/scripts/report.sh` — refs, upstream commits since the fork point, the files upstream changed, release state, fork-only paths, and a merge preview naming every file that will conflict. Done when you have its output. `up to date` → report that and stop.

2. **Recommend.** Read the diff behind each commit the report lists (`git show <sha>`); subject lines hide what actually changed. Give every one a verdict:

   - **take** — wanted, lands on paths the fork left alone.
   - **collides** — touches a file this fork has edited; name the fork behaviour at risk.
   - **irrelevant** — touches only paths this fork does not carry.

   Then split them on the release boundary the report prints: commits at or below the last version bump are **released**; the tail above it ships in the next version. Land on one recommendation — merge now, wait for the release, or merge with named edits — and give the reason in a line.

   Done when every commit carries a verdict and one recommendation stands.

3. **Gate.** Show the verdicts, the conflict list, and the recommendation, then ask for explicit go. Merge only on a clear yes.

4. **Merge.** Branch off the fork's default branch — `git switch -c sync/upstream-$(date +%Y-%m-%d) main` — so whatever branch you were working on stays out of the sync PR. Record that base's sha (`git rev-parse main`); step 6 needs it. Then `git merge upstream/main`.

5. **Resolve.** Every conflict falls into one class:

   - **Index files** — `README.md`, `skills/*/README.md`, `.claude-plugin/plugin.json`, `skills/engineering/ask-matt/SKILL.md`. Resolve as a **union**: every upstream entry and every fork-only entry survives. Fork-authored skills live in `skills/fork/`, listed in `skills/fork/README.md` and under the top-level `README.md`'s **Fork** heading — a block upstream never writes to, so a conflict there is a merge artefact, not a real edit. Take the fork's side of that block whole.
   - **Version files** — `package.json`, the `version` field in `.claude-plugin/plugin.json`, `CHANGELOG.md`. Take upstream's side whole.
   - **`.changeset/`** — keep both sides' entries.
   - **Shared skills the fork edited** — apply upstream's edit around the fork's behaviour. When the two genuinely contradict, stop and ask the user which wins.

6. **Verify.** `bash .claude/skills/check-upstream/scripts/verify.sh <pre-merge sha>` — every fork-only path still byte-identical, every fork-only skill still named in each index file that named it. Then `claude plugin validate . --strict`. Done when both pass. Whatever verify.sh flags is either restored or explained to the user as a deliberate resolution.

   The sync branch carries these scripts, since it branches off the default branch. While this skill still sits on an unmerged branch, extract them first — `git archive <branch> .claude/skills/check-upstream | tar -x -C .temp/` — and run that copy.

7. **PR.** `gh pr create --repo <fork> --base <default branch>`. Name the fork explicitly: on a fork, `gh` aims at the upstream parent by default, which fails as `does not have the correct permissions to execute CreatePullRequest`. Body: the merged range, each resolution you made, and whatever still needs the user's eye. Report the URL.
