# `/implement` closes the Chrome tabs it opened

One line added to the end of `skills/engineering/implement/SKILL.md`:

> Close any Chrome tabs you opened during this session before creating the PR.

## Why

Agents in this fork drive a real Chrome through browser automation, against the user's own profile and window. That is not a disposable headless browser: the tabs an agent opens land in the window the human is using.

An `/implement` run that reads three doc pages and checks a preview deployment leaves five tabs behind. Nothing ever closes them, because the session ends and the next one starts fresh with no knowledge of what the last one opened. Run a fleet of `/implement` agents concurrently, as [0002](./0002-concurrent-implement-sessions.md) does, and the tab bar is unusable within an afternoon.

The session that opened a tab is the only actor that knows the tab is finished with. So cleanup belongs at the end of the run, not to a reaper.

## Why "before creating the PR"

The PR is the run's last act and the point of no return: after it, the agent is done and may be cleared at any moment. Anchoring cleanup to a step that always happens, rather than to "at the end", means it survives the flows that exit early.

## Files this governs

| File | Fork edit |
| --- | --- |
| `skills/engineering/implement/SKILL.md` | Final line |

Provenance: `7603ea5` (2026-07-07), wording tidied in `81e6942` (#7).

## Resolving a conflict here

Take the fork's line. It is the last line of the file and additive, so an upstream edit almost never touches it. Drop it only if this fork stops giving agents access to the user's own browser.
