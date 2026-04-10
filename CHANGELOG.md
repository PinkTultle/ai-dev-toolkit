# Changelog

이 파일은 [Keep a Changelog](https://keepachangelog.com/) 형식을 따른다.
버전 정책은 [VERSIONING.md](VERSIONING.md)를 참조한다.

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
