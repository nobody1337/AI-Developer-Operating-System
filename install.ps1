#requires -Version 5.1
<#
.SYNOPSIS
    Installs or updates the embedded AI-DOS tool adapters of a software project.

.DESCRIPTION
    Copy the Central AI-DOS folder (without .git) to <project>/.ai-dos/ and run
    this script from the copy, for example from the project root:

        .\.ai-dos\install.ps1            # install: create what is missing
        .\.ai-dos\install.ps1 -WhatIf    # dry run: show what would happen
        .\.ai-dos\install.ps1 -Update    # also refresh outdated generated files

    The project root is the parent of the folder that contains this script; the
    script refuses to run unless that folder is named ".ai-dos".

    Generated for every tool (no selection): Cursor (.cursor/rules, .cursor/commands),
    shared skill adapters (.agents/skills, read by Cursor, Codex and Copilot),
    Claude Code (CLAUDE.md block, .claude/rules, .claude/commands, .claude/settings.json),
    GitHub Copilot (.github/copilot-instructions.md block, .github/instructions,
    .github/prompts), the AGENTS.md block (Cursor, Codex, Copilot, Claude via import)
    and the AI-DOS block of .gitignore. .ai-dos/manifest.yaml and
    .ai-dos/project-profile.yaml are created from the templates only if missing.

    Safety rules:
    - Existing project files are never overwritten. In AGENTS.md, CLAUDE.md,
      .github/copilot-instructions.md and .gitignore only the marked AI-DOS block
      is inserted or replaced.
    - Whole generated files carry a provenance marker with a SHA-256 of their
      content. A file without marker, or whose content no longer matches its
      hash (local edit), is reported as conflict and not touched. Paths declared
      in integration.local_modifications of the manifest are kept (keep_local).
    - Nothing is deleted. Generated files that are no longer expected are
      reported as removed_proposed.
    - No network access, no absolute paths in generated output, .cursorignore is
      never created (copy .ai-dos/templates/cursorignore.template manually).

    Exit code: 0 = no conflicts, 1 = conflicts reported, 2 = preflight failure.

.PARAMETER Update
    Replace generated files and blocks whose content is outdated (only if they
    are unmodified since generation). Without -Update they are reported as
    "outdated". Also updates ai_dos.version, source.version and updated_at in
    an existing manifest when .ai-dos/VERSION differs.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Update
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$script:Cmdlet = $PSCmdlet
$script:Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$script:Results = New-Object System.Collections.Generic.List[object]
$script:AiDosRoot = $PSScriptRoot
$script:ProjectRoot = Split-Path -Parent $PSScriptRoot
$script:DryRun = [bool]$WhatIfPreference
$script:LocalModifications = @()

$BlockBeginHtml = '<!-- ai-dos:begin (generated; do not edit) -->'
$BlockEndHtml = '<!-- ai-dos:end -->'
$BlockBeginHash = '# ai-dos:begin'
$BlockEndHash = '# ai-dos:end'
$MarkerText = 'ai-dos:generated (do not edit; regenerate with .ai-dos/install.ps1 -Update)'
$PrefixPattern = '`(governance|orchestration|skills|templates|checklists|integration)/'

# --------------------------------------------------------------------------
# Helpers
# --------------------------------------------------------------------------

function Add-Result([string]$Status, [string]$Path, [string]$Note = '') {
    $script:Results.Add([pscustomobject]@{ Status = $Status; Path = $Path; Note = $Note })
}

function Get-ProjectPath([string]$Rel) {
    return [IO.Path]::Combine($script:ProjectRoot, ($Rel -replace '/', [IO.Path]::DirectorySeparatorChar))
}

function Get-AiDosPath([string]$Rel) {
    return [IO.Path]::Combine($script:AiDosRoot, ($Rel -replace '/', [IO.Path]::DirectorySeparatorChar))
}

function ConvertTo-Lf([string]$Text) {
    return ($Text -replace "`r`n", "`n")
}

function Read-TextFile([string]$FullPath) {
    $bytes = [IO.File]::ReadAllBytes($FullPath)
    $bom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    if ($bom) { $text = $script:Utf8NoBom.GetString($bytes, 3, $bytes.Length - 3) }
    else { $text = $script:Utf8NoBom.GetString($bytes) }
    return [pscustomobject]@{ Text = (ConvertTo-Lf $text); Bom = $bom; Crlf = $text.Contains("`r`n") }
}

function Read-Source([string]$Rel) {
    $full = Get-AiDosPath $Rel
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { throw "AI-DOS source file missing: .ai-dos/$Rel" }
    return (Read-TextFile $full).Text
}

