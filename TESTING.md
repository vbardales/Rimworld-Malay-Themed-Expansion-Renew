# Testing

## What exists today

- `Tests/Run-Tests.ps1` — automated XML/DOM checks, off-game. `Tests/RESULTS.md` records the
  last run. This is the report to keep versioned; it is the short summary AGENTS.md asks for.
- `TEST_SCENARIOS.md` — eight plain-English functional scenarios for a person to run in game
  (new colony and existing save, English and French). Status: not run since the rename.
- No Pickle (Gherkin) suite yet. Nothing in this mod needs a running game to observe beyond
  what `TEST_SCENARIOS.md` already asks for by hand: two stoves and two recreation buildings,
  their recipes and jobs, and the translated job reports. If a suite is written later, it
  belongs in `Tests/Pickle/`, follows `PickleTools/Authoring/README.md`, and runs through
  `Rimworld-Ticket-Dispatcher/scripts/Submit-PickleRun.ps1`, never launched directly.

## Evidence retention

Only two things about a test run are worth keeping on disk, and only one of those in git:

- `Tests/RESULTS.md` (or, for a future Pickle pass, a short entry in `docs/runs/`) — versioned.
  It is the proof that survives.
- Screenshots, `Player.log` copies, and any future Pickle report — kept on disk under
  `Tests/Pickle/Evidence/` or `evidence/`, both `.gitignore`d. Delete what a newer run
  supersedes; never let old evidence accumulate once its `STATUS.md` reference is gone.

Nothing today falls in the "kept on disk, not in git" category: this mod has never run a
Pickle pass, so there is no `Tests/Pickle/Evidence/` folder yet.
