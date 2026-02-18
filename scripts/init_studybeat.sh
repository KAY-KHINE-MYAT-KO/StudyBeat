#!/usr/bin/env bash
set -euo pipefail

# init_studybeat.sh
# Creates a feature-based folder structure for the StudyBeat mobile app

echo "Creating StudyBeat folder structure..."

BASE_DIR="$(pwd)"

dirs=(
  "core"
  "features/welcome"
  "features/dashboard"
  "features/exams"
  "features/timer"
  "services"
  "models"
)

for d in "${dirs[@]}"; do
  mkdir -p "$BASE_DIR/$d"
  echo "Created directory: $d"
done

file_paths=(
  "features/welcome/Welcome.md"
  "features/dashboard/Dashboard.md"
  "features/exams/ExamsList.md"
  "features/exams/ExamDetails.md"
  "features/exams/AddNewExam.md"
  "features/timer/TimerSelectTopic.md"
  "features/timer/ActiveTimer.md"
)

file_contents=(
  $'# Welcome\n\nPlaceholder file for the Welcome screen.'
  $'# Dashboard\n\nPlaceholder file for the Dashboard screen.'
  $'# Exams List\n\nPlaceholder file for the Exams List screen.'
  $'# Exam Details\n\nPlaceholder file for the Exam Details screen.'
  $'# Add New Exam\n\nPlaceholder file for the Add New Exam screen.'
  $'# Timer (Select Topic)\n\nPlaceholder file for the Timer select-topic screen.'
  $'# Active Timer\n\nPlaceholder file for the Active Timer screen.'
)

# create files by index to remain compatible with older bash on macOS
for i in "${!file_paths[@]}"; do
  path="${file_paths[$i]}"
  content="${file_contents[$i]}"
  target="$BASE_DIR/$path"
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ]; then
    echo "Skipped (exists): $path"
  else
    printf "%s\n" "$content" > "$target"
    echo "Created file: $path"
  fi
done

echo "StudyBeat scaffold creation complete."
echo "To make the script executable: chmod +x \"scripts/init_studybeat.sh\""
echo "Then run it: ./scripts/init_studybeat.sh"

exit 0
