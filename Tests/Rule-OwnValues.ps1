param([Parameter(Mandatory)][string]$ModRoot, [string]$SharedDir, [string]$Upstream = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\2884249920\1.6\Defs')

# Own values and facts of this repair patch: what the two patch files do to fixtures and to the installed upstream defs,
# the About identity (package id, Malay dependency, final repository link) and the two French reports against the English
# ones of JoyGivers.xml. One consumer, nothing shareable; Tests/Test-Mod.ps1 (generated) runs it after the shared checks.
# Prints findings, exit 1 on any. XML parse, image sizes, About shape, copies of LICENSE and ATTRIBUTION and the French coverage
# are the shared checks' work (Check-ModBasics, Check-Translations), not repeated here.
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $ModRoot).Path
$mod = Join-Path $root 'Mod'
$script:findings = @()

$engine = @($SharedDir, (Join-Path $root '../scripts')) | Where-Object { $_ } | ForEach-Object { Join-Path $_ 'lib/PatchEngine.ps1' } | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $engine) { Write-Warning 'lib/PatchEngine.ps1 not found (needs the protocols checkout): the patch rules are SKIPPED here, not passed (every local run has it).' } else { . $engine }

# One rule: the block returns its problems; each is printed under the rule name.
function It([string]$name, [scriptblock]$body) {
    try { $problems = @(& $body | Where-Object { $_ }) } catch { $problems = @("threw: $($_.Exception.GetBaseException().Message)") }
    foreach ($p in $problems) { $script:findings += "[$name] $p" }
}
function Load-Xml([string]$p) { $d = New-Object System.Xml.XmlDocument; $d.Load($p); return $d }
function Apply-Patches($doc) { foreach ($f in Get-ChildItem -LiteralPath (Join-Path $mod 'Patches') -Filter *.xml) { Invoke-PatchFile $f.FullName $doc } }
function Count($doc, [string]$xpath) { return @($doc.SelectNodes($xpath)).Count }
$ext = 'VEF.Buildings.RecipeInheritanceExtension'
$workGiver = '//WorkGiverDef[defName="DoBillsCook"]/fixedBillGiverDefs/li'

if ($engine) {
    It 'Stoves and recreation givers on a fixture' {
        $x = New-Object System.Xml.XmlDocument
        $x.LoadXml('<Defs><ThingDef><defName>NSTRDapur</defName><recipes><li>CookMealSimple</li></recipes><modExtensions><li Class="' + $ext + '"/><li Class="Other.Extension"/></modExtensions></ThingDef><ThingDef><defName>NSTRElectricDapur</defName><modExtensions><li Class="' + $ext + '"/></modExtensions></ThingDef><ThingDef><defName>NSTRDamHaji</defName></ThingDef><ThingDef><defName>NSTRWeaveSpot</defName></ThingDef><WorkGiverDef><defName>DoBillsCook</defName><fixedBillGiverDefs><li>ElectricStove</li><li>FueledStove</li></fixedBillGiverDefs></WorkGiverDef></Defs>')
        Apply-Patches $x
        if ((Count $x "$workGiver[.='NSTRDapur']") -ne 1 -or (Count $x "$workGiver[.='NSTRElectricDapur']") -ne 1) { 'Both Malay stoves must be listed once in DoBillsCook' }
        if ((Count $x $workGiver) -ne 4) { 'Vanilla stoves must stay in DoBillsCook' }
        if ((Count $x "//modExtensions/li[@Class='$ext']") -ne 0) { 'Both problematic stove extensions must be removed' }
        if ((Count $x "//modExtensions/li[@Class='Other.Extension']") -ne 1) { 'Unrelated extension must be preserved' }
        if ((Count $x '//recipes/li[text()="CookMealSimple"]') -ne 1) { 'Explicit cooking recipe must be preserved' }
        if ((Count $x '/Defs/JobDef') -ne 2 -or (Count $x '/Defs/JoyGiverDef') -ne 2) { 'Exactly two jobs and two providers must be supplied' }
        $first = $x.OuterXml; Apply-Patches $x
        if ($x.OuterXml -cne $first) { 'A second application must change nothing (idempotent)' }
    }
    It 'Missing upstream gives no orphan def' {
        $e = New-Object System.Xml.XmlDocument; $e.LoadXml('<Defs/>'); Apply-Patches $e
        if ((Count $e '/Defs/*') -ne 0) { 'Without Malay the patches must add nothing' }
    }
    It 'Already served buildings and existing jobs are left alone' {
        $c = New-Object System.Xml.XmlDocument
        $c.LoadXml('<Defs><ThingDef><defName>NSTRDamHaji</defName></ThingDef><ThingDef><defName>NSTRWeaveSpot</defName></ThingDef><JoyGiverDef><defName>UpstreamBoard</defName><thingDefs><li>NSTRDamHaji</li></thingDefs></JoyGiverDef><JoyGiverDef><defName>UpstreamWeave</defName><thingDefs><li>NSTRWeaveSpot</li></thingDefs></JoyGiverDef></Defs>')
        $before = $c.OuterXml; Apply-Patches $c
        if ($before -cne $c.OuterXml) { 'Buildings that already have a provider must stay unchanged' }
        $p = New-Object System.Xml.XmlDocument
        $p.LoadXml('<Defs><ThingDef><defName>NSTRDamHaji</defName></ThingDef><JobDef><defName>MalayFix_Play_DamHaji</defName><reportString>existing report</reportString></JobDef></Defs>')
        Apply-Patches $p
        if ((Count $p '/Defs/JobDef') -ne 1 -or $p.SelectSingleNode('/Defs/JobDef/reportString').InnerText -ne 'existing report') { 'An existing job must be preserved' }
        if ((Count $p '/Defs/JoyGiverDef') -ne 1) { 'Only the building that exists receives a provider' }
    }
}

