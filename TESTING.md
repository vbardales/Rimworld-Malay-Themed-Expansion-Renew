# Testing

## What exists today

- `Tests/Run-Tests.ps1`: automated XML/DOM checks, off-game. `Tests/RESULTS.md` records the last
  run (37 checks). It is the short summary kept in git, as AGENTS.md asks.
- `Tests/Pickle/Check-Steps.ps1`: offline check that every step line of the suite resolves to
  exactly one expression. Run it before any Pickle request.
- `TEST_SCENARIOS.md`: the eight functional scenarios, each with its precondition, action and
  expected result, and where it is proven (Pickle, offline, or not applicable).
- `Tests/Pickle/`: the Pickle (Gherkin) suite, eight features, one step assembly, three passes.
  `Tests/Pickle/README.md` maps each scenario of `TEST_SCENARIOS.md` to the feature that plays it.

## Passes

Three passes, no more: the mod has no declared incompatibility, no DLC guard and no restart sequence.

| Pass | Family | Map | Language | What it establishes |
|---|---|---|---|---|
| minimal, English | without optional mods | `wsl-deps.sans-facultatifs.map` | English | The patch holds with the upstream mod and its framework, nothing else. |
| minimal, French | without optional mods | `wsl-deps.sans-facultatifs.map` | French | The two French job reports, with `TargetA` resolved. |
| Joy Rescue | with the optional mod (the only one: Joy Rescue is the only integration claimed) | `wsl-deps.avec-joyrescue.map` | English | Exactly one provider per recreation building. Joy Rescue is the one scenario with `@requires:`. |

No pass for an incompatibility: none is declared.

## Order of the passes

New and red first, small tickets with `-Filter` on the feature or scenario. The non-regression
passes (the whole suite, both languages, the Joy Rescue pass) are all filed together at the end,
on the final revision. A scenario is non-regression once it has a green run on the current logic;
a change to the mod or to a step it uses makes it new again.

## Not applicable, with the reason

AUDIT.md, "On ne teste pas ce que le mod ne modifie pas" and "On ne teste pas le jeu".

- **Electric stove cooking** (second half of scenario 2). The repair removes the same unresolvable
  `modExtensions` node from both stoves and changes nothing else about them. Cooking at the
  electric stove is vanilla's own work giver on a def that now loads; the repair's claim, that the
  def and its recipe list resolve, is asserted in `01-loading`. The wood stove run proves the
  recipes are offered and produce. Proposed by the session; Virginie may overrule.
- **Loading a save written before the patch** (second half of scenario 5). No such save can hold
  a Malay stove: its def failed to load. The two recreation buildings did load and are in such a
  save, but what the patch adds to them (a `JoyGiverDef`, a `JobDef`) is def-level and never
  serialised. `05-existing-save` saves and reloads with the patch active. Proposed by the session;
  Virginie may overrule.
- **The game's reaction to a missing dependency** (scenario 8). The game's own work. The mod
  answers for what it declares, checked in the sources and by `Run-Tests.ps1`.
- **Settings, shortcut, persistence** (scenario 6). The mod has none; the absence of a page and a
  shortcut is read in the sources and checked by `Run-Tests.ps1`.

## Evidence retention

Two things about a test run are worth keeping, and only one of them in git.

- `Tests/RESULTS.md` and one line per run in `docs/runs/history.md`: versioned. They are the proof
  that survives.
- The report of the latest run per pass, on disk under `Tests/Pickle/Evidence/<pass>-<sha>/`,
  git-ignored. Keep only `summary.json`, `junit.xml`, `Player.log`, the `@review` captures that
  were opened (`weaving-report-english`, `weaving-report-french`) and one capture of a scenario
  that is still red. Delete `report.html`, `messages.ndjson` and every other capture. Delete an
  older report once a newer one for the same scenarios exists; keep an older one only when it is
  the sole proof of a check the newer run did not repeat (today: the Joy Rescue pass).
- Remove a long-named folder with `Remove-Item -LiteralPath '\\?\<full path>' -Recurse -Force`;
  a plain `Remove-Item` stops on the screenshot names.
