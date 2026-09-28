# Pickle suite: Malay Themed Expansion Renew

Companion test mod `nelim.malaythemedexpansion.pickletests`. Development only, never published, never in `Mod/`.
Scenarios are the ones of `TEST_SCENARIOS.md`; this file says which run in the game and which do not.

## Scope: what needs a running game

| TEST_SCENARIOS.md | Where it runs | Why |
|---|---|---|
| 1 New colony / loading | `01-loading` | The defs as the game's own loader built them, and the errors only it can raise. |
| 2 Cooking | `02-cooking` | Bills offered, taken up, products made. Wood stove only, see below. |
| 3 Dam haji | `03-dam-haji`, `07`/`08` | The giver, the job, joy gained, the report in the pass language. |
| 4 Weaving | `04-weaving`, `07`/`08` | Same, plus the ninth joy kind `NSTRMade_Weave` being credited. |
| 5 Existing save | `05-existing-save`, partly | Save and reload with the patch active. A save written *before* the patch is not made here. |
| 6 No configuration UI | offline, `Tests/Run-Tests.ps1` | The mod has no assembly, no `MainButtonDef` and no settings class: readable in the sources. |
| 7 Joy Rescue | `06-joy-rescue`, `@requires:nelim.joyrescue` | One provider per building with Joy Rescue loaded. |
| 8 Dependency absent | offline | The dependency declaration is checked in the sources, and the empty-upstream case by `Run-Tests.ps1`. The game's reaction to a missing dependency is the game's, not the mod's (AUDIT.md, "On ne teste pas le jeu"). |

Not covered by any scenario, and left to a person: the **electric** stove cooking (needs a power net), and loading a
save written before the patch existed.

## Passes

| Pass | Map | Language | Filter | Establishes |
|---|---|---|---|---|
| minimal, English | `wsl-deps.sans-facultatifs.map` | English | `Malay Themed Expansion Renew - Pickle tests,!08-reports-french,!06-joy-rescue` | The patch works with the upstream mod and its framework, nothing else. |
| minimal, French | `wsl-deps.sans-facultatifs.map` | French | `Malay Themed Expansion Renew - Pickle tests,!07-reports-english,!06-joy-rescue` | The French reports. |
| Joy Rescue | `wsl-deps.avec-joyrescue.map` | English | `06-joy-rescue` | No duplicated provider. |

The minimal map names Vanilla Expanded Framework because the *upstream* mod requires it and the staging copies direct
dependencies only. There is no other optional mod, no declared incompatibility, no DLC guard and no restart sequence,
so no further pass applies.

## Evidence to keep

Per pass, in `Tests/Pickle/Evidence/<pass>/` (ignored by git): `summary.json` and `junit.xml`, `Player.log`, and the
`@review` captures that were opened (`weaving-report-english`, `weaving-report-french`). Nothing else: no
`report.html`, no `messages.ndjson`, no failure captures once the scenario is fixed. One line per run goes in
`docs/runs/`. See `TESTING.md`.

## Commands

Never launch the game directly. File a request from the collection root:

```powershell
powershell.exe -ExecutionPolicy Bypass -File Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1 `
  -Mod MalayThemedExpansionRenew -Owner local_c939f851-05dd-4e9d-a204-7d9fd68965fe -Label "<sha> <what>" `
  -DepMap wsl-deps.sans-facultatifs.map -Language English `
  -Filter 'Malay Themed Expansion Renew - Pickle tests,!08-reports-french,!06-joy-rescue' `
  -EvidenceDir MalayThemedExpansionRenew/Tests/Pickle/Evidence/minimal-en
```

Offline check of the step expressions, before any request: `Tests/Pickle/Check-Steps.ps1`. Rebuild the step assembly with
`dotnet build Tests/Pickle/Source/MalayThemedExpansion.PickleSteps.csproj -c Release` after any change to `Source/`.
