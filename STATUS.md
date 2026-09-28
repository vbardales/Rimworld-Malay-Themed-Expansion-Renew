---
localization: complete
translation_en: complete
translation_fr: complete
mod:          Malay Themed Expansion Renew
packageId:    nelim.malaythemedexpansion
repo:         Rimworld-Malay-Themed-Expansion-Renew
visibility:   public
detached:     yes
stage:        done
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
audit_revision: 5a4e6c6
remaining:
  - unverified: Current delivered identity has not been validated in game in French and English.
  - unverified: the run in game predates the rename. It was done as
    `Malay Themed Expansion - Fix` / `nelim.malayfix`, and nothing has loaded the mod under its
    new name and package id since. No def of this mod is named by another, so nothing should
    follow, but it has not been seen.
session:      local_4b16682a-f4a1-429c-a418-e5ffce21e6c8
updated:      2026-09-13, evidence-based workflow audit
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

## Workflow audit — 2026-09-13

This section supersedes the earlier conclusions without erasing their historical evidence.
Audit scope: C:/Users/nelim/Documents/rimworld/MalayFix, standalone Git root;
distributed content: Mod/. HEAD is 78f402810619d6fafd5e4709ca1d4350d8228711.
Before this audit, About.xml and README.md were staged modifications and STATUS.md had
both staged and unstaged modifications. The audit changes only the working copy of STATUS.md;
the index and other files are preserved. The delivered patches and images are unchanged
from HEAD; the name, packageId and URL in About.xml are local staged changes.

### Stage interpretation and ordered gates

Previous stage: tested. Retained stage: dansMonoRepo, the initial workflow floor because
the first transition is incomplete. This is a cumulative readiness label, NOT a claim that
the repository is still physically in the monorepo. detached: yes remains correct.
The literal stage vocabulary is now:
dansMonoRepo -> horsMonoRepo -> ModIcon générée -> Preview générée -> preOptions ->
options -> l10n -> preTest -> done -> tested. Independent later checks are retained below.

| Transition | Result | Evidence / outstanding requirement |
| --- | --- | --- |
| dansMonoRepo -> horsMonoRepo | Defect found | Standalone root and GitHub origin verified. Read-only git ls-remote returned HEAD 78f4028; gh repo view returned PUBLIC and the exact configured repository URL. STATUS and English README exist, and both MIT LICENSE copies are identical. ATTRIBUTION.md and CHANGELOG.md are absent. The historical alive/public exception conflicts with PUBLISHING.md and does not establish the requested licence classification. |
| horsMonoRepo -> ModIcon générée | Partially validated independently | XML-only distribution: no C# project or DLL to build. PNG is 128 x 128, 18,603 bytes, directly inspected; the mascot is recognizable. No build is applicable. Implementation readiness is not fully certified by the limited patch checks below. |
| ModIcon générée -> Preview générée | Artifact validated independently | PNG is 896 x 504, 633,823 bytes, below 1 MB. Direct inspection found a high oblique view, tiled floor, warm subject lighting and no detailed faces; no concrete camera defect. No historical generation report is required. |
| Preview générée -> preOptions | Defect found | Preview still says “Malay Themed Expansion - Fix”, whereas About.xml says Renew. No reduced secondary-colour Renew suffix or version badge is present. The amber rule is visible, but the required accent/secondary hierarchy is absent. English description exists but does not end with the required Steam-formatted Source code on GitHub link. |
| preOptions -> options | Not applicable justified | See settings inventory below; this independent gate passes. |
| options -> l10n | Defect found | Native English report strings are present and translatable; both French translations are missing. |
| l10n -> preTest | Dependency declarations validated independently | Installed upstream About.xml confirms NSTR.Malay.Themed.Expansion, with support for 1.6 and its own required VEF/Harmony dependencies. This patch correctly requires Malay and loads after it. No direct VEF/Harmony class is added by this mod. VEF loadAfter is ordering, not a new direct dependency. No local LoadFolders or version/optional patch folders exist. |
| preTest -> done | Incomplete | No maintained test suite, test results or full functional scenario document in this repository. Audit XML parsing and the bounded DOM exercise below passed their stated checks, but do not establish a complete automated regression suite or game-engine patch execution. |
| done -> tested | Non verified | Historical 2026-08-29 run retained as history only. No current in-game run, logs review, FR/EN display check, new-game or existing-save execution was performed in this audit. |