function Write-ProjectFile([string]$Rel, [string]$Text, [bool]$Bom = $false, [bool]$Crlf = $false) {
    $out = ConvertTo-Lf $Text
    if (-not $out.EndsWith("`n")) { $out += "`n" }
    if ($Crlf) { $out = $out -replace "`n", "`r`n" }
    if ($script:Cmdlet.ShouldProcess($Rel, 'Write file')) {
        $full = Get-ProjectPath $Rel
        $dir = [IO.Path]::GetDirectoryName($full)
        if (-not [IO.Directory]::Exists($dir)) { [void][IO.Directory]::CreateDirectory($dir) }
        $enc = $script:Utf8NoBom
        if ($Bom) { $enc = New-Object System.Text.UTF8Encoding($true) }
        [IO.File]::WriteAllText($full, $out, $enc)
    }
}

function Get-ContentHash([string]$Text) {
    $lines = (ConvertTo-Lf $Text) -split "`n" | ForEach-Object { $_.TrimEnd() }
    $norm = ($lines -join "`n").Trim("`n")
    $sha = [Security.Cryptography.SHA256]::Create()
    try { $hash = $sha.ComputeHash($script:Utf8NoBom.GetBytes($norm)) } finally { $sha.Dispose() }
    return (-join ($hash | ForEach-Object { $_.ToString('x2') }))
}

function Split-Frontmatter([string]$Text) {
    $t = ConvertTo-Lf $Text
    if ($t.StartsWith("---`n")) {
        $end = $t.IndexOf("`n---`n", 3, [StringComparison]::Ordinal)
        if ($end -ge 0) {
            return [pscustomobject]@{ HasFront = $true; Front = $t.Substring(4, $end - 4); Body = $t.Substring($end + 5) }
        }
    }
    return [pscustomobject]@{ HasFront = $false; Front = ''; Body = $t }
}

function Get-FrontValue([string]$Front, [string]$Key) {
    foreach ($line in ($Front -split "`n")) {
        if ($line -match ('^' + [regex]::Escape($Key) + ':\s*(.*)$')) { return $Matches[1].Trim() }
    }
    return ''
}

function Add-AiDosPrefix([string]$Text) {
    return ($Text -replace $PrefixPattern, '`.ai-dos/$1/')
}

function Get-Template([string]$Rel) {
    $t = Read-Source $Rel
    $t = [regex]::Replace($t, '(?s)<!-- template:.*?-->\n*', '')
    $t = [regex]::Replace($t, '(?m)^# template:.*\n', '')
    return $t
}

function Expand-Template([string]$Template, [hashtable]$Values) {
    $t = $Template
    foreach ($key in $Values.Keys) { $t = $t.Replace('{{' + $key + '}}', [string]$Values[$key]) }
    return $t
}

