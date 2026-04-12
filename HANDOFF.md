# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-04-12
**작업 내용**: pink-turtle 워크스테이션 최신화 — defconfig 재실행 + 프로젝트 3개 v0.3.0 업데이트
**버전**: v0.3.0
**브랜치**: `main`

### 이번 세션 완료 작업

#### pink-turtle defconfig 재실행
- [x] `~/.claude/rules/` 심볼릭 링크 4개 생성 (environment, communication, workflow, code-review)
- [x] `~/.claude/settings.json`에 deny 규칙 9개 추가
- [x] `workstations/pink-turtle.json` 갱신 (경로 수정 My_AI_manual, 이력 추가)

#### 배포 프로젝트 v0.3.0 업데이트
- [x] **NDT-BPE_pork** (v0.1.0 → v0.3.0) — 에이전트 12개, 커맨드 5개, 템플릿 4개, hooks, rules(C++), settings.json
- [x] **aralm_program** (v0.1.0 → v0.3.0) — 동일 구성, rules는 git-workflow만 (Rust/TS)
- [x] **mr-noti-bot** (없음 → v0.3.0 신규) — clone 상태에서 init + 기본 정보 채움 (Go)

### 현재 상태

- **버전**: v0.3.0
- **브랜치**: `main`만 존재
- **에이전트**: 12개 (파이프라인 6 + 검증 3 + 보고 1 + 조율 1 + PM 1)
- **커맨드**: 5개 (handoff, sync-check, doc-gen, review, decision)
- **스킬**: 6개
- **템플릿**: 4개 (plan, design, report, decision)
- **Hooks**: 1개 (post-edit-check.sh)
- **Rules**: 글로벌 4개 + 프로젝트 3개
- **ADR**: 1개 (ADR-001 rkit 패턴 채택)
- **배포 프로젝트**: 4개 (모두 v0.3.0)

### 주의사항

- pink-turtle-rt, pink-turtle-win에는 아직 v0.3.0 미배포 — defconfig 재실행 필요
- mr-noti-bot CLAUDE.md는 기본 정보만 채움 — `/project-configure`로 상세 구체화 권장
- Claude GitHub App 미설치 — workflow는 있지만 앱 + ANTHROPIC_API_KEY 시크릿 필요

### 다음 작업 후보

1. **mr-noti-bot `/project-configure`** — CLAUDE.md 상세 구체화 (아키텍처, 규칙 등)
2. **다른 워크스테이션 defconfig** — pink-turtle-rt, pink-turtle-win에 v0.3.0 배포
3. **에이전트 파이프라인 실전 테스트** — 실제 프로젝트에서 Medium/Large 프리셋 실행 검증
4. **Claude GitHub App 설치** — PR 자동화 활성화
5. **project-init/configure 갱신** — 에이전트 12개, 커맨드를 배포 대상에 포함

### 현재 저장소 구조

> 상세 구조는 `docs/project-structure.md` 참조.

```
ai-dev-toolkit/
├── .claude/
│   ├── agents/ (12개)                 ← 파이프라인 6 + 검증 3 + 보고 1 + 조율 1 + PM 1
│   ├── commands/ (5개)                ← handoff, sync-check, doc-gen, review, decision
│   ├── hooks/                         ← PostToolUse 자동 검사
│   ├── templates/ (4개)               ← Plan, Design, Report, ADR 템플릿
│   ├── rules/ (7개 + README)
│   ├── skills/ (6개)
│   ├── settings.json                  ← 팀 공유 (deny + hooks)
│   └── settings.local.json            ← 개인 (gitignore)
├── .github/workflows/claude.yml       ← @claude PR 자동화
├── blueprints/
├── claude/
│   ├── global_CLAUDE.md               ← 인덱스 (41줄)
│   ├── project_CLAUDE.md
│   └── README.md
├── docs/
│   ├── decisions/                     ← ADR 시스템
│   └── ...
├── workstations/
│   ├── pink-turtle.json               ← defconfig 2026-04-12
│   ├── pink-turtle-rt.json
│   └── pink-turtle-win.json
├── VERSION                            ← 0.3.0
└── ...
```

### 산출물 디렉토리 (프로젝트 표준)

```
docs/artifacts/
├── ideation/        ← ideation agent
├── design/          ← designer agent
├── review/          ← reviewer agent
├── implementation/  ← implementer agent
├── summary/         ← verifier agent
└── test-report/     ← tester agent
```

---

## 워크스테이션 환경 메모

> 상세 환경 정보는 `workstations/<alias>.json` 참조.

| 별칭 | 환경 | 상태 파일 | defconfig 최종 실행일 |
|------|------|----------|---------------------|
| pink-turtle | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle.json` | 2026-04-12 |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle-rt.json` | 2026-03-24 |
| pink-turtle-win | MINGW64 (Git Bash, Win11) | `workstations/pink-turtle-win.json` | 2026-03-26 |