It 'About identity' {
    $about = Load-Xml (Join-Path $mod 'About/About.xml')
    $m = $about.ModMetaData
    if ($m.packageId -ne 'nelim.malaythemedexpansion') { "packageId is $($m.packageId)" }
    if (@($m.modDependencies.li.packageId) -notcontains 'NSTR.Malay.Themed.Expansion') { 'Malay dependency not declared' }
    if (-not $m.description.Trim().EndsWith('[url=' + $m.url + ']Source code on GitHub[/url]')) { 'Description must end with the exact repository link' }
}

It 'French reports cover the English ones with the same parameters' {
    $fr = Load-Xml (Join-Path $mod 'Languages/French/DefInjected/JobDef/MalayFix.xml')
    $joy = Load-Xml (Join-Path $mod 'Patches/JoyGivers.xml')
    $names = @($fr.LanguageData.ChildNodes | Where-Object NodeType -eq Element | ForEach-Object Name)
    if ($names.Count -ne 2 -or @($names | Select-Object -Unique).Count -ne 2) { 'Expected two unique French entries' }
    foreach ($job in $joy.SelectNodes('//JobDef')) {
        $key = $job.defName + '.reportString'
        $entry = $fr.LanguageData.SelectSingleNode($key)
        if ($null -eq $entry -or [string]::IsNullOrWhiteSpace($entry.InnerText)) { "No French for $key"; continue }
        $en = @([regex]::Matches($job.reportString, 'Target[A-C]|\{[^}]+\}') | ForEach-Object Value) -join '|'
        $frTokens = @([regex]::Matches($entry.InnerText, 'Target[A-C]|\{[^}]+\}') | ForEach-Object Value) -join '|'
        if ($en -cne $frTokens) { "Parameters differ in $key ($en against $frTokens)" }
    }
}

if (-not $engine) {
    # already warned
} elseif (-not (Test-Path -LiteralPath $Upstream)) {
    Write-Warning "Installed Malay Themed Expansion not found at ${Upstream}: the upstream replay is SKIPPED here, not passed (needs the game machine)."
} else {
    It 'Patches on the installed upstream defs' {
        $live = New-Object System.Xml.XmlDocument; $live.LoadXml('<Defs/>')
        foreach ($file in Get-ChildItem -LiteralPath $Upstream -Recurse -Filter *.xml) {
            $part = Load-Xml $file.FullName
            foreach ($node in $part.DocumentElement.ChildNodes) { if ($node.NodeType -eq 'Element') { [void]$live.DocumentElement.AppendChild($live.ImportNode($node, $true)) } }
        }
        foreach ($id in 'NSTRDapur', 'NSTRElectricDapur', 'NSTRDamHaji', 'NSTRWeaveSpot', 'NSTRMade_Weave') {
            if ((Count $live "Defs/*[defName='$id']") -ne 1) { "Installed target missing or doubled: $id" }
        }
        $core = New-Object System.Xml.XmlDocument
        $core.LoadXml('<d><WorkGiverDef><defName>DoBillsCook</defName><fixedBillGiverDefs><li>ElectricStove</li><li>FueledStove</li></fixedBillGiverDefs></WorkGiverDef></d>')
        [void]$live.DocumentElement.AppendChild($live.ImportNode($core.DocumentElement.FirstChild, $true))
        Apply-Patches $live
        if ((Count $live 'Defs/WorkGiverDef[defName="DoBillsCook"]/fixedBillGiverDefs/li[starts-with(.,"NSTR")]') -ne 2) { 'Installed stoves must be listed in DoBillsCook' }
        if ((Count $live 'Defs/JoyGiverDef[starts-with(defName,"MalayFix_")]') -ne 2) { 'Installed upstream must receive both providers' }
        if ((Count $live "Defs/ThingDef[defName='NSTRDapur']/modExtensions/li[@Class='$ext']") -ne 0) { 'Installed Dapur must lose the unresolved extension' }
        foreach ($giver in $live.SelectNodes('Defs/JoyGiverDef[starts-with(defName,"MalayFix_")]')) {
            if ((Count $live "Defs/JobDef[defName='$($giver.jobDef)']") -ne 1) { "Job reference broken: $($giver.defName)" }
            foreach ($b in $giver.thingDefs.li) { if ((Count $live "Defs/ThingDef[defName='$b']") -ne 1) { "Building reference broken: $b" } }
        }
        $first = $live.OuterXml; Apply-Patches $live
        if ($live.OuterXml -cne $first) { 'Installed upstream result must be idempotent' }
    }
}

if ($script:findings.Count) { $script:findings | ForEach-Object { Write-Output $_ }; exit 1 }
Write-Output 'Rule-OwnValues: all rules passed.'
