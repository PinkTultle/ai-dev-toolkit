# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-04-03
**작업 내용**: rules 도입 + 서브에이전트 파이프라인 구축 + defconfig 재실행
**버전**: v0.2.0 (다음 릴리즈 시 v0.3.0 예정)
**브랜치**: `main`

### 이번 세션 완료 작업

#### .claude/rules/ 도입 (PR #3)
- [x] `.claude/rules/` 디렉토리 신설 — 7개 rule 파일 + README
  - 글로벌 4개: environment, communication, workflow, code-review
  - 프로젝트 템플릿 3개: coding-standards, git-workflow, build-environment
  - `paths` frontmatter로 C/C++ 파일, 빌드 파일에서만 조건부 로드
- [x] `global_CLAUDE.md` 경량화 (143줄 → 41줄) — 인덱스 + 참조 테이블
- [x] 스킬 3개 갱신 (defconfig, project-configure, project-update)
- [x] `.gitignore` 개선 — 로컬 전용만 명시적 제외
- [x] 문서 7개 갱신 + rules 자기검토 보완 (Git Hooks 추가, code-review 제목 정정)

#### 서브에이전트 파이프라인 (PR #4, #5)
- [x] `blueprints/design-principles.md` 확장 — 단계별 에이전트 구성표, 팀 패턴, 품질 루프
- [x] `.claude/agents/` 디렉토리 신설 — 6개 에이전트 정의
  - ideation (sonnet): 요구사항 분석, 범위/제약조건 명확화
  - designer (opus): 접근 방식 설계, 트레이드오프 분석
  - reviewer (opus): 설계 검토, 품질 루프 검토자
  - implementer (opus): 코드 구현 + 구현 로그, worktree 격리
  - verifier (sonnet): 설계 대비 구현 검증
  - tester (sonnet): 빌드/단위/통합/회귀 테스트
- [x] `docs/artifacts/implementation/` 추가 — 구현 단계 산출물

#### 환경 설정
- [x] `gh auth login` + `~/.bashrc`에 `GH_TOKEN` (파일 참조 방식)
- [x] `/ai-platform-defconfig` 재실행 — `~/.claude/rules/` 심볼릭 링크 배포
- [x] `workstations/pink-turtle.json` 생성
- [x] 컨텍스트 사용량 프로그레스 바 설정 (`~/.claude/statusline-command.sh`)

### 현재 상태

- **버전**: v0.2.0
- **브랜치**: `main`만 존재
- **스킬**: 6개
- **에이전트**: 6개 (신규)
- **Rules**: 글로벌 4개 + 프로젝트 3개, `~/.claude/rules/` 배포 완료
- **워크스테이션**: 3개 (pink-turtle에 rules 배포됨)
- **배포 프로젝트**: 3개 (변경 없음)

### 주의사항

- `GH_TOKEN`의 `gho_` 토큰은 만료 가능 — 만료 시 PAT(`ghp_`) 발급 후 `~/.config/gh/token` 교체
- pink-turtle-rt, pink-turtle-win에는 아직 rules 미배포 — defconfig 재실행 필요
- 에이전트는 정의만 완료, 파이프라인 오케스트레이션 스킬은 미구현

### 다음 작업 후보

1. **파이프라인 오케스트레이터 스킬** — 에이전트를 순차 실행하는 스킬 구현
2. **버전 릴리즈** — v0.3.0 (rules + agents 도입, CHANGELOG, git tag)
3. **실사용 테스트** — 실제 프로젝트에서 에이전트 파이프라인 실행 검증
4. **에이전트 팀 구성** — Large 프리셋용 팀 템플릿 (`.claude/teams/`)
5. **기존 프로젝트 업데이트** — NDT-BPE_pork, aralm_program에 v0.3.0 적용
6. **다른 워크스테이션 defconfig** — pink-turtle-rt, pink-turtle-win에 rules 배포
7. **다른 도구 지침** — cursor/, copilot/, windsurf/ (보류)

### 현재 저장소 구조

```
ai-dev-toolkit/
├── .claude/
│   ├── agents/                         ← 신규: 단계별 서브에이전트
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
