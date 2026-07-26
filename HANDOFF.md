# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-07-26
**작업 내용**: v0.5.0 릴리스 — Claude Code v2.1.220 대응 (동작 결함 2건 수정 + 플랫폼 계층 blueprint 신설) + 배포 프로젝트 3개 전파
**버전**: v0.4.2 → **v0.5.0** (main 머지 완료, 태그 `v0.5.0` 생성)
**브랜치**: `docs/v0.5.0-propagation` (PR → main 필요)

### 배경

직전 작업(2026-04-19) 이후 3개월 공백. 그 사이 Claude Code가 v2.1.79 → **v2.1.220**으로
올라가면서 서브에이전트 실행 모델, 훅 입출력 계약, 에이전트 정의 스펙이 바뀌었다.
공식 changelog와 docs를 조사해 격차를 정리하고 반영했다.

### 이번 세션 완료 작업

#### 결함 수정 (실제로 동작하지 않던 것)

- [x] **훅 무동작 수정** — `hooks.json`이 `$CLAUDE_FILE_PATH`를 인자로 넘기고 있었으나
      **그런 환경변수는 존재하지 않는다.** 훅은 stdin JSON(`.tool_input.file_path`)으로 입력을 받는다.
      v0.4.0 도입 이후 200줄 검사가 한 번도 실행되지 않았음. 실제 JSON을 파이프해 동작 확인 완료
- [x] **에이전트 `name` 스펙 위반 12건** — `Code Analyzer Agent` → `code-analyzer` 등 전면 kebab-case화.
      `name`은 소문자·하이픈만 허용되며 `Agent(<name>)` 권한 규칙과 `SubagentStart` 훅의
      `agent_type`이 이 값을 사용한다. **호출 경로가 바뀌는 breaking change**

#### 플랫폼 계층 blueprint 신설 (3개)

- [x] `blueprints/agent-runtime.md` — 에이전트/스킬 프론트매터 전체 필드, 백그라운드 실행 모델,
      `/subtask`↔`/fork`, 중첩 깊이 3·동시 20·세션 200 상한, 모델·effort 선택 기준
- [x] `blueprints/memory-and-context.md` — 지침 배치 결정표, CLAUDE.md 계층, `paths` 스코프 rule,
      **auto memory**(`~/.claude/projects/<project>/memory/`) 운용 규칙
- [x] `blueprints/hooks.md` — 훅 이벤트 30여 종, stdin JSON 계약, `matcher`/`if` 문법, 작성·검증 규칙
- [x] `.claude/rules/global-platform.md` → `~/.claude/rules/platform.md` 요약본 + 심볼릭 링크 배포

#### 최신 기능 반영

- [x] 에이전트 12개에 `color`, 설계·검토·검증·구현 4종에 `effort: high`
- [x] `implementer`에 **`isolation: worktree` 실제 적용** — 그간 문서에만 적혀 있던 격리를 실제 설정으로
- [x] 파괴적·수동 스킬 7개에 `disable-model-invocation: true` (AI 자동 호출 차단)
- [x] `hooks.json`에 `if: "Edit(**/*.md)"` 대상 축소
- [x] `TOOL_REFERENCE.md` — Agent Skills 오픈 표준 절 추가 (이식 가능 필드 vs CC 확장 필드 구분)
- [x] `blueprints/environment.md` + `global-environment.md` — worktree 기본 위치(`.claude/worktrees/`)
- [x] 최소 요구 버전 `>=2.1.78` → `>=2.1.202` (v2.1.220에서 검증)

#### 레포 위생

- [x] `workstations/registry.md` — 워크스테이션 3개 전체 반영 + 배포 경로 열 추가,
      `web_hook_server` 실체 없음 확인(2026-07-26) 후 취소선 처리
- [x] `docs/project-structure.md` — 에이전트 표를 실제 파일 기준으로 정정
      (`design-validator`/`gap-detector`는 문서상 sonnet이었으나 실제 opus), blueprints 9개 반영
- [x] 버전 문자열 4곳 동기화 (VERSION, plugin.json, marketplace.json, package.json)

#### 배포 프로젝트 3개 전파 (v0.4.1 → v0.5.0)

