# Claude Code 글로벌 규칙 매뉴얼
> 모든 환경(Windows, WSL2, SSH 원격 서버)에서 일괄 적용되는 규칙입니다.
> 위치: `~/.claude/CLAUDE.md` (심볼릭 링크 — `/adt:ai-platform-defconfig`가 관리)
>
> **세부 규칙**: `~/.claude/rules/` 디렉토리의 개별 파일로 자동 로드됩니다.
> rules가 배포되지 않은 환경에서는 `~/ai-dev-toolkit/blueprints/`를 직접 참조하세요.

---

## 자동 로드 규칙 (rules/)

세부 규칙은 `~/.claude/rules/` 파일로 분산되어 자동 로드된다.
원본은 `ai-dev-toolkit/.claude/rules/` 디렉토리에 있다.

| 규칙 파일 | 역할 | 로드 조건 |
|-----------|------|----------|
| `rules/environment.md` | 환경 감지 및 적응 (Win/WSL2/SSH) | 항상 |
| `rules/communication.md` | 응답 언어, 커뮤니케이션 | 항상 |
| `rules/workflow.md` | 개발 단계 워크플로우, 산출물 관리 | 항상 |
| `rules/code-review.md` | 코드 리뷰 체크리스트 | C/C++ 파일 |

---

## 기술 표준 참조

도메인별 기술 지식은 프로젝트에 따라 선택적으로 적용한다.
해당 프로젝트의 기술 스택에 맞는 지침은 `~/ai-dev-toolkit/blueprints/` 디렉토리를 참조한다.

| 주제 | 참조 파일 |
|------|-----------|
| C/C++ 코딩 표준 | `blueprints/coding-standards.md` |
| Git 워크플로우 | `blueprints/git-workflow.md` |
| 임베디드 빌드 환경 | `blueprints/build-environment.md` |

도구에 종속되지 않는 범용 기술 지식(언어 표준, 아키텍처 패턴 등)은 blueprint에 바로 작성한다.
상세 기준과 절차는 `blueprints/README.md`의 "새 blueprint 추가" 참조.

---

*이 파일은 `~/.claude/CLAUDE.md`에 위치하며, 모든 프로젝트에 전역 적용됩니다.*
*프로젝트별 세부 규칙은 각 프로젝트 루트의 `CLAUDE.md`에서 오버라이드합니다.*