function Format-YamlString([string]$Value) {
    return '"' + ($Value.Replace('\', '\\').Replace('"', '\"')) + '"'
}

function Add-Marker([string]$Content, [string]$Source, [string]$Hash, [string]$Style) {
    $inner = "$MarkerText source=$Source sha256=$Hash"
    if ($Style -eq 'yaml') { $marker = "# $inner" } else { $marker = "<!-- $inner -->" }
    $split = Split-Frontmatter $Content
    if ($split.HasFront) { return "---`n" + $split.Front + "`n---`n" + $marker + "`n" + $split.Body }
    return $marker + "`n" + (ConvertTo-Lf $Content)
}

function Remove-Marker([string]$Text) {
    $rx = New-Object System.Text.RegularExpressions.Regex('(?m)^[^\n]*ai-dos:generated [^\n]*sha256=[0-9a-f]{64}[^\n]*\n?')
    return $rx.Replace($Text, '', 1)
}

function Test-LocalModification([string]$Rel) {
    return ($script:LocalModifications -contains $Rel)
}

# Whole generated file with provenance marker.
function Set-GeneratedFile([string]$Rel, [string]$Content, [string]$Source, [string]$Style = 'html') {
    $content = ConvertTo-Lf $Content
    $newHash = Get-ContentHash $content
    $full = Get-ProjectPath $Rel
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
        Write-ProjectFile $Rel (Add-Marker $content $Source $newHash $Style)
        Add-Result 'created' $Rel
        return
    }
    if (Test-LocalModification $Rel) { Add-Result 'keep_local' $Rel 'declared in manifest local_modifications'; return }
    $cur = Read-TextFile $full
    $m = [regex]::Match($cur.Text, 'ai-dos:generated [^\n]*sha256=([0-9a-f]{64})')
    if (-not $m.Success) { Add-Result 'conflict' $Rel 'exists without AI-DOS provenance marker; not touched'; return }
    $stored = $m.Groups[1].Value
    if ((Get-ContentHash (Remove-Marker $cur.Text)) -ne $stored) {
        Add-Result 'conflict' $Rel 'modified since generation (RISK: undeclared change); not touched'
        return
    }
    if ($stored -eq $newHash) { Add-Result 'unchanged' $Rel; return }
    if (-not $Update) { Add-Result 'outdated' $Rel 'run with -Update to refresh'; return }
    Write-ProjectFile $Rel (Add-Marker $content $Source $newHash $Style) $cur.Bom $cur.Crlf
    Add-Result 'updated' $Rel
}

# Marked block inside a project-owned file.
function Set-Block([string]$Rel, [string]$Body, [string]$Style, [string]$Skeleton) {
    if ($Style -eq 'hash') { $begin = $BlockBeginHash; $end = $BlockEndHash; $hashFmt = '# ai-dos:hash sha256={0}' }
    else { $begin = $BlockBeginHtml; $end = $BlockEndHtml; $hashFmt = '<!-- ai-dos:hash sha256={0} -->' }
    $body = (ConvertTo-Lf $Body).Trim("`n")
    $newHash = Get-ContentHash $body
    $block = $begin + "`n" + ($hashFmt -f $newHash) + "`n" + $body + "`n" + $end
    $full = Get-ProjectPath $Rel

    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
        if ($Skeleton) { $text = $Skeleton.Replace('{{AIDOS_BLOCK}}', $block) } else { $text = $block + "`n" }
        Write-ProjectFile $Rel $text
        Add-Result 'created' $Rel
        return
    }
    $cur = Read-TextFile $full
    $lines = $cur.Text -split "`n"
    $bi = @(); $ei = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $l = $lines[$i].TrimEnd()
        if ($l -eq $begin) { $bi += $i }
        elseif ($l -eq $end) { $ei += $i }
    }
    if ($bi.Count -eq 0 -and $ei.Count -eq 0) {
        $text = $cur.Text
        if ($text.Length -gt 0 -and -not $text.EndsWith("`n")) { $text += "`n" }
        if ($text.Length -gt 0) { $text += "`n" }
        Write-ProjectFile $Rel ($text + $block + "`n") $cur.Bom $cur.Crlf
        Add-Result 'inserted' $Rel 'AI-DOS block appended; project content preserved'
        return
    }
    if ($bi.Count -ne 1 -or $ei.Count -ne 1 -or $bi[0] -gt $ei[0]) {
        Add-Result 'conflict' $Rel 'AI-DOS block markers malformed or duplicated; not touched'
        return
    }
    $innerLines = @()
    if ($ei[0] - $bi[0] -gt 1) { $innerLines = $lines[($bi[0] + 1)..($ei[0] - 1)] }
    $inner = $innerLines -join "`n"
    $hm = [regex]::Match($inner, '^[^\n]*ai-dos:hash sha256=([0-9a-f]{64})[^\n]*(\n|$)')
    if (-not $hm.Success) {
        if ((Get-ContentHash $inner) -eq $newHash) { Add-Result 'unchanged' $Rel 'block without hash line equals generated content' }
        else { Add-Result 'conflict' $Rel 'AI-DOS block has no hash line (manual or edited); delete the block and run again to regenerate' }
        return
    }
    $stored = $hm.Groups[1].Value
    if ((Get-ContentHash $inner.Substring($hm.Length)) -ne $stored) {
        Add-Result 'conflict' $Rel 'AI-DOS block modified since generation (RISK: undeclared change); not touched'
        return
    }
    if ($stored -eq $newHash) { Add-Result 'unchanged' $Rel; return }
    if (-not $Update) { Add-Result 'outdated' $Rel 'AI-DOS block outdated; run with -Update'; return }
    $before = @(); $after = @()
    if ($bi[0] -gt 0) { $before = $lines[0..($bi[0] - 1)] }
    if ($ei[0] -lt $lines.Count - 1) { $after = $lines[($ei[0] + 1)..($lines.Count - 1)] }
    $text = (@($before) + @($block) + @($after)) -join "`n"
    Write-ProjectFile $Rel $text $cur.Bom $cur.Crlf
    Add-Result 'updated' $Rel 'AI-DOS block replaced; project content preserved'
}

function New-ProjectFileFromTemplate([string]$Rel, [string]$Text, [string]$Note) {
    $full = Get-ProjectPath $Rel
    if (Test-Path -LiteralPath $full -PathType Leaf) { Add-Result 'unchanged' $Rel 'exists; project-owned, not touched'; return $false }
    Write-ProjectFile $Rel $Text
    Add-Result 'created' $Rel $Note
    return $true
}

function Get-ProfileList([string]$Text, [string]$Key) {
    $lines = (ConvertTo-Lf $Text) -split "`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match ('^\s*' + [regex]::Escape($Key) + ':\s*(.*)$')) {
            $rest = ($Matches[1] -replace '\s+#.*$', '').Trim()
            if ($rest -match '^\[(.*)\]$') {
                return @($Matches[1] -split ',' | ForEach-Object { $_.Trim().Trim('"', "'") } | Where-Object { $_ })
            }
            if ($rest -ne '') { return @($rest.Trim('"', "'")) }
            $items = @()
            for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                $l = $lines[$j]
                if ($l -match '^\s*-\s*([^#]+?)\s*(#.*)?$') { $items += $Matches[1].Trim('"', "'") }
                elseif ($l.Trim() -eq '' -or $l.TrimStart().StartsWith('#')) { continue }
                else { break }
            }
            return $items
        }
    }
    return @()
}

