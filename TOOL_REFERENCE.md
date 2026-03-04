# AI 도구별 설정 파일 레퍼런스

각 도구의 소스 파일(이 저장소)과 실제 배포 위치를 매핑한다.

---

## Claude Code

| 소스 파일 | 배포 위치 | 용도 |
|-----------|-----------|------|
| `claude/global_CLAUDE.md` | `~/.claude/CLAUDE.md` | 글로벌 규칙 (모든 프로젝트 공통) |
| `claude/project_CLAUDE.md` | `<project-root>/CLAUDE.md` | 프로젝트별 규칙 템플릿 |

**배포 방법:**
```bash
cp claude/global_CLAUDE.md ~/.claude/CLAUDE.md
cp claude/project_CLAUDE.md <project-root>/CLAUDE.md
```

---

## Cursor

| 소스 파일 | 배포 위치 | 용도 |
|-----------|-----------|------|
| `cursor/*.mdc` | `<project>/.cursor/rules/` | 프로젝트 규칙 (권장) |
| `cursor/.cursorrules` | `<project>/.cursorrules` | 단일 파일 규칙 (레거시) |

**설정 형식:** MDC (Markdown with frontmatter)
**글로벌 설정:** Cursor Settings > Rules 에서 직접 입력

---

## GitHub Copilot

| 소스 파일 | 배포 위치 | 용도 |
|-----------|-----------|------|
| `copilot/copilot-instructions.md` | `<project>/.github/copilot-instructions.md` | 저장소 전체 지침 |
| `copilot/instructions/*.instructions.md` | `<project>/.github/instructions/` | 경로별 지침 |

**설정 형식:** Markdown (glob 패턴 frontmatter 지원)

---

## Windsurf

| 소스 파일 | 배포 위치 | 용도 |
|-----------|-----------|------|
| `windsurf/global_rules.md` | `~/.windsurf/rules/global_rules.md` | 글로벌 규칙 |
| `windsurf/*.md` | `<project>/.windsurf/rules/` | 프로젝트 규칙 |
| `windsurf/.windsurfrules` | `<project>/.windsurfrules` | 단일 파일 규칙 (대안) |

**설정 형식:** Markdown (파일당 12,000자 제한)

---

## 도구 비교 요약

| 항목 | Claude Code | Cursor | Copilot | Windsurf |
|------|-------------|--------|---------|----------|
| 글로벌 설정 | `~/.claude/CLAUDE.md` | Settings UI | - | `~/.windsurf/rules/` |
| 프로젝트 설정 | `CLAUDE.md` | `.cursor/rules/` | `.github/` | `.windsurf/rules/` |
| 파일 형식 | Markdown | MDC | Markdown | Markdown |
| 다중 파일 | 단일 | 다중 | 다중 | 다중 |
