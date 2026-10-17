---
"mattpocock-skills": patch
---

`code-review` reviewers stay in their lane, and `implement` commits before it reviews.

- Both sub-agent briefs forbid invoking `/code-review` again or spawning more agents.
- The Standards sub-agent gets the diff and the standards and nothing else, so the agent that wrote the code cannot soften it.
- `implement` commits first, then calls `/code-review`, so the review's `<fixed-point>...HEAD` diff holds the work.
