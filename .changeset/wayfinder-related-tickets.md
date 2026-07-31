---
"mattpocock-skills": patch
---

Give `/wayfinder` a way to record **intentional relatedness** between maps and tickets.

Trackers offer parent/child and blocked-by, so the softer edge — where a map or ticket deliberately hangs on another's outcome without being blocked by it — had nowhere to live and was lost. Wayfinder now declares it in the body as a `Related:` line naming the other issue and *why*, written once by the session that has the context rather than inferred later by whoever finds the two side by side. It never gates the frontier.

The three issue-tracker templates say how each expresses it — GitHub has no native relationship, GitLab's `/relate` may mirror it in the UI but the body line stays the record, local-markdown puts it beside `Blocked by` — and the docs page is re-synced.
