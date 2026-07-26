#!/bin/bash
# PostToolUse Hook: 지침 파일 수정 후 줄 수 검사
# 200줄 초과 시 경고 출력 (non-blocking — exit 0)
#
# 훅은 stdin으로 JSON을 받는다. 파일 경로는 .tool_input.file_path.
# ($CLAUDE_FILE_PATH 환경변수는 존재하지 않는다 — v0.4.x까지 이 훅이 무동작이었던 원인)

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
else
  # jq 미설치 환경 fallback — "file_path": "..." 첫 매치 추출
  FILE=$(printf '%s' "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi

[ -z "$FILE" ] && exit 0
[ ! -f "$FILE" ] && exit 0

# 지침 파일만 검사 (SKILL.md, blueprints/, CLAUDE.md, rules/)
# docs/ 하위는 줄 수 제한 대상이 아니다 (CLAUDE.md §2.5)
case "$FILE" in
  */docs/*) exit 0 ;;
esac

case "$FILE" in
  */SKILL.md|*/blueprints/*.md|*/CLAUDE.md|*/.claude/rules/*.md)
    LINES=$(wc -l < "$FILE")
    if [ "$LINES" -gt 200 ]; then
      echo "[warn] $FILE: ${LINES}줄 — 200줄 제한 초과. /adt:optimize-docs 실행 권장"
    fi
    ;;
esac

exit 0
