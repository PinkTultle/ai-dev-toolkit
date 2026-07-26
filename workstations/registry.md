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
| pink-turtle | NDT-BPE_pork | `~/side_project/NDT-BPE_pork` | v0.4.1 | 0 | 2026-04-18 | v0.5.0 업데이트 후보 |
| pink-turtle | aralm_program | `~/side_project/aralm_program` | v0.4.1 | 0 | 2026-04-18 | v0.5.0 업데이트 후보 |
| pink-turtle | mr-noti-bot | `~/side_project/mr-noti-bot` | v0.4.1 | 0 | 2026-04-19 | v0.5.0 업데이트 후보 |
| ~~pink-turtle~~ | ~~web_hook_server~~ | (실체 없음) | ~~v0.3.0~~ | - | 2026-04-10 | **2026-07-26 확인: 로컬에 존재하지 않음.** 재확인 후에도 없으면 이 행을 삭제 |
