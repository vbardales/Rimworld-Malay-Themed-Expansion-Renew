# Testing

## What exists today

- `Tests/Run-Tests.ps1` — automated XML/DOM checks, off-game. `Tests/RESULTS.md` records the
  last run. This is the report to keep versioned; it is the short summary AGENTS.md asks for.
- `TEST_SCENARIOS.md` — eight plain-English functional scenarios for a person to run in game
  (new colony and existing save, English and French). Status: not run since the rename.
- `Tests/Pickle/` - the Pickle (Gherkin) suite, written 2026-09-28: eight features, one step assembly, three passes (minimal English, minimal French, Joy Rescue). `Tests/Pickle/README.md` says which scenario of `TEST_SCENARIOS.md` runs where and what no scenario covers (electric stove cooking, a save written before the patch). Scenarios 6 and 8 are offline by design.

## Evidence retention

Only two things about a test run are worth keeping on disk, and only one of those in git:

- `Tests/RESULTS.md` (or, for a future Pickle pass, a short entry in `docs/runs/`) — versioned.
  It is the proof that survives.
- Screenshots, `Player.log` copies, and any future Pickle report — kept on disk under
  `Tests/Pickle/Evidence/` or `evidence/`, both `.gitignore`d. Delete what a newer run
  supersedes; never let old evidence accumulate once its `STATUS.md` reference is gone.

Keep per pass: `summary.json`, `junit.xml`, `Player.log` and the `@review` captures that were opened. Delete `report.html`, `messages.ndjson` and failure captures once superseded.