- [x] **플러그인 업데이트** — user scope `adt` 0.4.1 → 0.5.0 (`claude plugin update`)
- [x] **로컬 복제본 제거** — 3개 프로젝트 각 23파일(`.claude/{agents,commands,hooks,skills,templates}`).
      v0.3.0 시절 사본이라 에이전트 `name`이 구 형식이었고 플러그인과 중복 등록 상태였음.
      제거 전 라이브러리와 diff 대조 — 흡수할 프로젝트 커스터마이징 없음을 확인
- [x] `CLAUDE.md` 기반 버전 `v0.4.1.0` → `v0.5.0` + `/adt:` 네임스페이스 통일, `*.bak` 제거
- [x] 커밋: NDT-BPE_pork `92ceb63` / mr-noti-bot `2cde216` / aralm_program `7ca83a3`(초기 커밋)

> **전파 중 발견**: 4월의 v0.4.1 배포가 3개 프로젝트 모두 **커밋되지 않은 채** 방치돼 있었다.
> aralm_program은 저장소에 커밋 자체가 하나도 없었다. HANDOFF에는 "업데이트 완료"로 기록돼
> 있었으므로, 배포 스킬이 파일만 바꾸고 커밋을 남기지 않으면 기록과 실제가 어긋난다.

### 검증 결과

| 항목 | 결과 |
|------|------|
| JSON 4개 유효성 | 통과 |
| 지침 파일 200줄 제한 | 전부 이내 (최대 `design-principles.md` 185줄) |
| 에이전트 `name` 스펙 | 12/12 kebab-case |
| 훅 실동작 (stdin JSON 주입) | 정상 종료 + 200줄 초과 시 경고 확인 |
| 버전 일관성 | 4개 파일 0.5.0 일치 |

### 현재 상태

