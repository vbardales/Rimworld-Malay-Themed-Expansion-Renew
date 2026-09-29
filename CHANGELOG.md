# Changelog

## Unreleased

- Drop the `renew` suffix from the package ID: `nelim.malaythemedexpansionrenew` becomes
  `nelim.malaythemedexpansion`. The displayed name and repository keep `Renew`.
- Add the ModIcon, cut out of its black background, to the bottom-left corner of the preview,
  tilted 15 degrees, flush against both edges. Start the Workshop gallery with
  `Art/steam/00-preview.png`, a copy of the preview.

## [0.1.0] - 2026-09-27

Creation of a Workshop file ID. The item was created private, from the `Mod/` content of
this version, and is not yet tested in game.

- Recompose the preview with the current title, distinct secondary/accent colours and 1.6 badge.
- Add French job reports and the final source-code link in the English description.
- Limit stove removal to the problematic extension and preserve unrelated extensions.
- Skip recreation buildings already served and preserve existing jobs.
- Add automated XML/DOM regression tests and final in-game scenarios.

- Rename the displayed mod to Malay Themed Expansion Renew and its package ID to
  nelim.malaythemedexpansionrenew.
- Move the complete standalone project into MalayThemedExpansionRenew, retain the old MalayFix directory empty, and update the RimWorld installation junction.
- Add English attribution and document the MIT licence boundary between this patch
  and the required Malay Themed Expansion mod.
- Add the initial changelog and distribute attribution with the mod.

## Initial standalone import — 2026-09-12

- Import the existing XML repair mod into its own repository.
- Remove the problematic modExtensions containers from the two Malay stoves.
- Provide job and recreation giver definitions for dam haji and the Weave Spot.
- Include the existing icon, preview and MIT licence.

The historical game run was recorded on 2026-08-29 under the old name and package ID.
The renamed package has not yet passed final in-game validation.
