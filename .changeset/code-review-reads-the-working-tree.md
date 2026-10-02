---
"mattpocock-skills": patch
---

`code-review` reviews work that is not committed yet, and its reviewers stay in their lane.

- The diff command is `git diff --merge-base <fixed-point>`, so staged and unstaged changes to tracked files are in the review. Stage a new file first: git leaves an untracked file out of the diff.
- Both sub-agent briefs forbid invoking `/code-review` again or spawning more agents.
- The Standards sub-agent gets the diff and the standards and nothing else, so the agent that wrote the code cannot soften it.
