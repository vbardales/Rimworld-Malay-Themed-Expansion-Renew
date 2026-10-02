# Run history

One line per run. A line stays only while it still proves something about the current `Mod/`.
Reports live on disk under `Tests/Pickle/Evidence/` (git-ignored); see `TESTING.md`.

- 2026-08-29: in-game run by hand under the old name (`Malay Themed Expansion - Fix`, `nelim.malayfix`). History only: nothing has loaded the mod under its current identity by hand.
- 2026-09-29, `690cad2`, pass Joy Rescue: 1/1 passed, `exitReason: passed`. Only proof of scenario 7; the step assembly changed after it (`8586354`, `db588fa`), so it is to replay at the end. Kept: `Evidence/joyrescue-690cad2/`.
- 2026-09-29, `db588fa`, pass minimal English then French: 10/19 passed, 9 failed, `exitReason: failed`. The nine `02-cooking` scenarios failed, the colonists asleep. Superseded by the `94430a6` runs, deleted.
- 2026-09-30, `94430a6`, pass minimal English: 10/19 passed, 9 failed, `exitReason: failed`. `01`, `03`, `04`, `05` and the English report green. The nine `02-cooking` scenarios red: "no NSTRNasiLemak was made; the map held 0 before and 0 after", the vanilla `CookMealSimple` too, the cook standing idle outside the room. Cause not established (suite setup or mod). `@review` capture `weaving-report-english` opened: "Weaving at wooden Weave Spot (normal)." Kept: `Evidence/minimal-en-94430a6/`.
- 2026-09-30, `94430a6`, pass minimal French: 10/19 passed, 9 failed, same nine. `@review` capture `weaving-report-french` opened: "Tisse sur Weave Spot en bois (normal)." Kept: `Evidence/minimal-fr-94430a6/`.
- 2026-10-02, `d8d900f` plus the audit changes, `Tests/Run-Tests.ps1`: 37 checks passed; `Tests/Pickle/Check-Steps.ps1`: 12 patterns, 154 step lines, all resolve to one expression.
