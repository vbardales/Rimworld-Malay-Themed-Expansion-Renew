# Protocols read by this mod's session

One line per document: the revision read, and whether it changed anything here. Re-read at
the start of a session and after a context compaction; update this file rather than trusting
memory of an older pass.

## Protocols (`vbardales/Rimworld-protocols`, read through the monorepo work tree)

| File | Revision read | Useful here? |
|---|---|---|
| `AGENTS.md` | `3a1d2cb`, 2026-09-24 | Yes — settings/translations/preTest gate order. |
| `AUDIT.md` | `c5ca0c0`, 2026-09-26 | Yes — the whole chain, applied below. |
| `PUBLISHING.md` | `0747b40`, 2026-09-26 | Yes — description link, licence suffixes, `.gitignore`/`.gitattributes` model, "start from the origin's repo" rule. |
| `TRANSLATIONS.md` | `f5c2d9d`, 2026-09-25 | Partially — this mod owns one DefInjected file, no settings, no code strings; the rest (plurals, custom XML fields) does not apply. |
| `STYLE_RIMWORLD.md` | `7311308`, 2026-09-25 | No new work — Preview/ModIcon were already produced under an earlier revision; nothing here changed the artwork. |
| `MOD_SETTINGS.md` | `b83933b`, 2026-09-23 | Yes, but the answer is short: no settings, already recorded as `not_applicable`. |
| `WORKSHOP_COMMENTS.md` | `785c5a5`, 2026-09-26, **plus an uncommitted edit in the working tree at read time** (another session adding rows; not this mod's business) | Not yet — no `PUBLICATION.md` exists here (that arrives at `tested → prepublished`), and the one relevant row (2884249920, Malay Themed Expansion) is already `drafted` from Joy Rescue. |
| `scripts/SEARCHING.md` | `372c447`, 2026-09-23 | No — nothing to search across the Workshop corpus for this patch. |

## Tools (`PickleTools/`, `Rimworld-Release-Admin/`)

| File | Revision read | Useful here? |
|---|---|---|
| `PickleTools/README.md` | `c771bef`, 2026-09-25 | No — this mod has no Pickle suite; its scenarios are the plain-English kind in `TEST_SCENARIOS.md`. |
| `PickleTools/Headless/README.md` | `ed4e73a`, 2026-09-26 | No — same reason; kept for when/if a Pickle suite is written. |
| `PickleTools/docs/steps.md` | `cba3ca1`, 2026-09-25 | No — no suite to write steps for. |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `3c03f51`, 2026-09-26 | Not yet — this mod has no CI workflow; relevant once it reaches `tested → prepublished`. |

## Queue (`Rimworld-Ticket-Dispatcher/`)

| File | Revision read | Useful here? |
|---|---|---|
| `docs/WELCOME.md` | `d07b2b8`, 2026-09-26 | Not yet — no Pickle run has been requested for this mod. |
| `docs/SUBMIT.md` | `d07b2b8`, 2026-09-26 | Not yet, same reason. |

## This mod's own documents

`STATUS.md`, `README.md`, `CHANGELOG.md`, `ATTRIBUTION.md`, `LICENSE`, `TEST_SCENARIOS.md` and
`Mod/About/About.xml` were all read in full during this session (2026-09-27). No `PUBLICATION.md`,
`TESTING.md` before this session, `BACKLOG.md`, `NOTES.md`, `BUGS.md` or `docs/runs/` existed yet.
`TESTING.md` was created this session; see `STATUS.md`, "Evidence retention".
