---
"mattpocock-skills": minor
---

Add a `fork/` bucket for skills written in this fork, and a new **`step-by-step`** skill in it.

- `fork/` is promoted — it ships in the plugin and carries its own `README.md` — but it sits outside upstream's index files, so an upstream merge has no fork entries interleaved in `skills/engineering/README.md` or the Engineering list in the top-level `README.md` to trample. Docs pages are optional there, since nothing in the bucket is published on aihero.dev.
- Move `orchestrate` (from `engineering/`) and `cleanup-merged-branches` (from `misc/`) into it. `cleanup-merged-branches` now ships in the plugin, which it did not while it sat in the non-promoted `misc/`.
- **`step-by-step`** walks the user through a manual procedure they have not done before — creating a PAT, pointing a domain, wiring a CI secret. It does the terminal half itself, then hands over one numbered block: literal values in every field, a full deep URL per step, the trap named in the step it bites, a test as the last step. Past ~30 steps it splits into parts, cut on checkable seams rather than on the count, one part per message. Secrets get their own step naming the exact destination, and the block says in words not to paste the value into the chat. User-invoked, because the agent cannot tell which procedures are new to the person asking.
