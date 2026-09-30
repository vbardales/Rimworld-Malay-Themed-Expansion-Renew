# French review

For Virginie's reading only, per TRANSLATIONS.md section 3. English revision `520f190`, French revision `520f190`.

The mod adds no Keyed strings, no grammar resources, and no Def label/description text
(it only removes modExtensions and adds JoyGiverDef/JobDef entries). The only player-facing
text is two job reportStrings, patched in via `Mod/Patches/JoyGivers.xml` and translated in
`Mod/Languages/French/DefInjected/JobDef/MalayFix.xml`. The mod has no non-English source:
English is the original.

## DefInjected/JobDef/MalayFix.xml

| Key or path | Original | English | French |
|---|---|---|---|
| MalayFix_Play_DamHaji.reportString | playing dam haji. | playing dam haji. | joue au dam haji. |
| MalayFix_Weave.reportString | weaving at TargetA. | weaving at TargetA. | tisse sur TargetA. |

Neither text carries an adjective, past participle or noun that agrees with the pawn (both
are a bare present-tense verb plus complement), so the three-segment gender switch from
TRANSLATIONS.md section 3 does not apply here. No row is flagged with `?`.
