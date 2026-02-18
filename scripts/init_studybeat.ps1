#!/usr/bin/env pwsh
# init_studybeat.ps1
# Creates a feature-based folder structure for the StudyBeat mobile app (PowerShell version)

Set-StrictMode -Version Latest

Write-Output "Creating StudyBeat folder structure..."

$BaseDir = (Get-Location).Path

$dirs = @(
    "core",
    "features/welcome",
    "features/dashboard",
    "features/exams",
    "features/timer",
    "services",
    "models"
)

foreach ($d in $dirs) {
    $full = Join-Path $BaseDir $d
    New-Item -ItemType Directory -Path $full -Force | Out-Null
    Write-Output "Created directory: $d"
}

$files = @{
    'features/welcome/Welcome.md' = "# Welcome`n`nPlaceholder file for the Welcome screen."
    'features/dashboard/Dashboard.md' = "# Dashboard`n`nPlaceholder file for the Dashboard screen."
    'features/exams/ExamsList.md' = "# Exams List`n`nPlaceholder file for the Exams List screen."
    'features/exams/ExamDetails.md' = "# Exam Details`n`nPlaceholder file for the Exam Details screen."
    'features/exams/AddNewExam.md' = "# Add New Exam`n`nPlaceholder file for the Add New Exam screen."
    'features/timer/TimerSelectTopic.md' = "# Timer (Select Topic)`n`nPlaceholder file for the Timer select-topic screen."
    'features/timer/ActiveTimer.md' = "# Active Timer`n`nPlaceholder file for the Active Timer screen."
}

foreach ($relPath in $files.Keys) {
    $target = Join-Path $BaseDir $relPath
    $dir = Split-Path $target -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if (Test-Path $target) {
        Write-Output "Skipped (exists): $relPath"
    } else {
        $content = $files[$relPath]
        $content | Out-File -FilePath $target -Encoding UTF8
        Write-Output "Created file: $relPath"
    }
}

Write-Output "StudyBeat scaffold creation complete."
Write-Output "To run (PowerShell): ./scripts/init_studybeat.ps1"

Exit 0
