# 프로젝트 구조 참조

이 문서는 `CLAUDE.md`에서 분리된 저장소 구조 참조 문서다.
AI가 저장소 탐색 시 오리엔테이션용으로 사용한다.

---

## 스킬 (11개)

| 스킬 | 위치 | 역할 |
|------|------|------|
| `/adt:ai-platform-defconfig` | `skills/ai-platform-defconfig/` | 워크스테이션 환경 구성 (심볼릭 링크, 패키지, MCP 등) |
| `/adt:project-init` | `skills/project-init/` | 타겟 디렉토리에 AI 설정 골격 복제 + 배포 추적 |
| `/adt:project-configure` | `skills/project-configure/` | 대화형으로 프로젝트 설정 구체화 |
| `/adt:project-update` | `skills/project-update/` | 라이브러리 최신 버전을 프로젝트에 적용 |
| `/adt:project-absorb` | `skills/project-absorb/` | 프로젝트에서 발전한 지침을 라이브러리로 흡수 |
| `/adt:optimize-docs` | `skills/optimize-docs/` | 지침 파일 200줄 제한 검사 및 최적화 |
| `/adt:handoff` | `skills/handoff/` | 세션 종료 시 HANDOFF.md 갱신 + 커밋 + 푸시 |
| `/adt:sync-check` | `skills/sync-check/` | blueprints ↔ rules 동기화 상태 점검 |
| `/adt:doc-gen` | `skills/doc-gen/` | 소스 파일의 코드 설명 문서 자동 생성/갱신 |
| `/adt:review` | `skills/review/` | 변경사항 코드 리뷰 (보안/성능/가독성) |
| `/adt:decision` | `skills/decision/` | ADR 생성/조회 (아키텍처 결정 기록) |

---

## 에이전트 (12개)

에이전트 `name`은 **소문자와 하이픈만** 쓰며 파일명과 일치한다.
호출 시에는 플러그인 네임스페이스가 붙는다 — 예: `adt:designer`.

| 에이전트 | 위치 | 역할 | 모델 | effort | 격리 |
|---------|------|------|------|--------|------|
| `ideation` | `agents/ideation.md` | 아이디어 구체화 | sonnet | - | - |
| `product-manager` | `agents/product-manager.md` | 요구사항 구조화 | opus | - | - |
| `designer` | `agents/designer.md` | 설계 | opus | high | - |
| `design-validator` | `agents/design-validator.md` | 설계 완성도 판정 | opus | high | - |
| `reviewer` | `agents/reviewer.md` | 설계 검토 | opus | high | - |
| `implementer` | `agents/implementer.md` | 구현 | opus | high | **worktree** |
| `verifier` | `agents/verifier.md` | 구현 검증 | sonnet | - | - |
| `gap-detector` | `agents/gap-detector.md` | 설계↔구현 매칭율 측정 | opus | - | - |
| `code-analyzer` | `agents/code-analyzer.md` | 코드 품질 심층 분석 | sonnet | - | - |
| `tester` | `agents/tester.md` | 테스트 | sonnet | - | - |
| `report-generator` | `agents/report-generator.md` | 완료 보고서 생성 | sonnet | - | - |
| `cto-lead` | `agents/cto-lead.md` | Large 팀 오케스트레이션 | opus | - | - |

프론트매터 필드 전체와 실행 모델은 [`blueprints/agent-runtime.md`](../blueprints/agent-runtime.md) 참조.

---

## 디렉토리 구조

```
ai-dev-toolkit/                     ← Claude Code 플러그인 (adt)
├── .claude-plugin/
│   ├── plugin.json                 # 플러그인 매니페스트
│   └── marketplace.json            # 마켓플레이스 메타데이터
├── package.json                    # NPM 메타데이터
│
├── skills/ (11개)                  # ▼ 플러그인 스킬
│   ├── ai-platform-defconfig/SKILL.md
│   ├── project-init/SKILL.md
│   ├── project-configure/SKILL.md
│   ├── project-update/SKILL.md
│   ├── project-absorb/SKILL.md
│   ├── optimize-docs/SKILL.md
│   ├── handoff/SKILL.md            #   (커맨드→스킬 변환)
│   ├── sync-check/SKILL.md
│   ├── doc-gen/SKILL.md
│   ├── review/SKILL.md
│   └── decision/SKILL.md
│
├── agents/ (12개)                  # ▼ 플러그인 에이전트
│   ├── ideation.md ~ cto-lead.md
│
├── templates/ (4개)                # ▼ 문서 템플릿
│   ├── plan.template.md
│   ├── design.template.md
│   ├── report.template.md
│   └── decision.template.md
│
├── hooks/                          # ▼ 플러그인 훅
│   ├── hooks.json
│   └── post-edit-check.sh
│
├── blueprints/ (9개)               # ▼ 도구 무관 공유 지식 (Single Source of Truth)
│   ├── base-directives.md
│   ├── environment.md
│   ├── design-principles.md
│   ├── agent-runtime.md            #   플랫폼 계층 — 에이전트/스킬 실행 모델
│   ├── memory-and-context.md       #   플랫폼 계층 — 지침 계층 + auto memory
│   ├── hooks.md                    #   플랫폼 계층 — 훅 이벤트/계약
│   ├── coding-standards.md
│   ├── git-workflow.md
│   ├── build-environment.md
│   └── README.md
│
├── claude/                         # ▼ 배포용 템플릿 (하위 호환)
│   ├── global_CLAUDE.md
│   ├── project_CLAUDE.md
│   └── README.md
│
├── .claude/
│   └── rules/                      # ▼ 이 프로젝트 자체의 규칙 (플러그인 범위 밖)
│       ├── global-*.md
│       └── project-*.md
│
├── docs/                           # ▼ 사용 가이드 및 산출물
│   ├── usage-guide.md
│   ├── project-structure.md        #   이 파일
│   └── decisions/                  #   ADR 시스템
│
├── workstations/                   # ▼ 워크스테이션 환경 상태 + 배포 추적
├── CLAUDE.md                       # 프로젝트 규칙
├── HANDOFF.md                      # 세션 간 인수인계
├── VERSION                         # 0.6.0
└── CHANGELOG.md
```

---

## 계층 구조

**blueprints/** — 도구 무관 공유 지식의 원본(Single Source of Truth)
- 모든 도구의 지침이 여기서 파생됨
- `project-configure` 스킬이 프로젝트 특성에 맞는 blueprint를 선택하여 적용

**skills/** — 플러그인 스킬 (실행 가능한 액션)
- `adt:` 네임스페이스로 호출 (예: `/adt:project-init`)

**agents/** — 플러그인 에이전트 (서브에이전트 파이프라인)
- `adt:` 네임스페이스로 노출

**templates/** — 산출물 문서 템플릿
- 스킬/에이전트가 참조하여 문서 생성