### Rights and identity

The root and distributed MIT notices cover the author's own work; they do not license Malay.
The existing alive claim and its public exception are retained above as historical statements,
not approved by this audit. The installed upstream metadata explicitly includes 1.6, so absence
of 1.6 support cannot justify a silent classification from this local copy. Remote upstream
permission statements and the exact provenance boundary have not been verified here.
Before passing horsMonoRepo, document a justified classification for the actual distributed
work, distinguish upstream rights, and reconcile visibility/mentions with that decision.
Do not assume either upstream permission or an explicit prohibition from missing evidence.
ATTRIBUTION is required also for studied third-party work, as the README explicitly describes.

About name, packageId and GitHub repository describe the same mod. The actual folder remains
MalayFix; the historical claim that all four identifiers were renamed is inaccurate.
A descriptive legacy folder alias is not, by itself, a naming defect or a reason to rename it.

### Settings audit

Inventory of the entire distributed tree: two unconditional repair policies guarded by target
existence, no configurable state, serialization, source assembly, ModSettings implementation,
settings page, MainButtonDef or configuration shortcut. Stove repair and missing recreation
providers implement the advertised fixed repairs; no useful player setting was identified.
The joy constants are implementation data, not a documented manual configuration interface.
No empty page or shortcut can be registered by the delivered files.
settings_audit: not_applicable is justified by this behavior inventory and source inspection.
UI defaults, entry limits, settings persistence and RIMMSQOL integration tests are not applicable;
no integration is claimed tested. As specified by the audit prompt, no in-game settings
verification is required to pass this no-settings gate.

### Translation audit

The two added JobDefs own the only new player-facing strings:
- JobDef / MalayFix_Play_DamHaji.reportString: “playing dam haji.”
- JobDef / MalayFix_Weave.reportString: “weaving at TargetA.”

