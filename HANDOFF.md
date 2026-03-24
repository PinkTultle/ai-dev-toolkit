# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-03-24
**작업 내용**: README 재구성, 사용 가이드 작성, 코드 문서화·blueprint 지침 강화
**버전**: v0.1.0
**브랜치**: `docs/usage-guide-and-conventions` (PR 대기 중 — 사용자가 직접 생성 예정)

### 이번 세션 완료 작업

#### README 재구성 + 사용 가이드
- [x] README.md — 사용자 관점으로 순서 재배치 (Why → 전제조건 → Quick Start → 워크플로우 → 스킬)
- [x] docs/usage-guide.md 신규 — 스킬 6개 상세 사용법 + 시나리오 + FAQ

#### 코드 문서화 지침
- [x] `docs/source/` 소스 트리 미러링 규칙 추가 (design-principles, global/project CLAUDE.md)
- [x] 주석은 "왜(why)", 문서는 "전체 그림(what/how)" — 역할 분리 원칙

#### blueprint 지침 강화
- [x] 범용 기술 지식은 바로 blueprints/에 작성하는 기준 추가 (blueprints/README.md)
- [x] project-configure에서 대화 과정을 통해 blueprint를 프로젝트에 마이그레이션하는 흐름 추가

### 현재 상태

- **버전**: v0.1.0 (v0.x.y 안정화 기간)
- **브랜치**: `docs/usage-guide-and-conventions` — 커밋 완료, 푸시 완료, **PR 미생성**
- **스킬**: 6개 (변경 없음)
- **배포 프로젝트**: 2개 (NDT-BPE_pork, aralm_program)
- **환경 이슈**: `gh` CLI — Ubuntu 20.04 glibc 2.31 호환 문제로 snap 설치 실패, 바이너리 직접 설치 필요

### 다음 작업 후보

1. **PR 생성 및 머지** — `docs/usage-guide-and-conventions` → main
2. **gh CLI 설치** — 바이너리 직접 설치 (`v2.62.0` 등 glibc 2.31 호환 버전)
3. **NDT-BPE_pork에 `/project-update` 실행** — 최신 산출물 구조 적용
4. **두 프로젝트에서 `/project-configure` 실행** — placeholder 구체화 + blueprint 마이그레이션
5. **defconfig 재실행** — `workstations/pink-turtle.json` 상태 파일 생성
6. **실사용 피드백 수집** — v0.x.y 기간 동안 스킬/워크플로우 검증
7. **다른 도구 지침 작성** — `cursor/`, `copilot/`, `windsurf/` (보류 중)

### 현재 저장소 구조

```
My_AI_manual/
├── .claude/skills/
│   ├── ai-platform-defconfig/SKILL.md
│   ├── project-init/SKILL.md
│   ├── project-configure/SKILL.md      ← blueprint 마이그레이션 흐름 추가
│   ├── project-update/SKILL.md
│   ├── project-absorb/SKILL.md
│   └── optimize-docs/SKILL.md
├── blueprints/                          ← 새 blueprint 추가 기준 추가
├── claude/
├── docs/
│   └── usage-guide.md                   ← 신규
├── workstations/
├── VERSION
├── VERSIONING.md
├── CHANGELOG.md
├── CLAUDE.md
├── HANDOFF.md
├── README.md                            ← 재구성
└── TOOL_REFERENCE.md
```

---

## 워크스테이션 환경 메모

> 상세 환경 정보는 `workstations/<alias>.json` 참조.

| 별칭 | 환경 | 상태 파일 | defconfig 최종 실행일 |
|------|------|----------|---------------------|
| pink-turtle | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle.json` (미생성) | 2026-03-23 |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle-rt.json` | 2026-03-24 |
