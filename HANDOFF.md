# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-04-19
**작업 내용**: v0.4.2 릴리스 — 배포 프로젝트 3개 v0.4.1 업데이트 + 지침 흡수 3건
**버전**: v0.4.1 → **v0.4.2**
**브랜치**: `main`

### 이번 세션 완료 작업

#### 배포 프로젝트 업데이트 (v0.3.0 → v0.4.1)
- [x] **NDT-BPE_pork** — CLAUDE.md 헤더 + rules 3개(`build-environment`, `coding-standards`, `git-workflow`) 네임스페이스 `/adt:` 통일
- [x] **aralm_program** — CLAUDE.md 헤더 + rules/git-workflow.md 네임스페이스 통일
- [x] **mr-noti-bot** — CLAUDE.md 헤더 + rules/git-workflow.md 네임스페이스 통일 (기능 구현 완료 후 업데이트)
- [x] 변경 전 원본 `.bak` 백업 생성
- [x] `workstations/registry.md` 3개 항목 갱신

#### 프로젝트 → 라이브러리 흡수 3건
- [x] **지식 축적 규칙** (aralm_program 출처) — `blueprints/base-directives.md` §3 + `.claude/rules/global-communication.md` 신규 섹션: "AI는 기술 지침·스택 문서·규칙에 임의로 내용을 추가하지 않는다 — 사용자 합의 내용만 기록"
- [x] **월별 archive 패턴** (mr-noti-bot 출처) — `claude/project_CLAUDE.md` §7: `docs/archive/YYYY-MM/<feature>/` + `_INDEX.md` 구조로 완료 feature 보관
- [x] **네이밍 컨벤션 표 예시** (aralm_program 출처) — `claude/project_CLAUDE.md` §4.1 다언어 프로젝트용 표 형식 주석 추가

#### 본 저장소 규칙
- [x] `CLAUDE.md` §4.8 응답 말미 규칙 — rkit Feature Usage 리포트 생략, `💡 다음: <추천>` 한 줄만 유지

#### v0.4.2 릴리스
- [x] `VERSION` 0.4.1 → 0.4.2
- [x] `.claude-plugin/plugin.json`, `marketplace.json`, `package.json` 버전 bump
- [x] `CHANGELOG.md` [0.4.2] 항목 추가
- [x] git tag `v0.4.2`

### 현재 상태

- **버전**: v0.4.2
- **브랜치**: `main`만 존재
- **플러그인 이름**: `adt` (AI Development Toolkit)
- **설치 명령**: `claude plugin install PinkTultle/ai-dev-toolkit`
- **스킬**: 11개 (`skills/`)
- **에이전트**: 12개 (`agents/`)
- **템플릿**: 4개 (`templates/`)
- **훅**: 1개 (`hooks/hooks.json` — PostToolUse 줄 수 검사)
- **Rules**: `.claude/rules/`에 글로벌 4 + 프로젝트 3 (이 저장소 자체 규칙)
- **배포 프로젝트**: NDT-BPE_pork(v0.4.1), aralm_program(v0.4.1), mr-noti-bot(v0.4.1), web_hook_server(로컬 미발견)

### 주의사항

- **배포 프로젝트는 v0.4.1 상태** — 이번 세션에서 라이브러리가 v0.4.2로 올라갔으므로 배포 프로젝트는 다시 업데이트 후보가 됨. 다만 v0.4.2 변경은 템플릿 예시/주석 보강이라 배포 프로젝트에 대한 강제 반영 필요성은 낮음
- **CLAUDE.md 본문 미갱신**: 배포 프로젝트가 이미 자체 커스텀 내용으로 채워져 있어 헤더 버전만 갱신. 본문 템플릿 확장은 강제 덮어쓰기 회피
- **플러그인 로컬 복제본 잔존**: 배포 프로젝트 3개 모두 `.claude/{agents,commands,hooks,skills,templates,settings.json}` 유지 중 — 플러그인(`adt`)이 동일 내용 제공하므로 제거 가능하나 파괴적 작업이라 별도 결정 대기
- **web_hook_server 실체 확인 필요**: registry 기록과 로컬 불일치 — 경로 재확인 또는 registry에서 제거 필요
- **SessionStart 훅 미구현**: Design Phase 3의 blueprints 컨텍스트 주입 훅은 향후 과제
- **다른 워크스테이션 미배포**: pink-turtle-rt, pink-turtle-win에 v0.4.2 미적용

### 다음 작업 후보

1. **플러그인 로컬 복제본 정리** — 배포 프로젝트 3개의 `.claude/{agents,commands,hooks,skills,templates,settings.json}` 제거 여부 결정
2. **web_hook_server 실체 확인 후 registry 정정** — 경로 재탐색 또는 registry 항목 제거
3. **배포 프로젝트 v0.4.2 적용 여부 판단** — 변경이 템플릿 코멘트 수준이라 선택적
4. **SessionStart 훅 구현** — blueprints 핵심 규칙을 세션 시작 시 컨텍스트 주입 (Design Phase 3)
5. **다른 워크스테이션 defconfig 재실행** — pink-turtle-rt, pink-turtle-win에 v0.4.2 배포

### 학습 사항

- **`/adt:project-update` 운영 경험**: CLAUDE.md 본문 변경이 "템플릿 코멘트 확장" 수준인 경우 배포 프로젝트는 이미 내용이 채워져 있으므로 헤더 버전만 갱신하는 것이 안전. 전체 본문 병합 시도는 커스텀 손실 위험.
- **동시 세션 고려 기준**: "세션 활성" 여부가 아닌 "기능 단위 완료(브랜치 머지)" 시점이 기준. 개발 도중 지침 변경은 커밋 섞임/규칙 혼란을 유발.
- **흡수(absorb) 사이클 관찰**: 배포 프로젝트의 커스텀에서 일반화 가능한 패턴(archive 월별 관리, 지식 축적 원칙, 네이밍 표 형식)만 선별 반영. 프로젝트 특화(학습용 fork 규칙, 특정 디렉토리 JSON 참조 등)는 반영 제외.

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
