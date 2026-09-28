<#
.SYNOPSIS
  Compile this suite's step patterns with Pickle's own expression engine, and check that every step line of its
  features resolves to exactly one expression. No game, a few seconds.

.DESCRIPTION
  A step pattern that does not compile makes a run play zero scenarios ("infrastructure-error"), and two patterns that
  both match one line make it an "Ambiguous step" and fail a healthy scenario. Parentheses mean optional text and a
  slash means alternation in a Cucumber Expression, so a text such as "at (x, y)" is not what it looks like. Neither
  fault is visible until a run has cost tens of minutes of a machine that is shared.

  Four checks:

    1. every pattern under Source\ COMPILES with the PickleParameterTypeRegistry the game uses;
    2. no pattern is declared twice;
    3. every step line of Mod\Pickle\Features\*.feature matches exactly ONE expression among this suite's and Pickle's
       own vocabulary, read from the two Pickle assemblies that carry steps. A line that matches none is a step nobody
       wrote; a line that matches two is ambiguous;
    4. no line of this suite's features is matched by one of THIS suite's expressions and by a step of another suite of
       the collection, when the collection is around this repository (the steps of every installed suite share one
       namespace). Skipped, and said so, when this repository stands alone.

  A pattern no feature uses is reported as weight, not as an error.

.EXAMPLE
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File Tests/Pickle/Check-Steps.ps1
#>
param(
    [string]$PickleAssemblies = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100\3791648678\Assemblies',
    [string]$Cecil = "$env:USERPROFILE\.nuget\packages\mono.cecil\0.11.5\lib\net40\Mono.Cecil.dll"
)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$repo = Split-Path (Split-Path $here -Parent) -Parent        # the repository root

foreach ($dll in 'CucumberExpressions.dll', 'RimWorks.Pickle.Core.dll') {
    $path = Join-Path $PickleAssemblies $dll
    if (-not (Test-Path $path)) { throw "$dll not found under $PickleAssemblies" }
    [Reflection.Assembly]::LoadFrom($path) | Out-Null
}
if (-not (Test-Path $Cecil)) { throw "Mono.Cecil not found at ${Cecil} - it is the reader of Pickle's step attributes" }
Add-Type -Path $Cecil
$core = [AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq 'RimWorks.Pickle.Core' }
$registryType = $core.GetType('RimWorks.Pickle.Core.Steps.PickleParameterTypeRegistry')
if (-not $registryType) { throw 'PickleParameterTypeRegistry no longer exists: Pickle renamed it, update this script.' }
$registry = [Activator]::CreateInstance($registryType)
function New-Expr($pattern) { New-Object CucumberExpressions.CucumberExpression($pattern, $registry) }