- **버전**: v0.5.0 — main 머지 완료(PR #6, squash `a85b8b6`), 태그 `v0.5.0` 푸시 완료
- **브랜치**: `docs/v0.5.0-propagation` — 전파 기록 반영용, **PR 미생성**
- **설치 플러그인**: `adt@PinkTultle-adt` v0.5.0 (user scope) — 세션 재시작 시 적용
- **스킬**: 11개 / **에이전트**: 12개 / **템플릿**: 4개 / **Blueprints**: 9개
- **글로벌 rules**: 5개 (environment, communication, workflow, **platform**(신규), code-review)
- **배포 프로젝트**: NDT-BPE_pork · aralm_program · mr-noti-bot 모두 **v0.5.0** (전부 커밋 완료)

### 주의사항

- **배포 프로젝트 2곳이 미푸시 상태** — NDT-BPE_pork(`92ceb63`), mr-noti-bot(`2cde216`)는
  로컬 커밋만 되어 있다. 각 프로젝트에서 push 여부를 판단할 것.
  aralm_program은 remote 자체가 없다
- **에이전트 이름 변경은 breaking change** — `adt:Designer Agent` → `adt:designer`.
  저장소 내부 참조와 배포 프로젝트 3개 모두 정리 완료
- **플랫폼 계층 blueprint 3개는 런타임 의존** — 각 파일 상단에 "검증 버전: v2.1.220"을 명시했다.
  Claude Code 업그레이드 시 함께 갱신할 것
- **`memory` 필드는 의도적으로 켜지 않았다** — 에이전트별 auto memory는 디스크에 학습을 누적하므로
  프로젝트별 합의 후 활성화하도록 blueprint에 옵션으로만 문서화
- **web_hook_server** — 2026-07-26 재확인 결과 로컬에 없음. registry에 취소선으로 표시,
  다음 확인에서도 없으면 행 삭제
- **다른 워크스테이션 미배포** — pink-turtle-rt, pink-turtle-win은 v0.3.0 상태.
  v0.5.0에서 글로벌 rule이 하나 늘었으므로 defconfig 재실행 필요
- **`/adt:project-update`에 커밋 단계가 없다** — 이번에 4월 배포분이 3개 프로젝트 모두
  미커밋으로 방치된 걸 발견했다. 스킬에 "변경 후 커밋 제안" 단계를 넣을지 검토 필요
- **로컬에 머지된 `feat/cc-2.1.220-modernize` 브랜치 잔존** — squash 머지라 git이 미머지로
  판단한다. 내용은 main과 동일(diff 없음). `git branch -D`로 삭제 가능

### 다음 작업 후보

1. **이 브랜치(`docs/v0.5.0-propagation`) PR → main 머지** ← 최우선
2. **배포 프로젝트 2곳 push 판단** — NDT-BPE_pork, mr-noti-bot 로컬 커밋 미푸시
3. **다른 워크스테이션 defconfig 재실행** — pink-turtle-rt, pink-turtle-win (글로벌 rule 5개로 증가)
4. **`/adt:project-update`에 커밋 단계 추가 검토** — 이번 세션에서 드러난 기록↔실제 괴리 원인
5. **SessionStart 훅 구현** — blueprints 핵심 규칙 컨텍스트 주입 (v0.4.x부터 이월)
6. **web_hook_server registry 행 삭제 판단**

### 학습 사항

- **훅은 조용히 실패한다.** `$CLAUDE_FILE_PATH`가 빈 문자열이면 스크립트가 `exit 0`으로 빠져나가
  아무 경고도 남기지 않는다. 3개월간 무동작이었던 걸 이번 조사 전까지 알아채지 못했다.
  → **훅은 배포 전에 실제 JSON을 파이프해서 검증한다**는 규칙을 `blueprints/hooks.md`에 명문화
- **문서와 실제 설정의 괴리**: `implementer`는 "worktree 격리"라고 문서에 적혀 있었지만
  `isolation` 필드가 없어 격리되지 않았다. 문서에 쓴 동작은 **설정으로 강제되는지 확인**해야 한다
- **런타임 의존 지식에는 검증 버전을 박아둔다.** 도구 무관 blueprint(코딩 표준 등)와 달리
  플랫폼 계층은 3개월이면 낡는다. 파일 상단 버전 명시가 다음 세션의 갱신 판단 근거가 된다
- **정기 동향 점검이 필요하다.** 3개월 공백 동안 스펙 위반 2건이 누적됐다.
  릴리스마다 changelog를 훑는 루틴이 있었다면 조기에 잡혔을 것

- **배포 기록과 실제 저장소 상태는 별개다.** 4월 HANDOFF에 "3개 프로젝트 업데이트 완료"라고
  적혀 있었지만 실제로는 파일만 바뀌고 **한 곳도 커밋되지 않았다**. aralm_program은 커밋 자체가
  없었다. → 배포 작업의 완료 판정은 "파일 변경"이 아니라 **"커밋 존재"**로 해야 한다
- **플러그인 전환 후 로컬 복제본은 부채가 된다.** v0.4.0에서 플러그인으로 옮긴 뒤에도 프로젝트에
  구 사본이 남아 있었고, v0.5.0의 에이전트 이름 변경으로 스펙 위반 정의가 중복 등록되는
  상태가 됐다. 전환 시점에 정리했어야 할 일이 3개월 뒤 더 큰 문제로 돌아왔다

### 현재 저장소 구조

> 상세 구조는 `docs/project-structure.md` 참조.

```
ai-dev-toolkit/                     ← Claude Code 플러그인 (adt)
├── .claude-plugin/
│   ├── plugin.json                 ← 매니페스트 (v0.5.0, engines >=2.1.202)
│   └── marketplace.json
├── package.json
├── skills/ (11개)                  ← 스킬 (adt: 접두사)
├── agents/ (12개)                  ← 에이전트 파이프라인 (kebab-case name)
├── templates/ (4개)                ← 문서 템플릿
├── hooks/                          ← 플러그인 훅 (stdin JSON 계약)
│   ├── hooks.json
│   └── post-edit-check.sh
├── blueprints/ (9개)               ← 공유 지식
│   └── agent-runtime.md / memory-and-context.md / hooks.md   ← 플랫폼 계층 (신규)
├── claude/                         ← 배포용 템플릿 (하위 호환)
├── .claude/rules/                  ← 이 프로젝트 자체 규칙 (글로벌 5 + 프로젝트 3)
├── docs/
│   ├── 01-plan/ 02-design/ 03-analysis/ 04-report/   ← PDCA 산출물
│   ├── project-structure.md
│   └── usage-guide.md
├── workstations/
├── VERSION                         ← 0.5.0
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

| 별칭 | 환경 | 상태 파일 | defconfig 최종 실행일 | 라이브러리 버전 |
|------|------|----------|---------------------|----------------|
| pink-turtle | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle.json` | 2026-04-12 | v0.5.0 |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle-rt.json` | 2026-03-24 | v0.3.0 |
| pink-turtle-win | MINGW64 (Git Bash, Win11) | `workstations/pink-turtle-win.json` | 2026-03-26 | v0.3.0 |
