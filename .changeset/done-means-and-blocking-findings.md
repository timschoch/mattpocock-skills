---
"mattpocock-skills": minor
---

Give an agent running alone a finish line, and a review a way to rank its findings.

- `to-tickets`: every ticket carries **Done means** (the acceptance criteria, each false at the starting commit) and **Stop and ask only if** (the one situation the implementer cannot decide alone, or "None"). The issue template's `## Acceptance criteria` heading becomes `## Done means`.
- `code-review`: each finding gives its file and line and is marked **blocking** only if it would block the merge, with how to show it fails. Before reporting, the skill opens the cited line of every blocking finding and marks the ones it cannot confirm. Blocking findings come first within each axis; the two axes still stay separate.