# The attribute argument is a C# literal: undo its escaping to get the pattern Pickle sees.
$attr = '\[(?:Given|When|Then)\("((?:[^"\\]|\\.)*)"'
function Read-Patterns($dir, $source) {
    foreach ($f in Get-ChildItem -LiteralPath $dir -Filter *.cs -ErrorAction SilentlyContinue) {
        $text = [IO.File]::ReadAllText($f.FullName)
        foreach ($m in [regex]::Matches($text, $attr)) {
            [pscustomobject]@{ Source = $source; File = $f.Name; Pattern = ($m.Groups[1].Value -replace '\\\\', '\' -replace '\\"', '"') }
        }
        # A tool that keeps its prefix in a constant: [When(Prefix + "text")], the constant declared in the same file.
        foreach ($m in [regex]::Matches($text, '\[(?:Given|When|Then)\((\w+) \+ "((?:[^"\\]|\\.)*)"')) {
            $c = [regex]::Match($text, 'const string ' + $m.Groups[1].Value + ' = "((?:[^"\\]|\\.)*)"')
            if (-not $c.Success) { continue }
            [pscustomobject]@{ Source = $source; File = $f.Name; Pattern = (($c.Groups[1].Value + $m.Groups[2].Value) -replace '\\\\', '\' -replace '\\"', '"') }
        }
    }
}

$bad = 0

# --- 1 and 2. this suite -------------------------------------------------------------------------------

$mine = @(Read-Patterns (Join-Path $here 'Source') 'malayfix')
if ($mine.Count -eq 0) { throw "no step patterns under $here\Source: the attribute shape this script looks for has changed" }

foreach ($g in ($mine | Group-Object Pattern | Where-Object { $_.Count -gt 1 })) {
    Write-Host "DUPLICATE  $($g.Name)  (declared $($g.Count) times)" -ForegroundColor Red; $bad++
}
$myExprs = @()
foreach ($d in $mine) {
    try { $myExprs += [pscustomobject]@{ Pattern = $d.Pattern; Regex = (New-Expr $d.Pattern).Regex; Used = $false } }
    catch {
        $e = $_.Exception; while ($e.InnerException) { $e = $e.InnerException }
        Write-Host "INVALID  $($d.File): $($d.Pattern)`n         $($e.Message.Split("`n")[0])" -ForegroundColor Red; $bad++
    }
}

# --- Pickle's own vocabulary -----------------------------------------------------------------------------

$others = @()
foreach ($name in 'RimWorks.Pickle.Vanilla.dll', 'RimWorks.Pickle.dll') {
    $asm = [Mono.Cecil.AssemblyDefinition]::ReadAssembly((Join-Path $PickleAssemblies $name))
    foreach ($t in $asm.MainModule.GetTypes()) {
        foreach ($m in $t.Methods) {
            foreach ($a in $m.CustomAttributes | Where-Object { $_.AttributeType.Name -in 'GivenAttribute', 'WhenAttribute', 'ThenAttribute' }) {
                $others += [pscustomobject]@{ Source = 'pickle'; Pattern = [string]$a.ConstructorArguments[0].Value }
            }
        }
    }
}
# Handled by the runner without an attribute the extraction sees. The first is used verbatim by the features Pickle
# ships; the second by AnimaSong's 03 feature, which played and passed on 2026-09-23.
foreach ($p in 'the save {string} is loaded', 'I save and reload') { $others += [pscustomobject]@{ Source = 'pickle-engine'; Pattern = $p } }
$pickleCount = $others.Count

# --- the other suites of the collection, when they are around --------------------------------------------

$collection = Split-Path $repo -Parent
$suites = 0
foreach ($dir in Get-ChildItem -LiteralPath $collection -Directory -ErrorAction SilentlyContinue) {
    if ($dir.Attributes -band [IO.FileAttributes]::ReparsePoint) { continue }     # a junction would count a suite twice
    if ($dir.FullName -eq $repo) { continue }
    $src = Join-Path $dir.FullName 'Tests\Pickle\Source'
    if (-not (Test-Path -LiteralPath $src)) { continue }
    $suites++
    foreach ($p in Read-Patterns $src ('suite:' + $dir.Name)) { $others += $p }
}
# PickleTools is one repository holding a step assembly per tool, each under <Tool>\Source: a pass map can stage any of them, so a
# feature may use their steps (the screenshot studio's, for the Workshop captures).
$toolsRoot = Join-Path $collection 'PickleTools'
foreach ($tool in Get-ChildItem -LiteralPath $toolsRoot -Directory -ErrorAction SilentlyContinue) {
    $src = Join-Path $tool.FullName 'Source'
    if (-not (Test-Path -LiteralPath $src)) { continue }
    $suites++
    foreach ($p in Read-Patterns $src ('tool:' + $tool.Name)) { $others += $p }
}
$otherExprs = @()
foreach ($o in $others) {
    try { $otherExprs += [pscustomobject]@{ Source = $o.Source; Pattern = $o.Pattern; Regex = (New-Expr $o.Pattern).Regex } } catch { }   # their own check reports those
}

# --- 3 and 4. every step line of this suite's features ---------------------------------------------------

$featureFiles = @(Get-ChildItem -LiteralPath (Join-Path $here 'Mod\Pickle\Features') -Filter *.feature)
$lines = 0; $unresolved = @(); $ambiguous = @{}
foreach ($file in $featureFiles) {
    foreach ($raw in [IO.File]::ReadAllLines($file.FullName)) {
        if ($raw.Trim() -notmatch '^(Given|When|Then|And|But)\s+(.+)$') { continue }
        $step = $Matches[2].Trim(); $lines++
        $mineHit  = @($myExprs    | Where-Object { $_.Regex.IsMatch($step) })
        $otherHit = @($otherExprs | Where-Object { $_.Regex.IsMatch($step) })
        foreach ($h in $mineHit) { $h.Used = $true }
        if ($mineHit.Count + $otherHit.Count -eq 0) { $unresolved += "$($file.Name): $step"; continue }
        if ($mineHit.Count + $otherHit.Count -gt 1) {
            $names = @($mineHit | ForEach-Object { 'this suite "' + $_.Pattern + '"' }) + @($otherHit | ForEach-Object { "$($_.Source) `"$($_.Pattern)`"" })
            $ambiguous[$step] = "$($file.Name): matches " + ($names -join ' AND ')
        }
    }
}

# --- report ------------------------------------------------------------------------------------------------

Write-Host ''
Write-Host "$($mine.Count) patterns, $($myExprs.Count) compile. $lines step lines in $($featureFiles.Count) feature files, matched against $($pickleCount) steps of Pickle and $($otherExprs.Count - $pickleCount) of $suites other suites."
if ($suites -eq 0) { Write-Host 'No other suite is around this repository: the shared-namespace check (4) was skipped.' -ForegroundColor Yellow }

foreach ($k in $ambiguous.Keys) { Write-Host "AMBIGUOUS  $k`n           $($ambiguous[$k])" -ForegroundColor Red; $bad++ }
if ($unresolved.Count -gt 0) {
    Write-Host ''
    Write-Host "$($unresolved.Count) step line(s) match no expression at all:" -ForegroundColor Red
    $unresolved | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    $bad++
}
$unused = @($myExprs | Where-Object { -not $_.Used })
if ($unused.Count -gt 0) {
    Write-Host ''
    Write-Host "$($unused.Count) pattern(s) no feature uses - weight, not coverage:" -ForegroundColor Yellow
    foreach ($u in $unused) { Write-Host "  $($u.Pattern)" -ForegroundColor Yellow }
}

Write-Host ''
if ($bad -gt 0) {
    Write-Host "$bad PROBLEM(S). An invalid pattern makes a run play zero scenarios; an ambiguous line fails a healthy scenario." -ForegroundColor Red
    exit 1
}
Write-Host 'ALL PATTERNS COMPILE, NONE DECLARED TWICE, EVERY STEP LINE RESOLVES TO EXACTLY ONE EXPRESSION' -ForegroundColor Green
exit 0
