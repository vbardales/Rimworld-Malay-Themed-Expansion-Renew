# Final functional validation

Status: NOT RUN for the current package. Run each scenario in English and French on
RimWorld 1.6 with Core, Harmony, Vanilla Expanded Framework, Malay Themed Expansion,
then Malay Themed Expansion Renew. Record exact versions, save, language, logs and outcome.

1. **New colony / loading.** Preconditions: fresh test colony, dependencies enabled in
   the stated order. Actions: start a new game, open build menus and inspect the log.
   Expected: both Malay stoves and both recreation buildings resolve; no patch failures,
   duplicate defs or cross-reference errors caused by this mod.
2. **Cooking.** Preconditions: fueled/powered stoves, ingredients, capable cook and work
   access. Actions: prepare each Malay meal and its bulk variant and one vanilla meal.
   Expected: bills are offered and completed, ingredients consumed and products created.
   Extra recipes inherited only through the removed extension are outside the repair scope.
3. **Dam haji.** Preconditions: accessible board, capable colonists needing recreation.
   Actions: allow recreation, with and without adjacent seating. Expected: a colonist
   uses the board, gains recreation and shows the translated job report without a raw key.
4. **Weaving.** Preconditions: accessible Weave Spot and capable colonist needing recreation.
   Actions: allow recreation and inspect the active job. Expected: the colonist uses the
   interaction cell, gains the weaving recreation kind, and TargetA resolves in the
   English/French report instead of appearing literally.
5. **Existing save.** Preconditions: backed-up save already using the upstream mod,
   without this patch. Actions: enable the patch, load, repeat cooking/recreation,
   save, quit and reload. Expected: no lost buildings, working jobs and no load errors.
6. **No configuration UI.** Preconditions: each test language. Actions: inspect mod
   options and main buttons. Expected: no empty settings page and no shortcut for this mod.
   Option values, input validation and settings persistence are not applicable.
7. **Optional Joy Rescue.** Preconditions: repeat with a recorded Joy Rescue version.
   Actions: inspect its diagnostics and both recreation activities. Expected: these
   buildings are already served, without duplicate providers. No integration is certified
   until this scenario is executed.
8. **Dependency absent (isolated diagnostic only).** Preconditions: controlled test mod
   list without Malay. Actions: inspect dependency warnings and patch loading if proceeding
   for diagnostics. Expected: Malay remains declared required; patches add no orphan defs.
   This is not a supported playable configuration.

Review the current Player.log after each run. Record unrelated errors separately, and rerun
affected scenarios after any correction. Both a new colony and an existing save are required.
