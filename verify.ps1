# ============================================================
# verify.ps1 - Script kiem tra ket qua Lab 5 (PowerShell)
# ============================================================

$global:pass = 0
$global:fail = 0
$global:total = 0

function Check-Item([string]$desc, [string]$status) {
    $global:total++
    Write-Host "[$global:total] $desc ... " -NoNewline
    if ($status -eq 'OK') {
        Write-Host "PASS" -ForegroundColor Green
        $global:pass++
    } else {
        Write-Host "FAIL: $status" -ForegroundColor Red
        $global:fail++
    }
}

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  VERIFY - Lab 5 Git Flow and Code Review" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

$name = git config user.name 2>$null
if ($name) { Check-Item "Git user.name configured: $name" 'OK' } else { Check-Item "Git user.name configured" 'Not configured' }

$email = git config user.email 2>$null
if ($email) { Check-Item "Git user.email configured: $email" 'OK' } else { Check-Item "Git user.email configured" 'Not configured' }

$gitDir = git rev-parse --git-dir 2>$null
if ($gitDir) { Check-Item "Current directory is a Git repository" 'OK' } else { Check-Item "Current directory is a Git repository" 'Not a git repo' }

$origin = git remote get-url origin 2>$null
if ($origin) { Check-Item "Remote origin: $origin" 'OK' } else { Check-Item "Remote origin configured" 'Not configured' }

$commitCount = git rev-list --count HEAD 2>$null
if ([int]$commitCount -ge 3) { Check-Item "Has >=3 commits ($commitCount total)" 'OK' } else { Check-Item "Has >=3 commits" 'Less than 3 commits' }

$branches = git branch -a 2>$null
if ($branches -match "develop") { Check-Item "Has 'develop' branch" 'OK' } else { Check-Item "Has 'develop' branch" 'Missing develop branch' }

$fb = @($branches | Where-Object { $_ -match "feature/" })
if ($fb.Count -ge 1) { Check-Item "Has >=1 feature branch(es) ($($fb.Count) found)" 'OK' } else { Check-Item "Has >=1 feature branch(es)" 'No feature branch found' }

if (Test-Path ".gitignore") { Check-Item ".gitignore exists" 'OK' } else { Check-Item ".gitignore exists" 'Missing .gitignore' }

if (Test-Path "README.md") {
    $lines = (Get-Content "README.md").Count
    if ($lines -ge 5) { Check-Item "README.md exists ($lines lines)" 'OK' } else { Check-Item "README.md exists" 'Less than 5 lines' }
} else { Check-Item "README.md exists" 'Missing README.md' }

if (Test-Path "src") { Check-Item "src/ directory exists" 'OK' } else { Check-Item "src/ directory exists" 'Missing src/ directory' }

$pyFiles = @(Get-ChildItem -Path "src" -Filter "*.py" -Recurse 2>$null)
if ($pyFiles.Count -ge 2) { Check-Item "Has >=2 Python files ($($pyFiles.Count) found)" 'OK' } else { Check-Item "Has >=2 Python files" 'Less than 2 py files' }

if (Test-Path "src/main.py") {
    $env:PYTHONUTF8 = '1'
    $env:PYTHONIOENCODING = 'utf-8'
    $out = python src/main.py 2>&1
    if ($out -match "STUDENT MANAGER") { Check-Item "src/main.py runs successfully" 'OK' } else { Check-Item "src/main.py runs successfully" "Error: $out" }
} else { Check-Item "src/main.py runs successfully" 'src/main.py not found' }

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
if ($global:fail -eq 0) {
    Write-Host "  RESULTS: $global:pass/$global:total PASS, $global:fail FAIL" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "All checks PASS! Git Flow lab completed successfully." -ForegroundColor Green
} else {
    Write-Host "  RESULTS: $global:pass/$global:total PASS, $global:fail FAIL" -ForegroundColor Red
    Write-Host "===============================================" -ForegroundColor Cyan
}
