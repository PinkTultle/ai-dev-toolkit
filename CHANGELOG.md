# Changelog

이 파일은 [Keep a Changelog](https://keepachangelog.com/) 형식을 따른다.
버전 정책은 [VERSIONING.md](VERSIONING.md)를 참조한다.

---

## [0.7.0] - 2026-11-17

**슬림화 — 개발 절차를 superpowers에 위임** ([ADR-002](docs/decisions/ADR-002-slim-down-delegate-process-to-superpowers.md)).
`adt`는 지침 라이브러리·프로젝트 배포 추적 등 고유 영역만 남긴다. Claude Code v2.1.326 사양 반영.

> **호환성 깨짐**: 에이전트 11개와 스킬 1개가 삭제됐다. `adt:designer` 등을 호출하던 흐름과
> `docs/artifacts/` 단계별 산출물 규칙은 더 이상 유효하지 않다. v0.x 기간이므로 Minor로 올린다.

### Removed
- 에이전트 11개 — `ideation`, `product-manager`, `designer`, `design-validator`, `reviewer`,
  `implementer`, `cto-lead`, `code-analyzer`, `verifier`, `tester`, `report-generator`.
  superpowers의 brainstorming / writing-plans / executing-plans / requesting-code-review 등이 대신한다
- `/adt:review` — 내장 `/code-review`, superpowers와 중복
- 템플릿 3개 — `plan`, `design`, `report` (삭제된 에이전트만 참조)
- `blueprints/design-principles.md`와 글로벌 rule `workflow.md`의 Small/Medium/Large 단계 프리셋,
  `docs/artifacts/` 단계별 산출물 디렉토리, 서브에이전트 파이프라인·에이전트 팀·품질 루프
- `docs/index.html` 소개 페이지
- 저장소 `CLAUDE.md` §4.8 (글로벌 규칙으로 승격)

### Changed
- `gap-detector` — 입력을 "전달받은 설계 문서 경로 → `docs/superpowers/specs/` 최신 문서 → 없으면
  경로 요청" 순으로 변경. 결과를 파일로 쓰지 않고 응답으로 돌려준다. `effort: high`
- 설계 우선 원칙 — 절차 자체는 전담 도구(superpowers, 없으면 기본 plan mode)에 맡기고,
  설계 문서 위치도 절차 도구가 정한 곳을 따른다
- `claude/project_CLAUDE.md` §7 — 설계 문서 위치를 고정하지 않음. archive 패턴을
  "완료된 작업의 설계서·계획서 보관"으로 단순화 (`{plan,design,analysis,report}.md` 구조·Match Rate 열 삭제)
- `/adt:project-update` §3.5 위생 검사 — (d) v0.7.0에서 제거된 파이프라인 참조 점검 추가
- `/adt:project-configure` §5 — 프리셋 분류 대신 "반드시 설계를 거칠 작업 유형"을 묻는다
- 기존 PDCA 산출물(`plugin-migration.*`)을 `docs/archive/2026-04/`로 이동
- 플러그인 설명 문구·키워드 — "10 스킬, blueprints 지식 체계, 프로젝트 배포·추적"

### Added
- 글로벌 규칙 — 다음 작업 제안이 있을 때만 응답 끝에 `💡 다음: <추천>` 한 줄
  (`blueprints/base-directives.md`, `.claude/rules/global-communication.md`)
- `blueprints/README.md` — 외부 플러그인·프로젝트에서 지식을 가져올 때의 규칙
  (필요가 생겼을 때만, 출처 표기, `paths` 스코프 필수)
- 플랫폼 blueprint 3종 + `global-platform.md` — v2.1.326 기준 갱신:
  - 서브에이전트: `omitClaudeMd`, `autoCompactWindow`, `experimental.cacheTtl`,
    `CLAUDE_CODE_SUBAGENT_EFFORT`, 플러그인 에이전트에서 무시되는 필드 4개. 세션당 200개 생성 상한 삭제
  - 스킬: `when_to_use`, `disallowed-tools`, `paths`, `shell`. 자동 호출 금지 스킬의 동작 변화,
    예약 작업·`/loop`에서의 확인 프롬프트
  - 훅: `PreModelSwitch`/`PostModelSwitch`, 공통 입력 필드, `last_assistant_message`, 출력 10,000자 상한,
    `onFailure`, `if` 제약, `${CLAUDE_PLUGIN_DATA}`
  - 메모리: `AGENTS.md` 조건부 로드, `/doctor prompt-audit`, 플러그인 루트 `CLAUDE.md` 미로드
- `LICENSE` (MIT), `plugin.json`의 `author` · `license`
- `docs/superpowers/` — 설계서와 구현 계획

### Fixed
- `hooks/hooks.json` — `${CLAUDE_PLUGIN_ROOT}`를 따옴표 없이 써서 설치 경로에 공백이 있으면
  훅 명령이 쪼개지던 문제 (`claude plugin validate` 경고)

### Note
- 설계 원칙으로 명시: `adt`는 프로젝트 디렉토리에 숨김 상태 폴더·상태 파일을 만들지 않는다
- `claude plugin validate . --strict`에 남는 항목은 루트 `CLAUDE.md` 경고(저장소 작업용 규칙이라 유지)와
  디렉토리 등재용 `ICON_MISSING`뿐이다
- 배포 프로젝트 3개와 다른 워크스테이션에는 아직 전파하지 않았다

---

## [0.6.0] - 2026-07-26

v0.5.0 배포 프로젝트 전파 과정에서 드러난 **배포 스킬의 구조적 결함**을 수정.
"배포했다는 기록"과 "실제 저장소 상태"가 어긋나던 원인 3가지를 제거.

### Added
- `/adt:project-configure` — **커스터마이즈 검증** 단계. rules 배포 직후
  `{{MUST-CUSTOMIZE}}` / 미치환 placeholder / 템플릿 헤더 잔존 / CLAUDE.md↔rules 충돌을
  검사하고, 해소 전에는 완료로 보지 않는다
- `/adt:project-update` — **§3.5 위생 검사** 단계. 플러그인 로컬 복제본, 미커스터마이즈 마커,
  `.bak` 잔존, CLAUDE.md↔rules 충돌을 버전 diff와 별개로 점검
- `/adt:project-update` — **§6 커밋 단계**. 변경을 미커밋 상태로 남긴 채 종료하지 않는다.
  push는 대상 저장소의 브랜치 규칙을 읽고 별도 확인

### Changed
- `.claude/rules/project-git-workflow.md` — 브랜치 전략 블록에 `{{MUST-CUSTOMIZE}}` 마커 추가.
  기존에는 의견이 담긴 기본값(`develop` 통합 브랜치, main 직접 push 금지)이 평문으로 배포되어,
  커스터마이즈가 누락돼도 티가 나지 않았다. CLAUDE.md 우선 원칙도 명시
- `/adt:project-update` — 백업 정책 변경. **git 저장소에서는 `.bak`을 만들지 않는다**
  (git이 백업을 담당). 이전 정책이 배포 프로젝트에 `.bak` 잔존물을 남겼다
- `/adt:project-update` — `skills/project-configure/` 복제본 갱신 항목 삭제.
  v0.4.0 플러그인 전환 이후 프로젝트에 스킬 복제본을 두지 않는다

### Note
- 배포 프로젝트 2곳(NDT-BPE_pork `c868871`, mr-noti-bot `526818c`)의
  `rules/git-workflow.md`를 각 CLAUDE.md의 실제 브랜치 구조에 맞게 정정 — 두 파일이 모두
  항상 로드되는데 브랜치 전략이 서로 모순이었다 (존재하지 않는 `develop` 참조 포함)

---

## [0.5.0] - 2026-07-26

Claude Code v2.1.79 → **v2.1.220** 3개월치 런타임 변화 반영. 동작하지 않던 훅과 스펙을 위반하던
에이전트 정의를 수정하고, 플랫폼 계층 지식(에이전트 실행 모델 · 메모리 · 훅)을 blueprint로 신설.

### Fixed
- **`hooks/post-edit-check.sh` — 훅이 무동작이던 문제**: `$CLAUDE_FILE_PATH` 환경변수는 존재하지
  않는다. 훅은 stdin JSON(`.tool_input.file_path`)으로 입력을 받는다. v0.4.0 도입 이후 200줄
  검사가 한 번도 실행되지 않았음. `jq` 미설치 환경 fallback 및 `docs/` 제외 규칙도 함께 추가
- **에이전트 `name` 스펙 위반 12건**: `Code Analyzer Agent` → `code-analyzer` 형태로 전면 교체.
  `name`은 소문자와 하이픈만 허용되며, `Agent(<name>)` 권한 규칙과 `SubagentStart` 훅의
  `agent_type`이 이 값을 사용한다

### Added
- `blueprints/agent-runtime.md` — 서브에이전트/스킬 프론트매터 전체 필드, 백그라운드 실행 모델,
  `/subtask`↔`/fork`, 중첩·동시성 상한, 모델·effort 선택 기준
- `blueprints/memory-and-context.md` — 지침 계층(CLAUDE.md · rules · 스킬 · 훅) 배치 결정,
  `paths` 스코프 규칙, auto memory(`~/.claude/projects/<project>/memory/`) 운용 규칙
- `blueprints/hooks.md` — 훅 이벤트 목록, stdin JSON 입출력 계약, `matcher`/`if` 대상 좁히기,
  작성·검증 규칙
- `.claude/rules/global-platform.md` → `~/.claude/rules/platform.md` — 위 3개 blueprint의 요약본
- `TOOL_REFERENCE.md` — Agent Skills 오픈 표준 절. 이식 가능한 핵심 필드와 Claude Code 확장 필드 구분

### Changed
- 에이전트 12개에 `color` 추가, 설계/검토/검증/구현 4종에 `effort: high` 지정
- `implementer`에 `isolation: worktree` 실제 적용 — 그간 문서에만 "worktree 격리"라 기재되어 있었음
- 파괴적·수동 실행 스킬 7개(`ai-platform-defconfig`, `project-init`, `project-configure`,
  `project-update`, `project-absorb`, `handoff`, `optimize-docs`)에 
  `disable-model-invocation: true` — AI 자동 호출 차단, `/adt:<name>` 수동 호출만 허용
- `hooks.json` — `if: "Edit(**/*.md)"`로 대상 축소
- `blueprints/design-principles.md` §3 — 에이전트명 실물 반영, effort 열 추가, 백그라운드 실행
  게이트 규칙 추가
- `blueprints/environment.md` — git worktree 기본 위치(`.claude/worktrees/`) 규칙 추가
- 최소 요구 버전 `>=2.1.78` → `>=2.1.202` (v2.1.220 검증)
- `workstations/registry.md` — 워크스테이션 3개 전체 반영, `web_hook_server` 상태 정정

### Note
- 배포 프로젝트 3개(NDT-BPE_pork, aralm_program, mr-noti-bot)에는 아직 전파하지 않음 —
  `/adt:project-update`로 별도 진행
- 플랫폼 계층 blueprint 3개는 런타임 동작에 의존한다. 각 파일 상단의 검증 버전을 확인하고
  Claude Code 업그레이드 시 함께 갱신할 것

---

## [0.4.2] - 2026-04-19

배포 프로젝트 3개(NDT-BPE_pork, aralm_program, mr-noti-bot) v0.4.1 업데이트 + 프로젝트에서 발전한 지침 3건을 라이브러리로 흡수.

### Added
- `blueprints/base-directives.md` §3 "지식 축적 규칙" — AI가 `docs/stack/`, `.claude/rules/`, CLAUDE.md 프로젝트 규칙 섹션 등에 임의로 내용을 추가하지 않고 사용자 합의 내용만 기록 (출처: aralm_program)
- `claude/project_CLAUDE.md` §7 `docs/archive/YYYY-MM/<feature>/` + `_INDEX.md` 월별 아카이브 패턴 — feature 완료 후 PDCA 산출물을 월별로 보관 (출처: mr-noti-bot)
- `claude/project_CLAUDE.md` §4.1 다언어 프로젝트용 네이밍 컨벤션 표 예시 주석 (출처: aralm_program)
- 본 저장소 `CLAUDE.md` §4.8 응답 말미 규칙 — rkit Feature Usage 리포트 생략, `💡 다음: <추천>` 한 줄만 유지

### Changed
- `.claude/rules/global-communication.md` — 지식 축적 규칙 동기화
- 배포 프로젝트 3건(NDT-BPE_pork, aralm_program, mr-noti-bot)을 v0.4.1로 갱신 (CLAUDE.md 헤더 + rules 네임스페이스 `/adt:` 통일)
- `workstations/registry.md` 현황 반영

### Note
- 배포 프로젝트 업데이트는 CLAUDE.md 헤더 버전과 rules 네임스페이스만 갱신 — 본문 템플릿 확장은 기존 커스텀 보존을 위해 강제 반영하지 않음

---

## [0.4.1] - 2026-04-12

v0.4.0 플러그인 전환 후 잔여 정리. 모든 문서/템플릿의 스킬 호출 참조를 `/adt:` 네임스페이스로 통일.

### Changed
- 19개 파일의 구식 스킬 호출(`/project-init` 등) → `/adt:project-init` 등으로 갱신
- 사용자 대면 docs, 템플릿, 스킬 간 교차 참조, rules, 훅 경고 메시지, 참조 문서 전체 일관성 확보

### Note
- 플러그인 content 변경 시 버전 증가 필수 — `claude plugin update`는 version 변경이 있을 때만 실제로 재다운로드

---

## [0.4.0] - 2026-04-12

Claude Code 플러그인(`adt`)으로 전환. 스킬/에이전트/훅을 플러그인 구조로 재배치.

### Added
- **`.claude-plugin/`**: `plugin.json`, `marketplace.json` — 플러그인 매니페스트
- **`package.json`**: NPM 메타데이터
- **`hooks/hooks.json`**: 플러그인 훅 정의 (PostToolUse 줄 수 검사)
- **커맨드→스킬 변환 5개**: handoff, sync-check, doc-gen, review, decision

### Changed
- **`skills/`**: `.claude/skills/` → 최상위 `skills/`로 이전 (11개)
- **`agents/`**: `.claude/agents/` → 최상위 `agents/`로 이전 (12개)
- **`templates/`**: `.claude/templates/` → 최상위 `templates/`로 이전 (4개)
- **경로 참조**: `CLAUDE_SKILL_DIR` → `CLAUDE_PLUGIN_ROOT`, `.claude/templates/` → `templates/`
- **VERSION**: 0.3.0 → 0.4.0

### Removed
- `.claude/skills/`, `.claude/agents/`, `.claude/commands/`, `.claude/templates/`, `.claude/hooks/`
- `.claude/settings.json` (훅은 `hooks/hooks.json`으로 이전)

### Kept (변경 없음)
- `.claude/rules/` — 이 프로젝트 자체의 규칙 (플러그인 범위 밖)
- `blueprints/`, `claude/`, `workstations/`, `docs/`

---

## [0.3.0] - 2026-04-10

에이전트 파이프라인 확장, 문서 템플릿 도입, 자동화 강화.
rkit 패턴 분석을 통한 프로젝트 구조 성숙화.

### Added
- **에이전트 11개 체계**: 기존 파이프라인 6개 + 유틸리티 5개 (product-manager, gap-detector, code-analyzer, design-validator, report-generator, cto-lead)
- **`.claude/templates/`**: Plan, Design, Report, ADR 문서 템플릿 4종 — 에이전트가 참조하여 일관된 산출물 생성
- **`.claude/commands/`**: handoff, sync-check, doc-gen, review, decision 커맨드 5종
- **`.claude/hooks/`**: PostToolUse Hook — 지침 파일 200줄 초과 자동 경고
- **`.claude/settings.json`**: 팀 공유 설정 — deny 목록 + Hook 정의
- **`docs/decisions/`**: ADR(Architecture Decision Records) 시스템 도입
- **`.github/workflows/claude.yml`**: @claude PR 자동화 워크플로우
- **`.claude/rules/`**: 글로벌 4개 + 프로젝트 3개 세부 규칙 파일 (#3)
- **게이트 모델 전략**: design-validator, gap-detector를 opus로 승격 (오판 방지)

### Changed
- 에이전트 산출물 형식: 인라인 마크다운 → **템플릿 참조** 방식으로 전환
- reviewer: 판정 기준표 + 템플릿 준수 체크 추가
- implementer: 자기 검증 단계 추가
- tester: PASS/PARTIAL/FAIL 판정 기준 명확화
- `global_CLAUDE.md`: 경량화 (143줄 → 41줄 인덱스)
- `settings.local.json`: 일회성 허용 정리 (69→18 패턴) + deny 9개
- `~/.claude/settings.json`: 글로벌 권한 정리 + deny 배포
- `~/.bashrc`: AGENT_TEAMS + SUBPROCESS_ENV_SCRUB 환경변수

---

## [0.2.0] - 2026-03-26

Windows 네이티브(Git Bash/MINGW64) 환경 지원 추가.

### Added
- **Windows 네이티브 지원**: MINGW64(Git Bash) 환경에서 전 스킬 동작 검증 완료
- **`.gitattributes`**: `eol=lf` 강제로 Windows CRLF 혼입 방지
- **`pink-turtle-win` 워크스테이션**: Windows 환경 상태 파일 추가
- **`blueprints/environment.md`**: Windows(MINGW64) 환경 섹션 추가

### Changed
- 저장소명 `My_AI_manual` → `ai-dev-toolkit`으로 통일
- 스킬/문서 내 경로 참조를 새 저장소명으로 갱신
- `workstations/README.md` 경로 기록 규칙에 Windows 환경 고려 추가

---

## [0.1.0] - 2026-03-23

첫 번째 릴리스. 스킬 기반 AI 플랫폼 도구 구조 확립.

### Added
- **스킬 4개**: `ai-platform-defconfig`, `project-init`, `project-configure`, `optimize-docs`
- **blueprints/**: 도구 무관 공유 지식 (coding-standards, git-workflow, build-environment, design-principles, base-directives, environment)
- **개발 워크플로우 6단계**: 아이디어 구체화 → 설계 → 설계검토 → 구현 → 검증 → 테스트
- **작업 유형별 프리셋**: Small / Medium / Large
- **서브에이전트 파이프라인**: 단계별 서브에이전트 실행, 산출물 기반 참조, 사용자 확인 게이트
- **산출물 관리**: `docs/artifacts/` 하위 단계별 디렉토리, 번호.작업명 네이밍
- **project-configure 1문 1답 대화형 수집**
- **워크스테이션 상태 관리**: `workstations/` 디렉토리, JSON 상태 파일
- **배포 추적**: `registry.md`, `<alias>.deploy.json`
- **버전 정책**: SemVer + Local 4자리 체계, VERSIONING.md

### Changed
- `_shared/` → `blueprints/` 리네이밍
- `design-principles.md` 전면 재구성 (6단계 워크플로우, 산출물 관리, 서브에이전트)
- `global_CLAUDE.md` 3절 동기화
- `project_CLAUDE.md` 템플릿 placeholder 방식으로 재설계
