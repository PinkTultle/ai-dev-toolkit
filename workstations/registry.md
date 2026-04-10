# 배포 레지스트리

> 워크스테이션과 배포된 프로젝트의 전체 현황.
> 상세 정보는 각 워크스테이션의 `<alias>.json`(공개), `<alias>.local.json`(로컬 전용)을 참조한다.

---

## 워크스테이션 목록

| 별칭 | 환경 | defconfig 최종 실행일 | 상태 파일 |
|------|------|---------------------|----------|
| pink-turtle | WSL2 (Ubuntu-20.04) | 2026-03-23 | `pink-turtle.json` |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | 2026-03-24 | `pink-turtle-rt.json` |

## 배포 프로젝트 현황

| 워크스테이션 | 프로젝트 | 기반 버전 | Local | 배포일 | 비고 |
|-------------|---------|----------|-------|--------|------|
| pink-turtle | NDT-BPE_pork | v0.1.0 | 0 | 2026-03-23 | |
| pink-turtle | aralm_program | v0.1.0 | 0 | 2026-03-23 | update 필요 (v0.3.0) |
| pink-turtle | web_hook_server | v0.3.0 | 0 | 2026-04-10 | v0.3.0 업데이트 — 에이전트 11개, 템플릿, hooks, rules |
