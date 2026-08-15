# Fork

Skills written in this fork, not in upstream. They ship in the plugin like the other promoted buckets; keeping them in one bucket keeps them out of upstream's index files, so an upstream merge has nothing of ours to trample.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[orchestrate](./orchestrate/SKILL.md)** — Run an already-ticketed feature across parallel `/implement` agents, one per sub-issue on its own worktree; the orchestrator sequences, relays, merges and cleans up.
- **[step-by-step](./step-by-step/SKILL.md)** — Get walked through a manual procedure you haven't done before, as one numbered block with every value spelled out and every link clickable.
- **[cleanup-merged-branches](./cleanup-merged-branches/SKILL.md)** — Delete remote branches whose PR was merged — read-only dry-run, then confirm, then delete.
