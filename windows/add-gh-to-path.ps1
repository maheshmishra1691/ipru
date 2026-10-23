$bin = Join-Path $env:USERPROFILE "GitHubTools\gh\bin"
$gh = Join-Path $bin "gh.exe"
if (-not (Test-Path -LiteralPath $gh)) {
    Write-Error "gh.exe was not found at $gh"
    exit 1
}

$old = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $old) { $old = "" }
if ($old -notlike "*GitHubTools\gh\bin*") {
    if ($old.Trim().Length -gt 0) { $new = "$old;$bin" } else { $new = $bin }
    [Environment]::SetEnvironmentVariable("Path", $new, "User")
    Write-Host "Added $bin to your user PATH."
} else {
    Write-Host "User PATH already includes gh."
}

$exportLine = 'export PATH="$PATH:$HOME/GitHubTools/gh/bin"'
$bashrc = Join-Path $env:USERPROFILE ".bashrc"
$profile = Join-Path $env:USERPROFILE ".bash_profile"
if (-not (Test-Path -LiteralPath $bashrc) -or -not (Select-String -LiteralPath $bashrc -SimpleMatch "GitHubTools/gh/bin" -Quiet)) {
    Add-Content -LiteralPath $bashrc -Value $exportLine
    Write-Host "Updated $bashrc"
}
$sourceLine = "test -f ~/.bashrc && . ~/.bashrc"
if (-not (Test-Path -LiteralPath $profile)) {
    Set-Content -LiteralPath $profile -Value $sourceLine
    Write-Host "Created $profile"
} elseif (-not (Select-String -LiteralPath $profile -SimpleMatch ".bashrc" -Quiet)) {
    Add-Content -LiteralPath $profile -Value $sourceLine
    Write-Host "Updated $profile"
}

& $gh --version
exit $LASTEXITCODE
