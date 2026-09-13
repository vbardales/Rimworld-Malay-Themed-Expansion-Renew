# Malay Themed Expansion Renew

Repairs **Malay Themed Expansion** by Shanaki97 (Steam 2884249920) so that it works on the
current version of RimWorld.

It is a **patch mod, not a copy**: it carries no file from the original, neither a texture nor a
def lifted from it. It loads after it and fixes it with XML patches.

## What was broken

### 1. Neither stove loaded at all

`NSTRDapur` and `NSTRElectricDapur` carry:

```xml
<modExtensions>
  <li Class="VEF.Buildings.RecipeInheritanceExtension">
```

That type does not resolve at load, and **an unresolved extension fails the whole def**: the two
stoves simply did not exist in game.

The damage did not stop there. The eight Malay recipes (nasi lemak, satay, lemang, ketupat, and
their bulk versions) name those stoves in their `<recipeUsers>`, hence the **18 to 20
`Could not resolve cross-reference`** lines in the log. In other words: *the mod's entire Malay
kitchen was dead because of a single node.*

The fix removes only that extension entry, preserving other mod extensions. XML patches apply to the unified document **before** defs are parsed
(`CombineIntoUnifiedXML` → `ApplyPatches` → `ParseAndProcessXML`), which is what makes it
possible to repair a def that would otherwise never load.

**What is lost:** inheritance of the recipes that *other* mods add to `FueledStove` /
`ElectricStove` (Vanilla Cooking Expanded and the like). The **18 vanilla cooking recipes** are
already listed explicitly in the original mod's `<recipes>`: they never depended on the
extension and do not move.

### 2. Both recreation buildings were inert

`<building><joyKind>` is **only a display label**. Without a `JoyGiverDef` that lists the
building in its `<thingDefs>`, no colonist ever goes near it. The mod has no `JoyGiverDef`, no
`JobDef` and no assembly: the dam haji board and the Weave Spot could be built and served no
purpose.

The Weave Spot is the greater loss: the mod gave it a **recreation type of its own**
(`NSTRMade_Weave`), a ninth kind where the base game has eight, and expectations ask for up to
six different ones (`ExpectationDef.joyKindsNeeded`). A kind nobody produces counts for nothing.

The giver and driver pairs added here are the base game's, taken as they are:

| Building | Giver | Driver | Vanilla model |
|---|---|---|---|
| `NSTRDamHaji` | `JoyGiver_InteractBuildingSitAdjacent` | `JobDriver_SitFacingBuilding` | chess |
| `NSTRWeaveSpot` | `JoyGiver_InteractBuildingInteractionCell` | `JobDriver_WatchBuilding` | telescope |

## Left alone on purpose

A `PawnKindDefExtension` is gated on `MayRequire="OskarPotocki.VFE.Core"`, while the real package
id of Vanilla Expanded Framework is `OskarPotocki.VanillaFactionsExpanded.Core`. The condition is
never true, so the extension has been **silently ignored** since the day it was written. Its
effect is purely cosmetic (torso tinted in the faction's colours), the class has moved namespace
on top of that (`VFECore.` → `VEF.Pawns.`), and switching it on would mean waking a second VEF
extension at the very moment we are repairing the failure of a first. The trade is not worth it:
it stays asleep.

## The guards

The stove patch checks for the exact recipe-inheritance extension before removing it;
other extensions and explicit recipes are preserved. It is inert when that entry is absent.

The recreation patches require the target building and no existing JoyGiverDef serving it.
They preserve an existing job with the same defName and add only the missing provider.
This avoids duplicates when another XML mod already supplies the recreation or when these
patches are applied twice. A provider created later by another mod still needs integration testing.
### Historical investigation of `MayRequire`

The following was recorded during the original investigation and has not been reproduced on the current package. With
`MayRequire="NSTR.Malay.Themed.Expansion"` on the def roots, all four defs vanished *while Malay
was active* — Joy Rescue went from "all served" to "2 orphans", which is what caught it.

The filter lives in `LoadedModManager.ParseAndProcessXML` and goes through
`ModLister.AllModsActiveNoSuffix`. That fits a DLC (`Ludeon.RimWorld.Biotech`), but not a
Workshop mod, whose package id carries a `_steam` suffix.

Guarding on the building's existence is better regardless: it is immune to the `_steam` suffix,
to a rename of the mod, and to a local copy rather than a subscription. It tests what we
actually want to know — "is this building here?" — rather than an identifier that stands in
for it.

Worth noting in passing: the author of Malay fell into a variant of the same trap with his
`MayRequire="OskarPotocki.VFE.Core"`, a package id that never matched anything.

## Relationship with Joy Rescue

Joy Rescue is an optional integration, pending current in-game validation. It detects
orphaned recreation buildings **across the whole mod list** and builds their givers on the fly;
since this fix supplies its own outright, Joy Rescue sees them served and leaves them alone. It
doubles as a cross-check: with both active, Joy Rescue must report "nothing to rescue".

## Licence

The fix is under MIT. It redistributes nothing from the original mod, whose rights remain with
its author.

## Validation and development

The distribution is Mod/. No C# compilation is needed. There are no useful player settings:
these are fixed repairs, so no empty mod-options page or MainButtons shortcut is provided.
English job reports are native Def values; French translations are in Languages/French.

Run the automated XML/DOM regression suite from the repository root:

    pwsh -File Tests/Run-Tests.ps1

The suite requires the installed upstream 1.6 XML; use -Upstream to override its Defs path.
Tests/RESULTS.md records the tested working-tree hashes and fixture hashes.
The suite verifies patch transformations, idempotence, absent/already-fixed targets,
translation tokens and distribution metadata; it does not run RimWorld's game loop.

Run the shared translation verifier with both this Mod/ and upstream 1.6/ as Targets.
Tests/translation-check.txt records the latest output. TEST_SCENARIOS.md describes
the pending final in-game validation in English and French, including an existing save.

Art/preview.html loads Art/preview-palette.json and the preserved Preview-source.png.
Art/render-preview.cjs requires Node.js, Playwright and Chrome; set NODE_PATH as appropriate
for the installed modules. Tests/Check-Preview.py requires Python and Pillow.
Run the renderer and contrast check after changing the composition, then Run-Tests.ps1
to refresh the final delivered-file hashes. Art/Preview-before-renew.png archives the old banner.

See ATTRIBUTION.md for studied third-party work and the licence boundary.