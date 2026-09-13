param([string]$Upstream='C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\2884249920\1.6\Defs')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$mod=Join-Path $root 'Mod'
$results=[Collections.Generic.List[string]]::new()
function Assert($condition,[string]$message){if(-not $condition){throw "FAIL: $message"};$results.Add("PASS: $message")}
# Bounded DOM interpreter, not RimWorld def construction or Unity gameplay.
function Apply-Operation([xml]$target,[Xml.XmlElement]$operation){
 switch($operation.GetAttribute('Class')){
  'PatchOperationConditional' {
   $branch=if($target.SelectNodes($operation.xpath).Count){$operation.SelectSingleNode('match')}else{$operation.SelectSingleNode('nomatch')}
   if($branch){Apply-Operation $target $branch}
  }
  'PatchOperationSequence' {foreach($item in $operation.operations.li){Apply-Operation $target $item}}
  'PatchOperationAdd' {
   $parents=@($target.SelectNodes($operation.xpath));if(-not $parents.Count){throw 'Add target not found'}
   foreach($parent in $parents){foreach($node in $operation.value.ChildNodes){if($node.NodeType -eq 'Element'){[void]$parent.AppendChild($target.ImportNode($node,$true))}}}
  }
  'PatchOperationRemove' {
   $nodes=@($target.SelectNodes($operation.xpath));if(-not $nodes.Count){throw 'Remove target not found'}
   foreach($node in $nodes){[void]$node.ParentNode.RemoveChild($node)}
  }
  default {throw "Unsupported operation: $($operation.Class)"}
 }
}
function Apply-Patches([xml]$target){
 foreach($file in Get-ChildItem (Join-Path $mod 'Patches') -Filter *.xml){
  $patch=[xml](Get-Content $file.FullName -Raw)
  foreach($op in $patch.Patch.Operation){Apply-Operation $target $op}
 }
}
foreach($file in Get-ChildItem $mod -Recurse -Filter *.xml){$null=[xml](Get-Content $file.FullName -Raw);Assert $true "XML parses: $($file.FullName.Substring($mod.Length+1))"}
$x=[xml]'<Defs><ThingDef><defName>NSTRDapur</defName><recipes><li>CookMealSimple</li></recipes><modExtensions><li Class="VEF.Buildings.RecipeInheritanceExtension"/><li Class="Other.Extension"/></modExtensions></ThingDef><ThingDef><defName>NSTRElectricDapur</defName><modExtensions><li Class="VEF.Buildings.RecipeInheritanceExtension"/></modExtensions></ThingDef><ThingDef><defName>NSTRDamHaji</defName></ThingDef><ThingDef><defName>NSTRWeaveSpot</defName></ThingDef></Defs>'
Apply-Patches $x
Assert ($x.SelectNodes('//modExtensions/li[@Class="VEF.Buildings.RecipeInheritanceExtension"]').Count -eq 0) 'Both problematic stove extensions removed'
Assert ($x.SelectNodes('//modExtensions/li[@Class="Other.Extension"]').Count -eq 1) 'Unrelated extension preserved'
Assert ($x.SelectNodes('//recipes/li[text()="CookMealSimple"]').Count -eq 1) 'Explicit cooking recipe preserved'
Assert ($x.SelectNodes('/Defs/JobDef').Count -eq 2 -and $x.SelectNodes('/Defs/JoyGiverDef').Count -eq 2) 'Exactly two jobs and providers supplied'
$first=$x.OuterXml;Apply-Patches $x
Assert ($x.OuterXml -ceq $first) 'Repeated application is idempotent'
$empty=[xml]'<Defs/>';Apply-Patches $empty
Assert ($empty.SelectNodes('/Defs/*').Count -eq 0) 'Missing upstream produces no orphan defs'
$corrected=[xml]'<Defs><ThingDef><defName>NSTRDamHaji</defName></ThingDef><ThingDef><defName>NSTRWeaveSpot</defName></ThingDef><JoyGiverDef><defName>UpstreamBoard</defName><thingDefs><li>NSTRDamHaji</li></thingDefs></JoyGiverDef><JoyGiverDef><defName>UpstreamWeaving</defName><thingDefs><li>NSTRWeaveSpot</li></thingDefs></JoyGiverDef></Defs>'
$before=$corrected.OuterXml;Apply-Patches $corrected
Assert ($before -ceq $corrected.OuterXml) 'Already-served upstream buildings unchanged'
$partial=[xml]'<Defs><ThingDef><defName>NSTRDamHaji</defName></ThingDef><JobDef><defName>MalayFix_Play_DamHaji</defName><reportString>existing report</reportString></JobDef></Defs>'
Apply-Patches $partial
Assert ($partial.SelectNodes('/Defs/JobDef').Count -eq 1 -and $partial.SelectSingleNode('/Defs/JobDef/reportString').InnerText -eq 'existing report') 'Existing job preserved'
Assert ($partial.SelectNodes('/Defs/JoyGiverDef').Count -eq 1) 'Only present building receives a giver'
$about=[xml](Get-Content (Join-Path $mod 'About/About.xml') -Raw)
Assert ($about.ModMetaData.packageId -eq 'nelim.malaythemedexpansionrenew') 'Current package ID'
Assert ($about.ModMetaData.modDependencies.li.packageId -contains 'NSTR.Malay.Themed.Expansion') 'Malay dependency declared'
Assert ($about.ModMetaData.description.Trim().EndsWith('[url='+$about.ModMetaData.url+']Source code on GitHub[/url]')) 'Exact final repository link'
$translation=[xml](Get-Content (Join-Path $mod 'Languages/French/DefInjected/JobDef/MalayFix.xml') -Raw)
$fr=@($translation.LanguageData.ChildNodes | Where-Object NodeType -eq Element)
Assert ($fr.Count -eq 2 -and @($fr.Name|Select-Object -Unique).Count -eq 2) 'Two unique French entries'
$joy=[xml](Get-Content (Join-Path $mod 'Patches/JoyGivers.xml') -Raw)
foreach($job in $joy.SelectNodes('//JobDef')){
 $key=$job.defName+'.reportString';$entry=$translation.LanguageData.SelectSingleNode($key)
 Assert ($null -ne $entry -and -not [string]::IsNullOrWhiteSpace($entry.InnerText)) "French coverage: $key"
 $enTokens=@([regex]::Matches($job.reportString,'Target[A-C]|\{[^}]+\}')|ForEach-Object Value)
 $frTokens=@([regex]::Matches($entry.InnerText,'Target[A-C]|\{[^}]+\}')|ForEach-Object Value)
 Assert (($enTokens -join '|') -ceq ($frTokens -join '|')) "Parameters preserved: $key"
}
foreach($name in 'LICENSE','ATTRIBUTION.md'){Assert ((Get-FileHash (Join-Path $root $name)).Hash -eq (Get-FileHash (Join-Path $mod $name)).Hash) "Distributed copy matches: $name"}
if(-not (Test-Path $Upstream)){throw 'Installed upstream required'}
$live=[xml]'<Defs/>'
$upstreamFiles=@(Get-ChildItem $Upstream -Recurse -Filter *.xml)
foreach($file in $upstreamFiles){
 $part=[xml](Get-Content $file.FullName -Raw)
 foreach($node in $part.DocumentElement.ChildNodes){if($node.NodeType -eq 'Element'){[void]$live.DocumentElement.AppendChild($live.ImportNode($node,$true))}}
}
foreach($id in 'NSTRDapur','NSTRElectricDapur','NSTRDamHaji','NSTRWeaveSpot','NSTRMade_Weave'){Assert ($live.SelectNodes('Defs/*[defName="'+$id+'"]').Count -eq 1) "Installed target: $id"}
Apply-Patches $live
Assert ($live.SelectNodes('Defs/JoyGiverDef[starts-with(defName,"MalayFix_")]').Count -eq 2) 'Installed upstream receives both providers'
foreach($giver in $live.SelectNodes('Defs/JoyGiverDef[starts-with(defName,"MalayFix_")]')){
 Assert ($live.SelectNodes('Defs/JobDef[defName="'+$giver.jobDef+'"]').Count -eq 1) "Job reference: $($giver.defName)"
 foreach($building in $giver.thingDefs.li){Assert ($live.SelectNodes('Defs/ThingDef[defName="'+$building+'"]').Count -eq 1) "Building reference: $building"}
}
$first=$live.OuterXml;Apply-Patches $live
Assert ($live.OuterXml -ceq $first) 'Installed upstream result is idempotent'
Add-Type -AssemblyName System.Drawing
foreach($spec in @(@('ModIcon.png',128,128),@('Preview.png',896,504))){
 $file=Get-Item (Join-Path $mod ('About/'+$spec[0]));$img=[Drawing.Image]::FromFile($file.FullName)
 try{Assert ($img.Width -eq $spec[1] -and $img.Height -eq $spec[2] -and $img.RawFormat.Guid -eq [Drawing.Imaging.ImageFormat]::Png.Guid) "PNG format/dimensions: $($spec[0])"}finally{$img.Dispose()}
 if($spec[0] -eq 'Preview.png'){Assert ($file.Length -lt 1000000) 'Preview below 1 MB'}
}
$lines=@('# Technical test results','',('Run: '+(Get-Date -Format o)),('HEAD: '+(& git -C $root rev-parse HEAD)), 'Scope: working tree; DOM simulation, not RimWorld runtime.', '', "Passed: $($results.Count)",'')+$results+@('','## Delivered file hashes (SHA-256)','')
$lines+=Get-ChildItem $mod -Recurse -File|Sort-Object FullName|ForEach-Object{(Get-FileHash $_.FullName).Hash+'  '+$_.FullName.Substring($root.Length+1)}
$lines+=@('','## Installed upstream fixture hashes','')
$lines+=$upstreamFiles|Sort-Object FullName|ForEach-Object{(Get-FileHash $_.FullName).Hash+'  '+$_.FullName.Substring($Upstream.Length+1)}
[IO.File]::WriteAllLines((Join-Path $PSScriptRoot 'RESULTS.md'),$lines,[Text.UTF8Encoding]::new($false))
$results
"PASS: $($results.Count) checks"