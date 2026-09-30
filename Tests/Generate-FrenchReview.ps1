<#
Regenerates FRENCH_REVIEW.md from the shipped XML, per TRANSLATIONS.md section 3: "A session
generates the file with a script that reads the shipped XML, not by hand, so the columns cannot
drift from the mod." Run after any change to Mod/Patches/JoyGivers.xml or the French DefInjected.
#>
[CmdletBinding()]
param(
    [string]$Root
)

$ErrorActionPreference = 'Stop'

if (-not $Root) {
    $Root = Split-Path -Parent $PSScriptRoot
}

function Get-Rev {
    param([string]$Path)
    $rev = & git -C $Root log -1 --format=%h -- $Path
    if (-not $rev) { throw "no git history for $Path" }
    return $rev
}

$patchPath = Join-Path $Root 'Mod\Patches\JoyGivers.xml'
$frenchPath = Join-Path $Root 'Mod\Languages\French\DefInjected\JobDef\MalayFix.xml'

[xml]$patch = Get-Content $patchPath -Raw
[xml]$french = Get-Content $frenchPath -Raw

# The two reportStrings this mod's patch adds, in the order they appear in JoyGivers.xml.
$reportNodes = $patch.SelectNodes('//reportString')
$defNames = @('MalayFix_Play_DamHaji', 'MalayFix_Weave')

$rows = @()
for ($i = 0; $i -lt $reportNodes.Count; $i++) {
    $defName = $defNames[$i]
    $english = $reportNodes[$i].InnerText
    $key = "$defName.reportString"
    $frenchNode = $french.LanguageData.SelectSingleNode($key)
    if (-not $frenchNode) { throw "no French DefInjected entry for $key" }
    $rows += [pscustomobject]@{
        Key      = $key
        Original = $english
        English  = $english
        French   = $frenchNode.InnerText
    }
}

$patchRev = Get-Rev $patchPath
$frenchRev = Get-Rev $frenchPath

$lines = @()
$lines += '# French review'
$lines += ''
$lines += "For Virginie's reading only, per TRANSLATIONS.md section 3. English revision ``$patchRev``, French revision ``$frenchRev``."
$lines += ''
$lines += 'The mod adds no Keyed strings, no grammar resources, and no Def label/description text'
$lines += '(it only removes modExtensions and adds JoyGiverDef/JobDef entries). The only player-facing'
$lines += 'text is two job reportStrings, patched in via `Mod/Patches/JoyGivers.xml` and translated in'
$lines += '`Mod/Languages/French/DefInjected/JobDef/MalayFix.xml`. The mod has no non-English source:'
$lines += 'English is the original.'
$lines += ''
$lines += '## DefInjected/JobDef/MalayFix.xml'
$lines += ''
$lines += '| Key or path | Original | English | French |'
$lines += '|---|---|---|---|'
foreach ($row in $rows) {
    $lines += "| $($row.Key) | $($row.Original) | $($row.English) | $($row.French) |"
}
$lines += ''
$lines += 'Neither text carries an adjective, past participle or noun that agrees with the pawn (both'
$lines += 'are a bare present-tense verb plus complement), so the three-segment gender switch from'
$lines += 'TRANSLATIONS.md section 3 does not apply here. No row is flagged with `?`.'

$outPath = Join-Path $Root 'FRENCH_REVIEW.md'
Set-Content -Path $outPath -Value ($lines -join "`r`n") -Encoding utf8
Write-Host "wrote $outPath"
