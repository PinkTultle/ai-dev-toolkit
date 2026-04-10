# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-04-10
**작업 내용**: CC 학습 L1~5 + rkit 패턴 채택 + 에이전트 11개 + v0.3.0 릴리즈
**버전**: v0.3.0
**브랜치**: `main`

### 이번 세션 완료 작업

#### Claude Code 학습 (Level 1~5 전체)
- [x] Level 1: CLAUDE.md 계층 구조, Plan Mode
- [x] Level 2: 커맨드, Hooks, 권한 관리 + 실습 (권한 정리, deny)
- [x] Level 3: 에이전트, 스킬, MCP + 실습 (/handoff 커맨드)
- [x] Level 4: PR 자동화, 팀 규칙, Agent Teams + 실습 3종 (deny 글로벌, workflow, /sync-check)
- [x] Level 5: PDCA 방법론

#### rkit 패턴 채택 (ADR-001)
- [x] `.claude/templates/` 도입 — Plan, Design, Report, ADR 문서 템플릿 4종
- [x] `.claude/hooks/` 도입 — PostToolUse 지침 파일 줄 수 자동 경고
- [x] `docs/decisions/` 도입 — ADR 시스템 + `/decision` 커맨드
- [x] 에이전트 템플릿 참조 방식 전환 — 인라인 형식 → 템플릿 기반

#### 유틸리티 에이전트 5종 추가
- [x] product-manager (opus): 요구사항 구조화 + MoSCoW
- [x] gap-detector (opus): 설계↔구현 매칭율 정량 측정 (90% 게이트)
- [x] code-analyzer (sonnet): 코드 품질 SQ-001~008 심층 분석
- [x] design-validator (opus): 설계 완성도 정량 판정 (구현 착수 게이트)
- [x] report-generator (sonnet): PDCA 완료 보고서 자동 생성
- [x] cto-lead (opus): Large 프리셋 전체 파이프라인 조율

#### 기존 에이전트 강화
- [x] reviewer: 판정 기준표 + 템플릿 준수 체크
- [x] implementer: 자기 검증 단계
- [x] tester: PASS/PARTIAL/FAIL 판정 기준
- [x] 게이트 모델 승격: design-validator, gap-detector → opus

#### 프로젝트 업그레이드
- [x] `.claude/settings.json` — 팀 공유 deny + PostToolUse Hook
- [x] `.claude/commands/` — handoff, sync-check, doc-gen, review, decision (5종)
- [x] `.github/workflows/claude.yml` — @claude PR 자동화
- [x] 권한 정리 — 프로젝트 30→12, 글로벌 69→18, deny 9개 양쪽 배포
- [x] 환경변수 — AGENT_TEAMS, SUBPROCESS_ENV_SCRUB

#### web_hook_server 흡수 + v0.3.0 업데이트
- [x] `/project-absorb` — 아키텍처 다이어그램, 시크릿 규칙, 트러블슈팅 가이드 3건 흡수 → 템플릿 반영
- [x] `/project-update` — web_hook_server에 v0.3.0 전체 적용 (에이전트 11개, 커맨드 5개, 템플릿 4개, hooks, rules, settings)
- [x] registry.md 갱신 — web_hook_server v0.2.0 → v0.3.0

### 현재 상태

- **버전**: v0.3.0
- **브랜치**: `main`만 존재
- **에이전트**: 11개 (파이프라인 6 + 검증 3 + 보고 1 + 조율 1)
- **커맨드**: 5개 (handoff, sync-check, doc-gen, review, decision)
- **스킬**: 6개
- **템플릿**: 4개 (plan, design, report, decision)
- **Hooks**: 1개 (post-edit-check.sh)
- **Rules**: 글로벌 4개 + 프로젝트 3개
- **ADR**: 1개 (ADR-001 rkit 패턴 채택)
- **워크스테이션**: 3개 (pink-turtle에 rules+deny 배포됨)

### 주의사항

- `GH_TOKEN`의 `gho_` 토큰은 만료 가능 — 만료 시 PAT(`ghp_`) 발급 후 `~/.config/gh/token` 교체
- pink-turtle-rt, pink-turtle-win에는 아직 v0.3.0 미배포 — defconfig 재실행 필요
- Claude GitHub App 미설치 — workflow는 있지만 앱 + ANTHROPIC_API_KEY 시크릿 필요
- Agent Teams 환경변수 추가했으나 현재 세션에서는 미적용 (재시작 필요)

### 다음 작업 후보

1. **web_hook_server 에이전트 테스트** — `~/test/web_hook_server/`에서 v0.3.0 커밋 + 파이프라인 실행 검증
2. **Claude GitHub App 설치** — PR 자동화 활성화 (ANTHROPIC_API_KEY 시크릿 추가)
3. **나머지 프로젝트 업데이트** — NDT-BPE_pork, aralm_program에 v0.3.0 적용
4. **다른 워크스테이션 defconfig** — pink-turtle-rt, pink-turtle-win에 v0.3.0 배포
5. **파이프라인 오케스트레이터 스킬** — cto-lead 기반 자동 실행 스킬
6. **project-init/configure 갱신** — 템플릿, 커맨드, 에이전트를 배포 대상에 포함

### 현재 저장소 구조

> 상세 구조는 `docs/project-structure.md` 참조.

```
ai-dev-toolkit/
├── .claude/
│   ├── agents/ (11개)                  ← 파이프라인 6 + 검증 3 + 보고 1 + 조율 1
│   ├── commands/ (5개)                 ← handoff, sync-check, doc-gen, review, decision
│   ├── hooks/                          ← PostToolUse 자동 검사
│   ├── templates/ (4개)                ← Plan, Design, Report, ADR 템플릿
│   ├── rules/ (7개 + README)
│   ├── skills/ (6개)
│   ├── settings.json                   ← 팀 공유 (deny + hooks)
│   └── settings.local.json             ← 개인 (gitignore)
├── .github/workflows/claude.yml        ← @claude PR 자동화
├── docs/
│   ├── decisions/                      ← ADR 시스템
│   └── ...
├── blueprints/
├── claude/
│   ├── global_CLAUDE.md                ← 인덱스 (41줄)
│   ├── project_CLAUDE.md
│   └── README.md
├── docs/
├── workstations/
│   └── pink-turtle.json                ← 신규: rules 배포 이력 포함
├── VERSION                             ← 0.2.0
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
| pink-turtle | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle.json` | 2026-04-03 |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle-rt.json` | 2026-03-24 |
| pink-turtle-win | MINGW64 (Git Bash, Win11) | `workstations/pink-turtle-win.json` | 2026-03-26 |