function Format-RuleForEntryFile([string]$RuleFile, [string]$Body) {
    $out = New-Object System.Collections.Generic.List[string]
    $inFence = $false
    foreach ($l in ((ConvertTo-Lf $Body).Trim("`n") -split "`n")) {
        if ($l -match '^\s*```') { $inFence = -not $inFence; $out.Add($l); continue }
        if (-not $inFence -and $l -match '^#{1,3} ') { $out.Add('###' + $l) } else { $out.Add($l) }
    }
    $text = ($out -join "`n")
    $nl = $text.IndexOf("`n")
    if ($nl -lt 0) { return $text + "`n`n(Rule file: ``.cursor/rules/$RuleFile``)" }
    return $text.Substring(0, $nl) + "`n`n(Rule file: ``.cursor/rules/$RuleFile``)" + $text.Substring($nl)
}

# --------------------------------------------------------------------------
# Preflight
# --------------------------------------------------------------------------

if ((Split-Path -Leaf $script:AiDosRoot) -ne '.ai-dos') {
    Write-Error ("install.ps1 must run from <project>/.ai-dos/. This copy lives in '" + (Split-Path -Leaf $script:AiDosRoot) +
        "'. In the Central AI-DOS master it must not be run; copy the folder to <project>/.ai-dos/ first.") -ErrorAction Continue
    exit 2
}
if (Test-Path -LiteralPath (Get-AiDosPath '.git')) {
    Write-Error '.ai-dos/.git exists: the copy includes the master git repository. Remove .ai-dos/.git (copy without .git) and run again.' -ErrorAction Continue
    exit 2
}
foreach ($required in @('VERSION', '.cursor/rules', '.cursor/commands', '.cursor/skills', 'templates', 'governance')) {
    if (-not (Test-Path -LiteralPath (Get-AiDosPath $required))) {
        Write-Error "Incomplete AI-DOS copy: .ai-dos/$required is missing." -ErrorAction Continue
        exit 2
    }
}

$version = (Read-Source 'VERSION').Trim()
$today = (Get-Date).ToString('yyyy-MM-dd')
$mode = 'install'; if ($Update) { $mode = 'update' }
Write-Host ("AI-DOS {0} - mode: {1}{2} - project: {3}" -f $version, $mode, $(if ($script:DryRun) { ' (dry run)' } else { '' }), (Split-Path -Leaf $script:ProjectRoot))
if (-not (Test-Path -LiteralPath (Get-ProjectPath '.git'))) {
    Add-Result 'info' '.git' 'project root is not a git repository: make a backup before installing or updating'
}

# --------------------------------------------------------------------------
# Project-owned directories, manifest, profile
# --------------------------------------------------------------------------

foreach ($dir in @('workflows', 'local/rules', 'local/skills', 'state/tasks', 'artifacts/tasks', 'artifacts/decisions', 'artifacts/updates')) {
    $rel = ".ai-dos/$dir/.gitkeep"
    if (-not (Test-Path -LiteralPath (Get-ProjectPath ".ai-dos/$dir"))) {
        Write-ProjectFile $rel ''
        Add-Result 'created' ".ai-dos/$dir/"
    }
}

