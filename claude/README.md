# Claude Code 지침

## 파일 목록

| 파일 | 배포 위치 | 설명 |
|------|-----------|------|
| `global_CLAUDE.md` | `~/.claude/CLAUDE.md` | 모든 프로젝트에 적용되는 글로벌 규칙 |
| `project_CLAUDE.md` | `<project-root>/CLAUDE.md` | 프로젝트별 규칙 템플릿 (placeholder 채워서 사용) |

## 배포 방법

### 글로벌 규칙
```bash
# 심볼릭 링크 (권장 — 원본 수정 시 자동 반영)
ln -sf ~/My_AI_manual/claude/global_CLAUDE.md ~/.claude/CLAUDE.md

# 또는 복사
cp ~/My_AI_manual/claude/global_CLAUDE.md ~/.claude/CLAUDE.md
```

### 프로젝트 규칙
```bash
# 새 프로젝트에 템플릿 복사 후 placeholder 수정
cp ~/My_AI_manual/claude/project_CLAUDE.md <project-root>/CLAUDE.md
```

## 우선순위

프로젝트 `CLAUDE.md`가 글로벌 `CLAUDE.md`를 상속하며, 충돌 시 프로젝트 규칙이 우선한다.
