# AI 도구별 설정 파일 레퍼런스

각 도구의 소스 파일(이 저장소)과 실제 배포 위치를 매핑한다.

---

## Claude Code

| 소스 파일 | 배포 위치 | 용도 |
|-----------|-----------|------|
| `claude/global_CLAUDE.md` | `~/.claude/CLAUDE.md` | 글로벌 규칙 인덱스 |
| `.claude/rules/global-*.md` | `~/.claude/rules/*.md` | 글로벌 세부 규칙 (자동 로드) |
| `claude/project_CLAUDE.md` | `<project-root>/CLAUDE.md` | 프로젝트별 규칙 템플릿 |
| `.claude/rules/project-*.md` | `<project>/.claude/rules/*.md` | 프로젝트 세부 규칙 (선택 복제) |
| `.claude/skills/` | (이 저장소 내 직접 사용) | 플랫폼 스킬 |

**배포 방법:**
| 대상 | 스킬 | 수동 |
|------|------|------|
| 글로벌 규칙 | `/adt:ai-platform-defconfig` | 심볼릭 링크 생성 |
| 글로벌 rules | `/adt:ai-platform-defconfig` | `ln -sf .claude/rules/global-*.md ~/.claude/rules/` (접두사 제거) |
| 프로젝트 규칙 | `/adt:project-init <path>` | `cp claude/project_CLAUDE.md <project-root>/CLAUDE.md` |
| 프로젝트 rules | `/adt:project-configure` | 기술 스택에 맞는 파일만 복제 |
| 프로젝트 구체화 | `/adt:project-configure` | `{{...}}` placeholder를 대화형으로 채움 |

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
| 글로벌 설정 | `~/.claude/CLAUDE.md` + `rules/` | Settings UI | - | `~/.windsurf/rules/` |
| 프로젝트 설정 | `CLAUDE.md` + `.claude/rules/` | `.cursor/rules/` | `.github/` | `.windsurf/rules/` |
| 파일 형식 | Markdown | MDC | Markdown | Markdown |
| 다중 파일 | 다중 (`CLAUDE.md` + `rules/`) | 다중 | 다중 | 다중 |
| 스킬 (`SKILL.md`) | 네이티브 + 확장 필드 | 지원 | 지원 | 지원 |
| 훅 / 서브에이전트 | 지원 | 부분 | - | - |

---

## Agent Skills 오픈 표준

`SKILL.md`(디렉토리 + YAML frontmatter + 마크다운 본문)는 **도구 중립 오픈 표준**이다.
Claude Code 외에도 Cursor, Gemini CLI, Kiro, Goose, Junie 등 다수 도구가 같은 파일을 읽는다.

- **이식 가능한 핵심**: `name`, `description`, 본문, 참조 파일
- **Claude Code 확장 필드**: `disable-model-invocation`, `user-invocable`, `context: fork`,
  `agent`, `background`, `model`, `effort` — 다른 도구에서는 무시된다

> 스킬을 작성할 때 **핵심 절차는 표준 필드와 본문으로** 표현하고, 확장 필드는 호출 제어 등
> 부가 동작에만 쓴다. 그러면 같은 스킬이 다른 도구에서도 열화 없이 동작한다.
> 필드 상세: `blueprints/agent-runtime.md` 4절.