Both are native translatable reportString fields, with nonempty English source values.
English DefInjected duplication is unnecessary. TargetA is a job-report substitution token;
a French translation must preserve it. No Languages folder or French entries exist.
Expected coverage is Languages/French/DefInjected/JobDef/*.xml with these two paths.
No injection file currently exists to validate with Check-DefInjected.ps1; path execution in
the engine remains unverified. No owned Keyed strings, interpolation, settings text or
MainButtons text were found. About metadata and technical comments are outside this gate.
localization and translation_en are complete for the static inventory; translation_fr is
partial for the two missing entries. This does not certify runtime display in either language.

### Controls executed and limits

Read AGENTS.md, PUBLISHING.md, STYLE_RIMWORLD.md, MOD_SETTINGS.md and TRANSLATIONS.md
from the parent workflow directory; the supplied prompt takes precedence on options testing.
Inventoried all repository/distributed files, read both patches and metadata, reviewed
git status, git diff HEAD and git diff --check (no whitespace errors).
PowerShell System.Xml parsed all three distributed XML files successfully.
System.Drawing decoded both PNGs and measured their dimensions; both images were viewed.
The icon's 18.6 KB size below the indicative 20–30 KB range is not a defect.
No 268-pixel/32-pixel visual inspection or numeric contrast measurement was performed.
Art/Preview-source.png exists; composition HTML and palette JSON are absent. Preserve the
source when recomposing; lack of a generation history is not a separate artifact blocker.

A read-only PowerShell DOM exercise merged the installed upstream 1.6/Defs XML from
C:/Program Files (x86)/Steam/steamapps/workshop/content/294100/2884249920.
Each of NSTRDapur, NSTRElectricDapur, NSTRDamHaji, NSTRWeaveSpot and NSTRMade_Weave
resolved to exactly one target. Applying the delivered conditional/add/remove operations
in memory removed both stove modExtensions nodes and added exactly two JobDefs and two
JoyGiverDefs. Applying them to an empty Defs document added nothing. These observed checks
passed; no upstream or game file was modified. This is a limited DOM simulation, not a run
through RimWorld's loader or a full cross-reference/class-resolution check.

A second in-memory application produced four owned jobs and four owned givers: the recreation
guards check only building existence, not existing providers. This contradicts the historical
blanket assertion that any future upstream repair would automatically make these patches inert.
It does not establish a current in-game duplicate: the normal loader applies patches once.
Likewise, Stoves.xml removes the whole modExtensions container, not only the named extension.
Future upstream changes therefore need targeted regression checks; no hypothetical conflict
is reported as a current runtime failure.

No persistent automated tests were added to finish development during this audit.
Required next testing work after earlier gates: maintained XML/patch regression cases with
upstream present/absent and already-corrected inputs, written in-game scenarios with
preconditions/actions/expected results for stoves, recipes and both recreation buildings,
then execution against the delivered version. Joy Rescue is an optional integration;
no current Joy Rescue or RIMMSQOL test is claimed. The game is installed, but no interactive
session was operated and no current log establishes successful execution.

### Audited artifact fingerprints (SHA-256)

- Mod/Patches/JoyGivers.xml: 8B48AB635AC3E30587F46A2D7BAE1B550CD3110E5FB27B8C92D374AB57A3BB55
- Mod/Patches/Stoves.xml: 060BCBF7A3A0CC23C5372248AC09792676E481A32574D133A4BB1B9FEA28ECE2
- Mod/About/About.xml: 3906E25CA68C18A469689C2A4308E0A9DD09222B7F59E7481FF52315903ADF69
- Mod/About/ModIcon.png: 76DEA31A7B02B9B24BDFA5CF4DDAAC71B45228150494978DACC42581D4E36695
- Mod/About/Preview.png: BA9098A9FBF197E620C4AD5ADFC67AFE5EAF2F479F34D07AE7790EDB7967D83A
- Both LICENSE copies: 1A24DB0B016BF77E6D15FDA1BF27B20C76F9B14F1A21458BA36F2BB3A7D2C908
## First-gate remediation — 2026-09-13

This follow-up supersedes the first-gate outcome of the audit above. The historical
audit remains intact. Added English ATTRIBUTION.md and CHANGELOG.md; attribution
is also copied into Mod/ and the two MIT notices remain identical.
The current licence classification is open for the separate MIT repair implementation.
The required upstream mod's rights are explicitly excluded and no upstream redistribution
permission is asserted. Public visibility is consistent with this separate patch scope;
the old alive/public exception is no longer the classification of this repository.

The requested project folder is MalayThemedExpansionRenew (the neighboring projects
use concatenated title words). The displayed title remains Malay Themed Expansion Renew,
the package ID remains nelim.malaythemedexpansionrenew, and the GitHub repository remains
Rimworld-Malay-Themed-Expansion-Renew. No literal identity across these formats is required.
The game installation junction must point at the renamed project's Mod/ directory.

Stage: horsMonoRepo. All first-gate requirements are now documented and the earlier
remote/commit verification remains applicable. The icon artifact remains independently
validated. Full implementation readiness for the next transition is still not certified;
the audit's patch behavior limitations and outstanding localization/tests remain recorded.
No new image, gameplay feature, commit or publication is part of this remediation.
Folder rename result: attempted on 2026-09-13, NOT completed. Windows refused Move-Item
because another process is using the directory. Verified afterward: MalayFix still exists,
MalayThemedExpansionRenew does not exist, and the original RimWorld Mods/MalayFix junction
still points to MalayFix/Mod. Retry the rename and junction update after the directory handle
has been released. No game files were removed. This requested naming cleanup does not
invalidate the documented first-gate classification.
## Folder migration completed — 2026-09-13

Following the user's instruction, all contents of MalayFix, including hidden .git,
Art/, Mod/ and all staged/unstaged changes, were moved to:
C:/Users/nelim/Documents/rimworld/MalayThemedExpansionRenew

The old MalayFix directory is retained empty. This supersedes the earlier blocked
rename result. The game junction at RimWorld/Mods/MalayFix now targets the new
MalayThemedExpansionRenew/Mod directory. Its legacy junction name is retained;
the displayed mod title and package ID are unchanged.
The Git index SHA-256 was identical before and after moving. No commit or push was made.
## Readiness completion — 2026-09-13

This section supersedes earlier outstanding implementation, artwork, translation and testing
items. The earlier audit and remediation history are preserved above.

Current stage: done (ready for final functional validation in game, not tested).
Current path: C:/Users/nelim/Documents/rimworld/MalayThemedExpansionRenew.
HEAD remains 78f402810619d6fafd5e4709ca1d4350d8228711; the delivered changes are local.
Tests/RESULTS.md records SHA-256 hashes for the exact final distributed files and upstream
fixtures. Existing staged changes were preserved; no commit or push was made.

### Cumulative gates

- horsMonoRepo: previously verified standalone/public GitHub repository and pushed initial
  commit; English README, ATTRIBUTION, CHANGELOG and both applicable MIT notices exist.
  open covers this separate repair only, as documented in ATTRIBUTION.md.
- ModIcon générée: implementation changes complete; XML-only, compilation not applicable.
  Existing PNG decoded and inspected at 128 and 32 pixels. No icon regeneration needed.
- Preview générée / preOptions: final PNG at 896 x 504 below 1 MB, directly inspected;
  title now matches About.xml, Renew is secondary ink at 65%, version badge reads 1.6.
  The English description ends with the exact Steam-formatted GitHub source link.
  No linking words in this title need reduction. No unofficial/prohibited tag is required
  by the separate open patch classification.
- options: still not_applicable, justified by the earlier behavior inventory; this change
  adds no configurable state, page, shortcut or integration dependency.
- l10n: both JobDef.reportString French entries added, English native source preserved.
  TargetA retained. Shared Check-DefInjected.ps1 run with this mod and installed upstream 1.6:
  32 patch operations applied, 11,712 defs indexed, 2 keys checked, 0 errors.
  See Tests/translation-check.txt. Static EN/FR coverage complete; runtime display pending.
- preTest: required Malay dependency and load ordering remain unchanged and verified.
  Existing game-provided classes and upstream identifiers are retained.
- done: TEST_SCENARIOS.md now contains eight scenarios with prerequisites, actions and
  expected outcomes. Tests/Run-Tests.ps1 executed successfully: 37 checks, including XML
  parsing, targeted removals, unrelated-extension/recipe preservation, absent dependency,
  already-served buildings, existing jobs, idempotence, real installed upstream targets,
  translation tokens and packaged artifacts. Tests/RESULTS.md contains the final results.
  These are automated DOM/XML tests, not gameplay tests or full engine integration.

### Preview evidence

The source illustration is unchanged. HTML/CSS composition follows STYLE_RIMWORLD.md;
Art/preview-palette.json is the single palette source and Art/render-preview.cjs reproduces it.
The cool stone floor motivates the slate veil and cyan accent; warm earth/fire motivates
the amber secondary ink. The cyan accent remains distinct from the amber Renew suffix.
Segoe UI availability was checked and document.fonts.ready awaited before capture.
Direct visual inspection performed at 896 x 504 and 268 pixels wide; icon at 32 pixels.
Title, suffix and version remain identifiable, with no cropping or overlaps; no concrete
camera defect was found. Summary is intended for the full-size preview.

Tests/Check-Preview.py sampled every background pixel in each text bounding box, plus
the opaque badge contrast. Minimum ratios: title 11.54, Renew 8.10, summary 6.24,
badge 9.50; all exceed 4.5. Art/preview-contrast-qa.json and preview-layout-qa.json
record results. Art/Preview-before-renew.png preserves the previous final banner.
The initial contrast check included unused title-box space and reported 4.11; the box
was fitted to the title, the image rerendered and final checks passed as recorded above.

### Functional changes and remaining validation

Stoves now lose only the exact problematic extension instead of their whole container.
Recreation guards now detect existing providers, and preserve existing owned JobDefs;
automated cases cover these corrections. Their affected in-game regressions remain pending.

Next transition: done -> tested. Execute TEST_SCENARIOS.md on the delivered version in
English and French, inspect logs, cover a new colony and existing save, and record results.
No current game session was operated, no current gameplay success is claimed, and no optional
Joy Rescue/RIMMSQOL integration has been tested here. Settings persistence/input/shortcut
tests are not applicable because no settings exist. The historical tested_on date remains
history only. Native game UI control is not available through this session's enabled
computer-use surface, which supports browsers; in-game verification requires an interactive
RimWorld session and must not be replaced with these static results.

## Audit — 2026-09-27, applying AUDIT.md

Revision at the start of this pass: `f36a205`. Working tree carried one untracked file,
`Mod/About/PublishedFileId.txt` (`3806768309`), the trace of a Workshop item created outside
this session. No second RimWorld instance was launched, and none was needed: everything below
is off-game.

**0.1.0 recorded.** Per AUDIT.md's `prepublished → published` section, a prepublication can
happen at any point in the chain and proves nothing beyond "the item exists". Committed
`Mod/About/PublishedFileId.txt` on its own (`5a4e6c6`, "Add published Workshop file ID for
0.1.0") and opened `CHANGELOG.md` with `## [0.1.0] - 2026-09-27`. The item is private, as every
new Steam item is, and untested; this does not move `stage`.

**`done → tested` re-checked against the three new criteria.** No `@wip` scenario exists —
there is no Gherkin suite at all, `TEST_SCENARIOS.md` is plain-English. No `@requires:` scenario
exists either, so there is none left un-run. And every manual check that remains
(`TEST_SCENARIOS.md`, status "NOT RUN") is still exactly that: a manual check, not automated,
not yet performed. None of the three surfaced a defect; they confirm the gate was already
correctly held at `done`, not past it. `stage` stays `done`.

**Evidence.** No `Tests/Pickle/Evidence/` or `evidence/` folder exists — no Pickle pass has
ever been requested for this mod — so there was nothing to trim on disk or remove from git.
Added both patterns to `.gitignore` pre-emptively, and a short "Evidence retention" note to
the new `TESTING.md`, so a future pass has somewhere to read the rule before it produces its
first report.

**`.dds`.** None tracked, none on disk (`git ls-files`, `find`, both empty). Added `*.dds` to
`.gitignore` anyway, since this mod's textures are PNG and a `.dds` appearing later would mean
an unconverted import, not something to ship.

**Origin repository.** Checked whether Malay Themed Expansion has a public source repository
to build this patch from or send a pull request to, per PUBLISHING.md's "Départ depuis le
projet d'origine". A web search turned up only the Steam Workshop page; no GitHub or other code
host was found for Shanaki97's mod. Recorded in `ATTRIBUTION.md`. The patch-mod approach this
repository already took is the one PUBLISHING.md prescribes for this case.

**Duplicated `ATTRIBUTION.md`.** `Mod/ATTRIBUTION.md` had drifted from the root copy (missing
the provenance-check paragraph added this session); recopied.

**Documents read.** Logged file-by-file in `docs/PROTOCOLS-READ.md`, revision and usefulness
per document, per `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` point 5. One found modified but
uncommitted upstream, `WORKSHOP_COMMENTS.md` — another session's in-progress edit, unrelated to
this mod, left untouched.

No defect found in any of the above. Nothing here changes `stage`, `settings_audit`,
`licence_audit`, `automated_tests` or `xml_tests`: their evidence stands as recorded above.