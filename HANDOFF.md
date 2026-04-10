# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-04-10
**작업 내용**: Claude Code 학습 (Level 1~3) + 권한 정리 + 커스텀 커맨드 작성
**버전**: v0.2.0 (다음 릴리즈 시 v0.3.0 예정)
**브랜치**: `main`

### 이번 세션 완료 작업

#### Claude Code 학습 (Level 1~3)
- [x] Level 1: CLAUDE.md 계층 구조, 작성 원칙, rules 조건부 로드, Plan Mode
- [x] Level 2: 슬래시 커맨드, Hooks 이벤트, 권한 관리 패턴
- [x] Level 3: 서브에이전트, 스킬 구조, 에이전트 vs 스킬 차이, MCP 연동

#### 권한 설정 정리
- [x] `settings.local.json` 정리 — 일회성 허용 30개 → 와일드카드 패턴 12개
- [x] `deny` 목록 추가 — 위험한 git 명령 9개 (force push, reset --hard, clean -f 등)

#### 환경 설정
- [x] statusline 프로그레스 바 — 첫 실행 시 0% 표시되도록 수정 (`~/.claude/statusline-command.sh`)

#### 커스텀 커맨드 실습
- [x] `.claude/commands/handoff.md` 신규 생성 — 세션 종료 시 HANDOFF.md 자동 갱신+커밋+푸시

### 현재 상태

- **버전**: v0.2.0
- **브랜치**: `main`만 존재
- **스킬**: 6개
- **커맨드**: 1개 (handoff) — 신규
- **에이전트**: 6개
- **Rules**: 글로벌 4개 + 프로젝트 4개 (README 포함), `~/.claude/rules/` 배포 완료
- **워크스테이션**: 3개 (pink-turtle에 rules 배포됨)
- **배포 프로젝트**: 3개 (변경 없음)

### 주의사항

- `GH_TOKEN`의 `gho_` 토큰은 만료 가능 — 만료 시 PAT(`ghp_`) 발급 후 `~/.config/gh/token` 교체
- pink-turtle-rt, pink-turtle-win에는 아직 rules 미배포 — defconfig 재실행 필요
- 에이전트는 정의만 완료, 파이프라인 오케스트레이션 스킬은 미구현
- `settings.local.json`의 `deny` 목록은 **이 프로젝트 전용** — 글로벌 적용하려면 `~/.claude/settings.json`에도 추가 필요

### 다음 작업 후보

1. **Claude Code 학습 계속** — Level 4 (팀 최적화), Level 5 (PDCA)
2. **파이프라인 오케스트레이터 스킬** — 에이전트를 순차 실행하는 스킬 구현
3. **버전 릴리즈** — v0.3.0 (rules + agents + commands 도입, CHANGELOG, git tag)
4. **실사용 테스트** — 실제 프로젝트에서 에이전트 파이프라인 실행 검증
5. **기존 프로젝트 업데이트** — NDT-BPE_pork, aralm_program에 v0.3.0 적용
6. **다른 워크스테이션 defconfig** — pink-turtle-rt, pink-turtle-win에 rules 배포
7. **deny 목록 글로벌 배포** — `~/.claude/settings.json`에 위험 git 명령 deny 추가

### 현재 저장소 구조

```
ai-dev-toolkit/
├── .claude/
│   ├── commands/                        ← 신규: 커스텀 슬래시 커맨드
│   │   └── handoff.md                  #   세션 종료 인수인계 자동화
│   ├── agents/                         ← 단계별 서브에이전트
│   │   ├── ideation.md                 #   1단계 (sonnet)
│   │   ├── designer.md                 #   2단계 (opus)
│   │   ├── reviewer.md                 #   3단계 (opus)
│   │   ├── implementer.md              #   4단계 (opus, worktree)
│   │   ├── verifier.md                 #   5단계 (sonnet)
│   │   └── tester.md                   #   6단계 (sonnet)
│   ├── rules/                          ← 세부 규칙 파일
│   │   ├── global-*.md (4개)           #   글로벌 rules
│   │   ├── project-*.md (3개)          #   프로젝트 rules 템플릿
│   │   └── README.md
│   └── skills/ (6개)
├── blueprints/                         ← 서브에이전트 구성표/팀/루프 추가됨
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
