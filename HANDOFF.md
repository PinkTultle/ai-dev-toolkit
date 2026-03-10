# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-03-10
**작업 내용**: `_shared/` 계층 분리 완료 및 global_CLAUDE.md 배포 구조 확정

### 완료된 작업

1. `global_CLAUDE.md`에서 `_shared/`로 공통 지식 분리:
   - `_shared/environment.md` — 환경 감지 및 적응 (WSL2, SSH)
   - `_shared/design-principles.md` — 설계 우선 원칙
   - `_shared/base-directives.md` — AI 공통 기본 지침 (응답 언어, 커뮤니케이션)

2. `global_CLAUDE.md` 배포 구조 확정:
   - `_shared/`가 Single Source of Truth (원본)
   - `global_CLAUDE.md`는 1~3절 내용을 인라인 포함하는 배포판
   - 4절(기술 표준: coding-standards, git-workflow, build-environment)은 도메인별 참조 방식 유지
   - 각 절 상단에 `> 원본: _shared/xxx.md` 표기로 수정 흐름 안내

3. `_shared/` 계획 파일 전체 작성 완료:
   - `base-directives.md` ✅
   - `environment.md` ✅
   - `design-principles.md` ✅
   - `coding-standards.md` ✅ (이전 세션)
   - `git-workflow.md` ✅ (이전 세션)
   - `build-environment.md` ✅ (이전 세션)

### 현재 상태

- **`_shared/` 계층 1**: 모든 계획 파일 작성 완료
- **`claude/` 계층 2**: `global_CLAUDE.md`, `project_CLAUDE.md` 완성
- **`cursor/`, `copilot/`, `windsurf/`**: README placeholder만 존재 — 지침 파일 미작성

### 다음 작업 후보

1. **다른 도구 지침 작성** — `_shared/` 내용을 각 도구 형식으로 변환:
   - `cursor/`: MDC 형식 (.mdc) 규칙 파일
   - `copilot/`: copilot-instructions.md 및 경로별 지침
   - `windsurf/`: 글로벌 규칙 및 프로젝트 템플릿

2. **동기화 스크립트** — `_shared/` 원본 수정 시 `global_CLAUDE.md` 자동 동기화

3. **`global_CLAUDE.md` 내용 보강** — 실제 프로젝트 사용 피드백 반영

---

## 워크스테이션 환경 메모

| 워크스테이션 | 환경 | 심볼릭 링크 상태 |
|-------------|------|-----------------|
| (기록 필요) | WSL2 | `~/.claude/CLAUDE.md` → `~/My_AI_manual/claude/global_CLAUDE.md` |

> 새 워크스테이션에서 클론 후 심볼릭 링크 설정:
> ```bash
> ln -sf ~/My_AI_manual/claude/global_CLAUDE.md ~/.claude/CLAUDE.md
> ```
