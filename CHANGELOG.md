# Changelog

이 파일은 [Keep a Changelog](https://keepachangelog.com/) 형식을 따른다.
버전 정책은 [VERSIONING.md](VERSIONING.md)를 참조한다.

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