$manifestRel = '.ai-dos/manifest.yaml'
$manifestFull = Get-ProjectPath $manifestRel
if (-not (Test-Path -LiteralPath $manifestFull -PathType Leaf)) {
    $m = Read-Source 'templates/manifest.yaml'
    $m = [regex]::Replace($m, '(?m)^(  version: )"[^"]*"', ('${1}"' + $version + '"'))
    $m = [regex]::Replace($m, '(?m)^(    version: )"[^"]*"', ('${1}"' + $version + '"'))
    $m = [regex]::Replace($m, '(?m)^(  integrated_at: )YYYY-MM-DD', ('${1}' + $today))
    Write-ProjectFile $manifestRel $m
    Add-Result 'created' $manifestRel 'from templates/manifest.yaml; review ai_dos.source.ref'
    $manifestText = $m
} else {
    $manifestText = (Read-TextFile $manifestFull).Text
    $cm = [regex]::Match($manifestText, '(?m)^  version: "?([0-9][^"\s]*)"?')
    $current = ''; if ($cm.Success) { $current = $cm.Groups[1].Value }
    $minM = [regex]::Match($manifestText, '(?m)^\s*minimum_ai_dos_version: "?([0-9][^"\s]*)"?')
    $maxM = [regex]::Match($manifestText, '(?m)^\s*maximum_ai_dos_version: "?([0-9][^"\s]*)"?')
    $vNew = [version](($version -split '-')[0])
    if ($minM.Success -and $vNew -lt [version](($minM.Groups[1].Value -split '-')[0])) {
        Write-Error "AI-DOS $version is below compatibility.minimum_ai_dos_version $($minM.Groups[1].Value). Stop: a human must decide (integration/update.md)." -ErrorAction Continue
        exit 2
    }
    if ($maxM.Success -and $vNew -gt [version](($maxM.Groups[1].Value -split '-')[0])) {
        Write-Error "AI-DOS $version is above compatibility.maximum_ai_dos_version $($maxM.Groups[1].Value). Stop: a human must decide (integration/update.md)." -ErrorAction Continue
        exit 2
    }
    if ($current -and $current -ne $version) {
        if ($Update) {
            $m = [regex]::Replace($manifestText, '(?m)^(  version: )"[^"]*"', ('${1}"' + $version + '"'))
            $m = [regex]::Replace($m, '(?m)^(    version: )"[^"]*"', ('${1}"' + $version + '"'))
            $m = [regex]::Replace($m, '(?m)^(  updated_at: ).*$', ('${1}' + $today))
            Write-ProjectFile $manifestRel $m
            Add-Result 'updated' $manifestRel "ai_dos.version $current -> $version; read CHANGELOG.md for breaking changes and migrations"
            $manifestText = $m
        } else {
            Add-Result 'outdated' $manifestRel "pinned $current, copy is $version; run with -Update after reading .ai-dos/CHANGELOG.md"
        }
    } else {
        Add-Result 'unchanged' $manifestRel
    }
    if ($manifestText -notmatch '(?m)^\s*tools:') {
        Add-Result 'info' $manifestRel 'no integration.tools / new generated paths listed; compare with .ai-dos/templates/manifest.yaml'
    }
}
$script:LocalModifications = @([regex]::Matches($manifestText, '(?m)^\s*-\s*path:\s*["'']?([^"''\s#]+)') | ForEach-Object { $_.Groups[1].Value })

$profileRel = '.ai-dos/project-profile.yaml'
$profileFull = Get-ProjectPath $profileRel
if (Test-Path -LiteralPath $profileFull -PathType Leaf) {
    $profileText = (Read-TextFile $profileFull).Text
    Add-Result 'unchanged' $profileRel 'project-owned'
} else {
    $profileText = Read-Source 'templates/project-profile.yaml'
    Write-ProjectFile $profileRel $profileText
    Add-Result 'created' $profileRel 'from templates/project-profile.yaml; fill in project, technology, tooling, security'
}

# --------------------------------------------------------------------------
# Read generator sources from the copied master
# --------------------------------------------------------------------------

