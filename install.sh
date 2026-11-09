#!/usr/bin/env bash
# 사용법: bash install.sh [작업 폴더, 기본값 현재 폴더]
# 이미 있는 파일과 스킬 폴더는 덮어쓰지 않는다. 과제 README.md는 건드리지 않는다.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${1:-.}"
cd "$DEST"

if [ -e .agents/skills/env ] || [ -e .agents/skills/plan ] || [ -e .agents/skills/wrap ]; then
  echo "예선판 하네스가 설치된 폴더로 보입니다. 새 과제 폴더에 설치하세요."
fi

copy_if_absent() {
  if [ -e "$2" ]; then
    echo "건너뜀 (이미 있음): $2"
  else
    cp "$1" "$2"
    echo "설치: $2"
  fi
}

copy_if_absent "$SRC/AGENTS.md" AGENTS.md
copy_if_absent "$SRC/templates/REPORT.md" REPORT.md

mkdir -p docs orch/handoff
for f in "$SRC"/templates/docs/*.md; do
  copy_if_absent "$f" "docs/$(basename "$f")"
done
copy_if_absent "$SRC/templates/orch/_CARD.md" orch/_CARD.md
[ -e orch/handoff/.gitkeep ] || touch orch/handoff/.gitkeep

mkdir -p .agents/skills
for dir in "$SRC"/skills/*/; do
  name="$(basename "$dir")"
  if [ -e ".agents/skills/$name" ]; then
    echo "건너뜀 (이미 있음): .agents/skills/$name"
  else
    cp -r "$dir" ".agents/skills/$name"
    echo "설치: .agents/skills/$name"
  fi
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init -q
  echo "git 저장소를 만들었습니다 (git init)."
fi

# 임시 파일 폴더(work/)는 커밋하지 않는다.
if ! grep -qx 'work/' .gitignore 2>/dev/null; then
  echo 'work/' >> .gitignore
  echo "설치: .gitignore에 work/ 추가"
fi

echo
if [ -z "$(git config user.name || true)" ] || [ -z "$(git config user.email || true)" ]; then
  echo "git 사용자 설정이 비어 있습니다. 커밋 전에 셸에서 실행하세요:"
  echo '  git config user.name "이름"'
  echo '  git config user.email "이메일"'
  echo
fi
echo "완료. Codex를 다시 시작한 뒤 첫 터미널에서 \$main start 로 시작하세요."
echo "이미 있던 AGENTS.md를 건너뛰었다면, 두 파일을 비교해서 합치세요."
