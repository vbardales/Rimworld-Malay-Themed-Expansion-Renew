# Malay Themed Expansion — Fix

Répare **Malay Themed Expansion** de Shanaki97 (Steam 2884249920) pour RimWorld 1.6.

C'est un **mod de correctifs**, pas une copie : il ne contient aucun fichier du mod d'origine,
ni texture, ni def reprise. Il se charge après lui et corrige par patch XML.

## Ce qui était cassé

### 1. Les deux cuisinières ne se chargeaient pas du tout

`NSTRDapur` et `NSTRElectricDapur` portent :

```xml
<modExtensions>
  <li Class="VEF.Buildings.RecipeInheritanceExtension">
```

Ce type n'est pas résolu au chargement, et **une extension non résolue fait échouer la def
entière** : les deux cuisinières n'existaient tout simplement pas en jeu.

Le dégât ne s'arrêtait pas là. Les huit recettes malaises (nasi lemak, satay, lemang, ketupat,
plus leurs versions en lot) désignent ces cuisinières dans leur `<recipeUsers>` — d'où les
**18 à 20 `Could not resolve cross-reference`** du journal. Autrement dit : *toute la cuisine
malaise du mod était morte, à cause d'un seul nœud.*

Le correctif retire ce nœud. Les patchs XML s'appliquent au document unifié **avant** l'analyse
des defs (`CombineIntoUnifiedXML` → `ApplyPatches` → `ParseAndProcessXML`), ce qui permet de
réparer une def qui, sans ça, ne se chargerait jamais.

**Ce qu'on perd :** l'héritage des recettes que *d'autres* mods ajoutent à `FueledStove` /
`ElectricStove` (Vanilla Cooking Expanded et consorts). Les **18 recettes de cuisine vanilla**,
elles, sont déjà listées explicitement dans le `<recipes>` du mod d'origine : elles ne
dépendaient pas de l'extension et ne bougent pas.

### 2. Les deux bâtiments de loisir étaient inertes

`<building><joyKind>` n'est **qu'une étiquette d'affichage**. Sans `JoyGiverDef` qui liste le
bâtiment dans `<thingDefs>`, aucun colon ne s'en approche. Le mod n'a ni `JoyGiverDef`, ni
`JobDef`, ni assembly : le dam haji et le Weave Spot se construisaient et ne servaient à rien.

Le Weave Spot est le plus dommage : le mod lui a créé un **type de loisir inédit**
(`NSTRMade_Weave`), c'est-à-dire un neuvième type là où le jeu de base n'en a que huit — et les
attentes en réclament jusqu'à six différents (`ExpectationDef.joyKindsNeeded`). Un type que
personne ne produit ne compte pour rien.

Les couples fournisseur + pilote ajoutés sont ceux du jeu de base, repris tels quels :

| Bâtiment | Giver | Driver | Modèle vanilla |
|---|---|---|---|
| `NSTRDamHaji` | `JoyGiver_InteractBuildingSitAdjacent` | `JobDriver_SitFacingBuilding` | échecs |
| `NSTRWeaveSpot` | `JoyGiver_InteractBuildingInteractionCell` | `JobDriver_WatchBuilding` | télescope |

## Laissé de côté volontairement

Un `PawnKindDefExtension` est conditionné à `MayRequire="OskarPotocki.VFE.Core"`, alors que le
packageId réel de Vanilla Expanded Framework est `OskarPotocki.VanillaFactionsExpanded.Core`.
La condition n'étant jamais vraie, l'extension est **silencieusement ignorée** depuis toujours.
Son effet est purement cosmétique (teinte du torse aux couleurs de la faction), la classe a en
plus changé de namespace (`VFECore.` → `VEF.Pawns.`), et l'activer reviendrait à réveiller une
autre extension VEF alors même qu'on répare l'échec d'une première. Rapport bénéfice/risque
défavorable : on la laisse dormir.

## Les gardes

Les deux volets du correctif sont protégés, chacun par le mécanisme adapté à sa nature :

- **Les patchs** sont enveloppés dans un `PatchOperationConditional` testé sur le nœud
  lui-même. On garde donc sur ce qu'on s'apprête réellement à modifier. C'est plus robuste que
  `PatchOperationFindMod`, qui compare le *nom affiché* du mod
  (`ModLister.HasActiveModWithName`) et casse au moindre renommage. Effet voulu : si Malay est
  absent — ou si son auteur corrige lui-même le défaut un jour — ce fichier ne fait rien et ne
  dit rien.
- **Les defs de loisir** sont elles aussi injectées par patch, gardées de la même façon sur
  l'existence du bâtiment. Sans garde, leurs `<li>NSTRDamHaji</li>` produiraient des
  références croisées non résolues dès que Malay n'est pas là.

### Pourquoi pas `MayRequire` sur les defs

C'était la garde évidente, et **elle ne marche pas ici**. Essayée, mesurée en jeu : avec
`MayRequire="NSTR.Malay.Themed.Expansion"` sur les racines de def, les quatre defs
disparaissaient *alors même que Malay était actif* — Joy Rescue est passé de « tous desservis »
à « 2 orphelins », ce qui a servi de détecteur.

Le filtre vit dans `LoadedModManager.ParseAndProcessXML` et passe par
`ModLister.AllModsActiveNoSuffix`. Ça convient pour un DLC (`Ludeon.RimWorld.Biotech`), mais pas
pour un mod d'atelier, dont le packageId porte un suffixe `_steam`.

Garder sur l'existence du bâtiment est de toute façon meilleur : c'est insensible au suffixe
`_steam`, au renommage du mod, et à une copie locale plutôt qu'abonnée. On teste ce qu'on veut
vraiment savoir — « ce bâtiment est-il là ? » — plutôt qu'un identifiant qui en est le proxy.

Note au passage : l'auteur de Malay est tombé dans une variante du même piège avec son
`MayRequire="OskarPotocki.VFE.Core"`, packageId qui n'a jamais correspondu à rien.

## Rapport avec Joy Rescue

Les deux sont indépendants et se complètent sans se marcher dessus. Joy Rescue détecte les
bâtiments de loisir orphelins **de toute la liste de mods** et fabrique leurs fournisseurs à la
volée ; comme ce correctif-ci fournit les siens en dur, Joy Rescue les voit desservis et n'y
touche pas. C'est d'ailleurs un bon test croisé : avec les deux actifs, Joy Rescue doit
annoncer « nothing to rescue ».

## Licence

Le correctif est sous MIT. Il ne redistribue rien du mod d'origine, dont les droits restent à
son auteur.
