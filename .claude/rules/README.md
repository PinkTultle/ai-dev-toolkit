# Claude Code Rules

Claude Code의 `.claude/rules/` 기능을 활용한 세분화된 규칙 파일.
`paths` frontmatter로 특정 파일 작업 시에만 조건부 로드할 수 있다.

---

## 글로벌 rules (`/adt:ai-platform-defconfig`이 `~/.claude/rules/`에 배포)

| 소스 파일 | 배포 파일명 | 원본 blueprint | 로드 조건 |
|-----------|------------|----------------|----------|
| `global-environment.md` | `environment.md` | `environment.md` | 항상 |
| `global-communication.md` | `communication.md` | `base-directives.md` | 항상 |
| `global-workflow.md` | `workflow.md` | `design-principles.md` | 항상 |
| `global-code-review.md` | `code-review.md` | (자체) | C/C++ 파일 |

## 프로젝트 rules 템플릿 (`/adt:project-configure`가 `<project>/.claude/rules/`에 선택 복제)

| 소스 파일 | 배포 파일명 | 원본 blueprint | 로드 조건 |
|-----------|------------|----------------|----------|
| `project-coding-standards.md` | `coding-standards.md` | `coding-standards.md` | C/C++ 파일 |
| `project-git-workflow.md` | `git-workflow.md` | `git-workflow.md` | 항상 |
| `project-build-environment.md` | `build-environment.md` | `build-environment.md` | 빌드 파일 |

## 배포

- **글로벌**: `/adt:ai-platform-defconfig` → 파일 단위 심볼릭 링크 (`global-` 접두사 제거)
- **프로젝트**: `/adt:project-configure` → 기술 스택에 맞는 파일만 복제 (`project-` 접두사 제거)
- **수동 글로벌**: `ln -sf $(pwd)/claude/rules/global-*.md ~/.claude/rules/` (접두사 수동 제거)

## blueprints와의 관계

blueprints는 **도구 무관 원본**(Single Source of Truth)이고, 이 rules 파일은 **Claude Code 전용 파생물**이다.
각 rules 파일에 원본 blueprint 출처가 명시되어 있다.
blueprints 수정 시 해당 rules 파일도 동기화해야 한다.