$rules = @()
foreach ($f in (Get-ChildItem -LiteralPath (Get-AiDosPath '.cursor/rules') -Filter '*.mdc' -File -Force | Sort-Object Name)) {
    $text = Read-Source ".cursor/rules/$($f.Name)"
    $split = Split-Frontmatter $text
    $always = (Get-FrontValue $split.Front 'alwaysApply') -eq 'true'
    $globs = @((Get-FrontValue $split.Front 'globs') -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    $kind = 'requested'; if ($always) { $kind = 'always' } elseif ($globs.Count -gt 0) { $kind = 'glob' }
    $rules += [pscustomobject]@{
        File = $f.Name; Name = [IO.Path]::GetFileNameWithoutExtension($f.Name); Kind = $kind; Globs = $globs
        Description = (Get-FrontValue $split.Front 'description'); Front = $split.Front; Body = (Add-AiDosPrefix $split.Body)
    }
}

$commands = @()
foreach ($f in (Get-ChildItem -LiteralPath (Get-AiDosPath '.cursor/commands') -Filter '*.md' -File -Force | Sort-Object Name)) {
    $body = Add-AiDosPrefix (Read-Source ".cursor/commands/$($f.Name)")
    $desc = ''
    foreach ($l in ($body -split "`n")) { if ($l.Trim() -and -not $l.StartsWith('#')) { $desc = $l.Trim(); break } }
    $commands += [pscustomobject]@{ File = $f.Name; Name = [IO.Path]::GetFileNameWithoutExtension($f.Name); Description = $desc; Body = $body }
}

$enabledSkills = @(Get-ProfileList $profileText 'enabled_skills')
$skills = @()
foreach ($d in (Get-ChildItem -LiteralPath (Get-AiDosPath '.cursor/skills') -Directory -Force | Where-Object { $_.Name -like 'aidos-*' } | Sort-Object Name)) {
    $src = ".cursor/skills/$($d.Name)/SKILL.md"
    if (-not (Test-Path -LiteralPath (Get-AiDosPath $src) -PathType Leaf)) { continue }
    $short = $d.Name.Substring(6)
    if ($enabledSkills.Count -gt 0 -and ($enabledSkills -notcontains $short)) { continue }
    $split = Split-Frontmatter (Read-Source $src)
    $desc = Get-FrontValue $split.Front 'description'
    if ($desc -notmatch '^["'']') { $desc = Format-YamlString $desc }
    $skills += [pscustomobject]@{
        Name = $d.Name; Short = $short; Source = $src; Description = $desc
        Body = (Add-AiDosPrefix $split.Body).Replace('(Cursor adapter)', '(skill adapter)')
    }
}
foreach ($s in $enabledSkills) {
    if (-not (Test-Path -LiteralPath (Get-AiDosPath ".cursor/skills/aidos-$s/SKILL.md"))) {
        Add-Result 'info' $profileRel "ai.enabled_skills lists unknown skill '$s'"
    }
}

$tplAgentsSkill = Get-Template 'templates/adapters/agents-skill.md'
$tplCodexPolicy = Get-Template 'templates/adapters/codex-skill-policy.yaml'
$tplClaudeCommand = Get-Template 'templates/adapters/claude-command.md'
$tplClaudeRule = Get-Template 'templates/adapters/claude-rule.md'
$tplCopilotInstr = Get-Template 'templates/adapters/copilot-path-instructions.md'
$tplCopilotPrompt = Get-Template 'templates/adapters/copilot-prompt.md'

$expected = @{}
function Register-Expected([string]$Rel) { $expected[$Rel] = $true }

# --------------------------------------------------------------------------
# Cursor: rules and commands (copies with path prefixes)
# --------------------------------------------------------------------------

foreach ($r in $rules) {
    $rel = ".cursor/rules/$($r.File)"; Register-Expected $rel
    Set-GeneratedFile $rel ("---`n" + $r.Front + "`n---`n" + $r.Body) ".ai-dos/.cursor/rules/$($r.File)"
}
foreach ($c in $commands) {
    $rel = ".cursor/commands/$($c.File)"; Register-Expected $rel
    Set-GeneratedFile $rel $c.Body ".ai-dos/.cursor/commands/$($c.File)"
}

# --------------------------------------------------------------------------
# Shared skill adapters (.agents/skills: Cursor, Codex, Copilot) + Codex policy
# --------------------------------------------------------------------------

foreach ($s in $skills) {
    $rel = ".agents/skills/$($s.Name)/SKILL.md"; Register-Expected $rel
    $content = Expand-Template $tplAgentsSkill @{ NAME = $s.Name; DESCRIPTION = $s.Description; BODY = $s.Body.Trim("`n") }
    Set-GeneratedFile $rel $content ".ai-dos/$($s.Source)"
    $rel = ".agents/skills/$($s.Name)/agents/openai.yaml"; Register-Expected $rel
    Set-GeneratedFile $rel $tplCodexPolicy '.ai-dos/templates/adapters/codex-skill-policy.yaml' 'yaml'
}

# --------------------------------------------------------------------------
# Claude Code: path-scoped rules, commands (commands + skills), settings
# --------------------------------------------------------------------------

foreach ($r in ($rules | Where-Object { $_.Kind -eq 'glob' })) {
    $rel = ".claude/rules/aidos-$($r.Name).md"; Register-Expected $rel
    $paths = ($r.Globs | ForEach-Object { '  - ' + (Format-YamlString $_) }) -join "`n"
    $content = Expand-Template $tplClaudeRule @{ PATHS = $paths; BODY = $r.Body.Trim("`n") }
    Set-GeneratedFile $rel $content ".ai-dos/.cursor/rules/$($r.File)"
}
foreach ($c in $commands) {
    $rel = ".claude/commands/aidos-$($c.Name).md"; Register-Expected $rel
    $content = Expand-Template $tplClaudeCommand @{ DESCRIPTION = (Format-YamlString $c.Description); BODY = $c.Body.Trim("`n") }
    Set-GeneratedFile $rel $content ".ai-dos/.cursor/commands/$($c.File)"
}
foreach ($s in $skills) {
    $rel = ".claude/commands/$($s.Name).md"; Register-Expected $rel
    $content = Expand-Template $tplClaudeCommand @{ DESCRIPTION = $s.Description; BODY = $s.Body.Trim("`n") }
    Set-GeneratedFile $rel $content ".ai-dos/$($s.Source)"
}
$settingsRel = '.claude/settings.json'
$settingsTpl = Read-Source 'templates/adapters/claude-settings.json'
$settingsFull = Get-ProjectPath $settingsRel
if (-not (Test-Path -LiteralPath $settingsFull -PathType Leaf)) {
    Write-ProjectFile $settingsRel $settingsTpl
    Add-Result 'created' $settingsRel 'project-owned from now on'
} elseif ((Get-ContentHash (Read-TextFile $settingsFull).Text) -eq (Get-ContentHash $settingsTpl)) {
    Add-Result 'unchanged' $settingsRel
} else {
    Add-Result 'action' $settingsRel 'exists and differs from .ai-dos/templates/adapters/claude-settings.json; merge the deny/ask rules and claudeMdExcludes manually (only stricter settings)'
}

# --------------------------------------------------------------------------
# GitHub Copilot: path-specific instructions and prompt files
# --------------------------------------------------------------------------

foreach ($r in ($rules | Where-Object { $_.Kind -eq 'glob' })) {
    $rel = ".github/instructions/aidos-$($r.Name).instructions.md"; Register-Expected $rel
    $content = Expand-Template $tplCopilotInstr @{ APPLY_TO = ($r.Globs -join ','); BODY = $r.Body.Trim("`n") }
    Set-GeneratedFile $rel $content ".ai-dos/.cursor/rules/$($r.File)"
}
foreach ($c in $commands) {
    $rel = ".github/prompts/aidos-$($c.Name).prompt.md"; Register-Expected $rel
    $content = Expand-Template $tplCopilotPrompt @{ DESCRIPTION = (Format-YamlString $c.Description); BODY = $c.Body.Trim("`n") }
    Set-GeneratedFile $rel $content ".ai-dos/.cursor/commands/$($c.File)"
}

# --------------------------------------------------------------------------
# Entry files with AI-DOS block: AGENTS.md, CLAUDE.md, copilot-instructions.md
# --------------------------------------------------------------------------

$alwaysParts = @('### Always-applied rules', '', 'Generated from `.ai-dos/.cursor/rules/`; identical to the always-applied rules in `.cursor/rules/`.')
foreach ($r in ($rules | Where-Object { $_.Kind -eq 'always' })) { $alwaysParts += ''; $alwaysParts += (Format-RuleForEntryFile $r.File $r.Body) }
$alwaysText = $alwaysParts -join "`n"

$condParts = @('### Conditional rules', '', 'Read the rule file before working in its area.', '')
foreach ($r in ($rules | Where-Object { $_.Kind -ne 'always' })) {
    if ($r.Kind -eq 'glob') { $condParts += ('- `.cursor/rules/' + $r.File + '` - files matching `' + ($r.Globs -join ', ') + '`: ' + $r.Description) }
    else { $condParts += ('- `.cursor/rules/' + $r.File + '` - ' + $r.Description) }
}
$condText = $condParts -join "`n"

$skillList = ($skills | ForEach-Object { '`' + $_.Name + '`' }) -join ', '
if (-not $skillList) { $skillList = '(none enabled)' }
$commandList = ($commands | ForEach-Object { '`' + $_.Name + '`' }) -join ', '
$scText = @(
    '### Skills and commands (explicit invocation)',
    '',
    'Skill adapters contain no procedure; they point to `.ai-dos/skills/<name>/SKILL.md`.',
    '',
    '| Tool | Skills | Commands |',
    '|---|---|---|',
    '| Cursor | `/aidos-<skill>` (`.agents/skills/`) | `/<command>` (`.cursor/commands/`) |',
    '| Claude Code | `/aidos-<skill>` (`.claude/commands/`) | `/aidos-<command>` (`.claude/commands/`) |',
    '| OpenAI Codex | `$aidos-<skill>` (`.agents/skills/`) | ask Codex to follow `.cursor/commands/<command>.md` |',
    '| GitHub Copilot | `.agents/skills/` (may be selected automatically) | `/aidos-<command>` (`.github/prompts/`) |',
    '',
    ('Skills: ' + $skillList),
    '',
    ('Commands: ' + $commandList)
) -join "`n"

$blockValues = @{ AIDOS_ALWAYS_RULES = $alwaysText; AIDOS_CONDITIONAL_RULES = $condText; AIDOS_SKILLS_AND_COMMANDS = $scText }

function Get-EntryTemplateParts([string]$TemplateRel) {
    $t = Get-Template $TemplateRel
    $b = $t.IndexOf($BlockBeginHtml, [StringComparison]::Ordinal)
    $e = $t.IndexOf($BlockEndHtml, [StringComparison]::Ordinal)
    if ($b -lt 0 -or $e -lt $b) { throw "Template without AI-DOS block markers: .ai-dos/$TemplateRel" }
    $body = $t.Substring($b + $BlockBeginHtml.Length, $e - $b - $BlockBeginHtml.Length)
    $skeleton = $t.Substring(0, $b) + '{{AIDOS_BLOCK}}' + $t.Substring($e + $BlockEndHtml.Length)
    return [pscustomobject]@{ Body = (Expand-Template $body $blockValues); Skeleton = $skeleton }
}

foreach ($entry in @(
        @{ Rel = 'AGENTS.md'; Template = 'templates/project-agents.md' },
        @{ Rel = 'CLAUDE.md'; Template = 'templates/project-claude.md' },
        @{ Rel = '.github/copilot-instructions.md'; Template = 'templates/project-copilot-instructions.md' })) {
    $parts = Get-EntryTemplateParts $entry.Template
    Set-Block $entry.Rel $parts.Body 'html' $parts.Skeleton
}

$gi = Read-Source 'templates/project-gitignore.template'
$gm = [regex]::Match($gi, '(?ms)^# ai-dos:begin\s*\n(.*?)\n# ai-dos:end')
if (-not $gm.Success) { throw 'templates/project-gitignore.template has no ai-dos block' }
Set-Block '.gitignore' $gm.Groups[1].Value 'hash' ''

# --------------------------------------------------------------------------
# Orphans, legacy adapters, reminders
# --------------------------------------------------------------------------

$scan = @(
    @{ Dir = '.cursor/rules'; Filter = '*.mdc'; Recurse = $false },
    @{ Dir = '.cursor/commands'; Filter = '*.md'; Recurse = $false },
    @{ Dir = '.agents/skills'; Filter = '*'; Recurse = $true },
    @{ Dir = '.claude/rules'; Filter = 'aidos-*.md'; Recurse = $false },
    @{ Dir = '.claude/commands'; Filter = 'aidos-*.md'; Recurse = $false },
    @{ Dir = '.github/instructions'; Filter = 'aidos-*.instructions.md'; Recurse = $false },
    @{ Dir = '.github/prompts'; Filter = 'aidos-*.prompt.md'; Recurse = $false }
)
foreach ($s in $scan) {
    $full = Get-ProjectPath $s.Dir
    if (-not (Test-Path -LiteralPath $full -PathType Container)) { continue }
    foreach ($f in (Get-ChildItem -LiteralPath $full -Filter $s.Filter -File -Force -Recurse:$s.Recurse)) {
        $rel = ($s.Dir + '/' + $f.FullName.Substring($full.Length + 1)) -replace '\\', '/'
        if ($expected.ContainsKey($rel)) { continue }
        if ((Read-TextFile $f.FullName).Text -match 'ai-dos:generated [^\n]*sha256=') {
            Add-Result 'removed_proposed' $rel 'generated by AI-DOS but no longer expected (source removed or skill disabled); delete manually after review'
        }
    }
}
$legacy = Get-ProjectPath '.cursor/skills'
if (Test-Path -LiteralPath $legacy -PathType Container) {
    foreach ($d in (Get-ChildItem -LiteralPath $legacy -Directory -Force | Where-Object { $_.Name -like 'aidos-*' })) {
        Add-Result 'removed_proposed' ".cursor/skills/$($d.Name)/" 'legacy adapter; Cursor now reads .agents/skills/ (duplicate skill); delete manually after review'
    }
}
if (-not (Test-Path -LiteralPath (Get-ProjectPath '.cursorignore') -PathType Leaf)) {
    Add-Result 'action' '.cursorignore' 'missing: copy .ai-dos/templates/cursorignore.template to .cursorignore yourself (agents and this script never create it)'
}
$agentsFull = Get-ProjectPath 'AGENTS.md'
if ((Test-Path -LiteralPath $agentsFull -PathType Leaf) -and (Get-Item -LiteralPath $agentsFull).Length -gt 32768) {
    Add-Result 'info' 'AGENTS.md' 'larger than 32 KiB: OpenAI Codex truncates project instructions at project_doc_max_bytes (default 32 KiB)'
}
$agentsSkeleton = Get-ProjectPath 'AGENTS.md'
if ((Test-Path -LiteralPath $agentsSkeleton -PathType Leaf) -and ((Read-TextFile $agentsSkeleton).Text -match '<project name>')) {
    Add-Result 'action' 'AGENTS.md' 'fill in the project section (outside the AI-DOS block); same for CLAUDE.md and .github/copilot-instructions.md'
}

# --------------------------------------------------------------------------
# Summary
# --------------------------------------------------------------------------

$order = @('conflict', 'action', 'removed_proposed', 'outdated', 'keep_local', 'created', 'inserted', 'updated', 'unchanged', 'info')
Write-Host ''
foreach ($st in $order) {
    foreach ($r in ($script:Results | Where-Object { $_.Status -eq $st })) {
        $line = '{0,-17} {1}' -f $r.Status, $r.Path
        if ($r.Note) { $line += "  - $($r.Note)" }
        if ($st -eq 'conflict') { Write-Host $line -ForegroundColor Red }
        elseif ($st -eq 'action' -or $st -eq 'removed_proposed' -or $st -eq 'outdated') { Write-Host $line -ForegroundColor Yellow }
        elseif ($st -eq 'unchanged') { Write-Verbose $line }
        else { Write-Host $line }
    }
}
$counts = foreach ($st in $order) { $n = @($script:Results | Where-Object { $_.Status -eq $st }).Count; if ($n) { "$st=$n" } }
Write-Host ''
Write-Host ('Summary: ' + ($counts -join ', '))
if ($script:DryRun) { Write-Host 'Dry run: no file was written; the statuses show what a real run would do.' }
$conflicts = @($script:Results | Where-Object { $_.Status -eq 'conflict' }).Count
if ($conflicts -gt 0) {
    Write-Host 'Conflicts were not touched. Resolve them (human decision, integration/update.md#conflict-mechanism) and run again.' -ForegroundColor Red
    exit 1
}
exit 0
