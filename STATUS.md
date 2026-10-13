---
localization: complete
translation_en: complete
translation_fr: complete
mod:          Malay Themed Expansion Renew
packageId:    nelim.malaythemedexpansion
repo:         Rimworld-Malay-Themed-Expansion-Renew
visibility:   public
detached:     yes
workflow_stage: playTests[0.1.0]
licence:      open
licence_at:   LICENSE and ATTRIBUTION.md; MIT applies only to this patch
upstream_mod_remotes: N/A
dependencies: declared
showcase:     complete
tested_on:    2026-08-29
workshop:     3806768309 (0.1.0 only: item created private, not tested, not public)
settings_audit: not_applicable
licence_audit: complete
automated_tests: complete
xml_tests: complete
runtime_validation: unverified
audit_revision: 340e28e
remaining:
  - unverified: Pickle `02-cooking` red, 9 of 9 scenarios, on `db588fa` and again on `94430a6`
    (English and French): "no NSTRNasiLemak was made; the map held 0 before and 0 after", the vanilla
    `CookMealSimple` too, the cook idle outside the room in the capture. Cause not established (suite
    setup or mod). Replayed alone on `88947ba` and `0191a19` (stove given to the colony, the save's own
    colonist Jet): still red, same message. Ticket `20261013-173133-016-0118` replays it on `43631d2`.
    The `playTests` gate stays closed until each is replayed green.
  - unverified: Joy Rescue scenario (`06`) green only on `690cad2`; the step assembly changed after
    it, so it replays in the final non-regression pass.
  - unverified: electric stove cooking and a save from before the patch are not played; listed not
    applicable in `TESTING.md`, a justification proposed by the session for Virginie to confirm.
session:      local_bd2333eb-933a-48f0-afa2-98d553a01809
updated:      2026-10-12, French review validated by Virginie, writeTests -> playTests
protocols_read_sha: b483dd6813cb9e000e9a71d4a0d631de555c7aac
social_preview_sha256: 9a1840c838d1c47112d76fc5ff2e7e5209488406b193d1160ab0cf2abd7f328f
---

# Malay Themed Expansion Renew — status

Kept at the root, never inside `Mod/`, so Steam never receives it. Maintained by the session
that holds this mod, not by the sweep that first wrote it.

## Where it stands

Detached from the monorepo on 2026-09-12 into its own repository at
`https://github.com/vbardales/Rimworld-Malay-Themed-Expansion-Renew`, public. The repository was
created empty, so its history starts at a single import commit: the seven monorepo commits that
touched this folder all speak of other mods and were not replayed.

Renamed the same day, all four identifiers at once: `<name>`, package id, folder and repository.
It was `Malay Themed Expansion - Fix` in a folder called `MalayFix`. The four locks on a package
id change were all empty, checked one by one — no `PublishedFileId.txt`, no line in
`ModsConfig.xml`, none of the 25 saves naming it, and no `incompatibleWith` in the monorepo or in
any detached repository.

## Why `alive`, and public anyway

Malay Themed Expansion is still on the Workshop and still belongs to Shanaki97. There is no
licence to read. That normally means private: republishing what someone still sells competes
with them.

It does not apply here, because there is nothing to republish. This mod is 153 lines of XML
patch and two images of its own. It carries no texture, no def and no string from the original,
and it is useless without it — Steam has to hold both. Publishing it takes nothing from its
author and repairs his mod for everyone still subscribed.

## What it is made of

Two patch files. One removes a `<modExtensions>` node whose class does not resolve, which was
failing both stoves outright and, through them, the eight Malay recipes that name them. The
other supplies the two `JoyGiverDef` the mod never had, so that its dam haji board and its Weave
Spot can finally be used. Both are wrapped in a `PatchOperationConditional` tested on the target
node itself, so the mod is silent when Malay is absent, and silent again if its author ever
fixes the fault himself.

## Field vocabulary

`stage`: `port`, `showcase`, `preTest`, `done`, `tested`, `published`. `tested` means seen
running, not published.

`licence`: `open` an explicit licence, `silent` no licence and a dead source, `alive` no licence
but a living source, `forbidden` a written refusal, `original` owing nothing to anyone.

`remaining`: `feature` for something missing from a first release, `defect` for a known fault
left unfixed, `unverified` for what could not be checked.

## Audit — 2026-10-12, applying AUDIT.md (`340e28e`)

Working tree at the start: only artwork changes (`Art/*.ico`, `Art/Gallery/0-preview.png`,
`Mod/About/Preview.png`, untracked `Art/.render/`, `Art/echo.png`, ...), left untouched. No RimWorld
launched, none needed.

**Old `done` (maps to `playTests`) -> retained `writeTests[0.1.0]`.** The first failing transition is
`writeTests -> playTests`, criterion 7.g (AUDIT.md 6.g): `translation_fr` is `partial` because Virginie has
not read `FRENCH_REVIEW.md`. A session never marks its own French as reviewed. Everything else in 7.a-7.f
holds: eight scenarios in `TEST_SCENARIOS.md`, `Tests/Run-Tests.ps1` replayed today (37 checks pass),
the Pickle suite written with its scope justified in `Tests/Pickle/README.md`, local scripts declared in
`scripts/LOCAL_SCRIPTS.md`.

**Changes.** Field `stage` removed (retired 2026-10-09). `Art/render-preview.cjs` deleted: the shared
`scripts/Render-Preview.cjs` replaces it (LOCAL_SCRIPTS.md, Audit 2026-10-11); `Art/Preview.config.json`
stays. This file cut from 30 KB to the current state, history summarised below.

**Not a downgrade cause.** Pickle `02-cooking` red (9 of 9) and the Joy Rescue replay need the game: they
belong to `playTests`, listed `unverified` in `remaining`.

**Follow-up, same day.** Virginie validated the French (`FRENCH_REVIEW.md` Review line, 2026-10-12, texts from `340e28e`, no correction). `translation_fr: complete`; 7.g met; `workflow_stage` moves to `playTests[0.1.0]`. Open: Pickle `02-cooking` red, Joy Rescue replay, both need the game.

## History, condensed

- 2026-09-12: detached into its own repository, renamed (name, package id, repository). Folder
  `MalayThemedExpansionRenew` since 2026-09-13.
- 2026-09-13: first audit and remediation; ATTRIBUTION and CHANGELOG added; licence `open` for this
  separate MIT repair only, Malay's rights excluded. Two JobDef `reportString` French entries added.
  Stoves now lose only the exact bad extension; recreation guards test existing providers.
- 2026-09-27: `Mod/About/PublishedFileId.txt` (`3806768309`) committed, CHANGELOG `[0.1.0]`. Private,
  untested item; created under the old package id.
- 2026-09-30: French gender-agreement rule replayed: both strings are bare verb plus complement, no
  agreement needed. `FRENCH_REVIEW.md` generated; `translation_fr` reset to `partial`.
- 2026-10-02: audit replay (`5a975b5`): dependencies, tests, evidence pruned (413 MB to 13 MB, keep rule in
  `TESTING.md`), gallery moved to `Art/Gallery/0-preview.png`, no origin repository for Malay (Workshop
  only). Pickle reports on `db588fa` and `94430a6`: 19 scenarios, 10 passed, 9 failed, all in
  `02-cooking`; cause not established. Reserve: `Art/Preview.ico` older than `Preview.png`.
