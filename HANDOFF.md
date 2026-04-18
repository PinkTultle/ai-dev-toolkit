# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-04-19
**작업 내용**: 배포 프로젝트 v0.3.0 → v0.4.1 업데이트 (`/adt:project-update`)
**버전**: v0.4.1 (변경 없음)
**브랜치**: `main`

### 이번 세션 완료 작업

#### 배포 프로젝트 업데이트 (v0.3.0 → v0.4.1)
- [x] **NDT-BPE_pork** (`~/side_project/NDT-BPE_pork`)
  - CLAUDE.md 헤더 버전: `v0.3.0.0` → `v0.4.1.0`
  - `.claude/rules/*.md` 3개 네임스페이스 통일 (`/project-configure` → `/adt:project-configure`)
    - build-environment.md, coding-standards.md, git-workflow.md
- [x] **aralm_program** (`~/side_project/aralm_program`)
  - CLAUDE.md 헤더 버전: `v0.3.0.0` → `v0.4.1.0`
  - `.claude/rules/git-workflow.md` 네임스페이스 통일
- [x] 변경 전 원본 `.bak` 백업 생성
- [x] `workstations/registry.md` 갱신

#### 보류/제외
- **mr-noti-bot**: 다른 세션 활성 중 — 동시 편집 충돌 방지 위해 업데이트 보류 (v0.3.0 유지)
- **web_hook_server**: registry에 등록되어 있으나 로컬 디스크에서 미발견

### 현재 상태

- **버전**: v0.4.1
- **브랜치**: `main`만 존재
- **플러그인 이름**: `adt` (AI Development Toolkit)
- **설치 명령**: `claude plugin install PinkTultle/ai-dev-toolkit`
- **스킬**: 11개 (`skills/`)
- **에이전트**: 12개 (`agents/`)
- **템플릿**: 4개 (`templates/`)
- **훅**: 1개 (`hooks/hooks.json` — PostToolUse 줄 수 검사)
- **Rules**: `.claude/rules/`에 글로벌 4 + 프로젝트 3 (이 저장소 자체 규칙)
- **배포 프로젝트**: NDT-BPE_pork(v0.4.1), aralm_program(v0.4.1), mr-noti-bot(v0.3.0 보류), web_hook_server(미발견)

### 주의사항

- **CLAUDE.md 본문 미갱신**: v0.4.1 템플릿의 아키텍처/시크릿/트러블슈팅 가이드 코멘트 확장은 반영하지 않음 — 배포 프로젝트가 이미 자체 커스텀 내용으로 채워져 있어 강제 덮어쓰기 회피
- **플러그인 로컬 복제본 잔존**: 두 프로젝트 모두 `.claude/{agents,commands,hooks,skills,templates,settings.json}` 유지 중 — 플러그인(`adt`)이 동일 내용 제공하므로 제거 가능하나 파괴적 작업이라 별도 결정 대기
- **mr-noti-bot 업데이트 필요**: 다른 세션 종료 후 `/adt:project-update mr-noti-bot` 실행
- **web_hook_server 실체 확인**: registry 기록과 로컬 불일치 — 경로 재확인 또는 registry에서 제거 필요
- **SessionStart 훅 미구현**: Design Phase 3의 blueprints 컨텍스트 주입 훅은 향후 과제
- **다른 워크스테이션 미배포**: pink-turtle-rt, pink-turtle-win에 v0.4.1 미적용

### 다음 작업 후보

1. **mr-noti-bot v0.4.1 업데이트** — 다른 세션 종료 후 `/adt:project-update mr-noti-bot` 실행
2. **web_hook_server 실체 확인 후 registry 정정** — 경로 재탐색 또는 registry 항목 제거
3. **플러그인 로컬 복제본 정리** — NDT-BPE_pork/aralm_program의 `.claude/{agents,commands,hooks,skills,templates,settings.json}` 제거 여부 결정 (플러그인이 제공하므로 중복)
4. **SessionStart 훅 구현** — blueprints 핵심 규칙을 세션 시작 시 컨텍스트 주입 (Design Phase 3)
5. **다른 워크스테이션 defconfig 재실행** — pink-turtle-rt, pink-turtle-win에 v0.4.1 배포

### 학습 사항

- **기존 `/adt:project-update` 흐름 관찰**: CLAUDE.md 본문 변경이 "템플릿 코멘트 확장" 수준인 경우, 배포 프로젝트는 이미 내용이 채워져 있어 헤더 버전만 갱신하는 것이 안전. 전체 본문 병합 시도는 커스텀 손실 위험이 큼.
- **동시 세션 고려**: 활성 세션이 지침 파일을 읽고 작업 중일 때 배포 업데이트를 하면 규칙 변경이 중간에 끼어 혼란 — 활성 세션은 건너뛰는 것이 안전.

### 현재 저장소 구조

> 상세 구조는 `docs/project-structure.md` 참조.

```
ai-dev-toolkit/                     ← Claude Code 플러그인 (adt)
├── .claude-plugin/
│   ├── plugin.json                 ← 매니페스트 (v0.4.0)
│   └── marketplace.json
├── package.json
├── skills/ (11개)                  ← 스킬 (adt: 접두사)
├── agents/ (12개)                  ← 에이전트 파이프라인
├── templates/ (4개)                ← 문서 템플릿
├── hooks/                          ← 플러그인 훅
│   ├── hooks.json
│   └── post-edit-check.sh
├── blueprints/                     ← 공유 지식 (유지)
├── claude/                         ← 배포용 템플릿 (하위 호환)
├── .claude/rules/                  ← 이 프로젝트 자체 규칙
├── docs/
│   ├── 01-plan/features/           ← PDCA Plan
│   ├── 02-design/features/         ← PDCA Design
│   ├── 03-analysis/                ← PDCA Gap Analysis
│   ├── 04-report/                  ← PDCA Report
│   └── ...
├── workstations/
├── VERSION                         ← 0.4.0
└── CHANGELOG.md
```

### 산출물 디렉토리 (PDCA)

```
docs/
├── 01-plan/features/plugin-migration.plan.md
├── 02-design/features/plugin-migration.design.md
├── 03-analysis/plugin-migration.analysis.md
└── 04-report/plugin-migration.report.md
```

---

## 워크스테이션 환경 메모

> 상세 환경 정보는 `workstations/<alias>.json` 참조.

| 별칭 | 환경 | 상태 파일 | defconfig 최종 실행일 |
|------|------|----------|---------------------|
| pink-turtle | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle.json` | 2026-04-12 |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle-rt.json` | 2026-03-24 |
| pink-turtle-win | MINGW64 (Git Bash, Win11) | `workstations/pink-turtle-win.json` | 2026-03-26 |
