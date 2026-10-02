# Protocols read by this mod's session

One line per document: the revision read, and whether it helped here. Re-read at the start of a
session and after a context compaction; update this file rather than trusting memory of an older
pass. Last full read: 2026-10-02, session `local_bd2333eb-933a-48f0-afa2-98d553a01809`.

Revisions of the protocol documents come from `../rimworld-protocols.git` (the monorepo's own
`git log` reports the commit that removed them, see `WELCOME.md` point 5).

## Protocols

| File | Revision read | Useful here? |
|---|---|---|
| `AGENTS.md` | `7fd7475`, 2026-09-29 | Yes: gate order, evidence keep rule, CI publishing guards. |
| `AUDIT.md` | `5a975b5`, 2026-10-02 | Yes: the whole chain, applied in `STATUS.md`. New since last read: `@wip`, `@requires:` and manual-test criteria for `tested`, "do not test what the mod does not change", pass ordering, WSL cleanup at `published`. |
| `PUBLISHING.md` | `4e44398`, 2026-10-02, **plus an uncommitted edit** | Yes: gallery folder `0-` numbering, origin-repo PR rule, packageId without `renew`, description source. |
| `TRANSLATIONS.md` | `af8427f`, 2026-10-02 | Yes: French review file format, `scripts/Make-FrenchReview.ps1`. The gender and plural rules do not apply (two bare-verb strings). |
| `MOD_SETTINGS.md` | `b83933b`, 2026-09-23 | Short answer: no settings, `not_applicable`. Unchanged. |
| `STYLE_RIMWORLD.md` | `4e44398`, 2026-10-02, **plus an uncommitted edit** | Skimmed headings only; Preview and ModIcon were produced earlier and nothing here changed them. Re-read when the Preview is regenerated. |
| `WORKSHOP_COMMENTS.md` | `4e44398`, 2026-10-02, **plus an uncommitted edit** | Not yet: comments are written at `tested -> prepublished`. |
| `scripts/SEARCHING.md` | `50de695`, 2026-09-28 | No: nothing to search across the Workshop for this patch. |

## Tools

| File | Revision read | Useful here? |
|---|---|---|
| `PickleTools/README.md` | `ff20d89`, 2026-09-29, **plus an uncommitted edit** | Table only; this suite uses no PickleTools companion. |
| `PickleTools/Headless/README.md` | `ed4e73a`, 2026-09-26 | Not re-read; unchanged since the suite was written. |
| `PickleTools/docs/steps.md` | `da7c3b0`, 2026-09-28, **plus an uncommitted edit** | Not re-read; `Check-Steps.ps1` checks the suite against the live catalogue. |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `3c03f51`, 2026-09-26 | Not yet: no CI workflow before `tested -> prepublished`. |

## Queue

| File | Revision read | Useful here? |
|---|---|---|
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | `77ca9d7`, 2026-09-27 | Yes: filter terms, pass maps, evidence deletion (`robocopy`/`\?\`), no-artefact-in-`Mod/` rule. |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | `d07b2b8`, 2026-09-26 | Yes for the next request: `-EvidenceDir` is never overwritten, the label carries the SHA. |

## This mod's own documents

Read in full on 2026-10-02: `STATUS.md`, `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`, `LICENSE`,
`TESTING.md`, `TEST_SCENARIOS.md`, `FRENCH_REVIEW.md`, `Mod/About/About.xml`, `Tests/Pickle/README.md`,
`Tests/RESULTS.md`, `docs/runs/history.md`. Absent, so nothing to read: `PUBLICATION.md` (arrives at
`tested -> prepublished`), `BACKLOG.md` (no origin repository, so no pull request to track), `NOTES.md`,
`BUGS.md`.
