# 배포 레지스트리

> 워크스테이션과 배포된 프로젝트의 전체 현황.
> 상세 정보는 각 워크스테이션의 `<alias>.json`(공개), `<alias>.local.json`(로컬 전용)을 참조한다.

---

## 워크스테이션 목록

| 별칭 | 환경 | defconfig 최종 실행일 | 라이브러리 버전 | 상태 파일 |
|------|------|---------------------|----------------|----------|
| pink-turtle | WSL2 (Ubuntu-20.04) | 2026-04-12 | v0.5.0 | `pink-turtle.json` |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | 2026-03-24 | v0.3.0 | `pink-turtle-rt.json` |
| pink-turtle-win | MINGW64 (Git Bash, Win11) | 2026-03-26 | v0.3.0 | `pink-turtle-win.json` |

> `pink-turtle-rt` / `pink-turtle-win`은 v0.5.0 미배포 — 각 워크스테이션에서
> `/adt:ai-platform-defconfig` 재실행 필요 (v0.5.0에서 글로벌 rule `platform.md`가 추가됨).

## 배포 프로젝트 현황

| 워크스테이션 | 프로젝트 | 경로 | 기반 버전 | Local | 배포일 | 비고 |
|-------------|---------|------|----------|-------|--------|------|
| pink-turtle | NDT-BPE_pork | `~/side_project/NDT-BPE_pork` | **v0.5.0** | 0 | 2026-07-26 | 복제본 제거 + rules 3개 추적 시작 (`92ceb63`, 미푸시) |
| pink-turtle | aralm_program | `~/side_project/aralm_program` | **v0.5.0** | 0 | 2026-07-26 | 초기 커밋 생성 (`7ca83a3`). remote 없음 |
| pink-turtle | mr-noti-bot | `~/side_project/mr-noti-bot` | **v0.5.0** | 0 | 2026-07-26 | 복제본 25파일 제거 (`2cde216`, 미푸시) |
| ~~pink-turtle~~ | ~~web_hook_server~~ | (실체 없음) | ~~v0.3.0~~ | - | 2026-04-10 | **2026-07-26 확인: 로컬에 존재하지 않음.** 재확인 후에도 없으면 이 행을 삭제 |

### v0.5.0 전파 내용 (2026-07-26)

3개 프로젝트 공통:

- **플러그인 로컬 복제본 제거** — `.claude/{agents,commands,hooks,skills,templates}` 23파일.
  v0.3.0 시절 사본이라 에이전트 `name`이 구 형식(`Designer Agent`)이었고, `adt` 플러그인이
  동일 내용을 올바른 이름으로 제공하므로 중복 등록 상태였다
- `CLAUDE.md` 기반 버전 `v0.4.1.0` → `v0.5.0`, 스킬 참조 `/adt:` 네임스페이스 통일
- `*.bak` 백업 파일 제거
- 프로젝트에 남기는 것: `CLAUDE.md`, `.claude/rules/`, `.claude/settings*.json`

> **전파 시 발견**: 4월의 v0.4.1 배포가 3개 프로젝트 모두 **커밋되지 않은 채** 방치되어 있었다
> (aralm_program은 커밋 자체가 없었음). 배포 스킬이 파일만 바꾸고 커밋을 남기지 않으면
> registry 기록과 실제 저장소 상태가 어긋난다 — `/adt:project-update`에 커밋 단계 추가 검토 필요.
