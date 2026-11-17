# 프로젝트 구조 참조

이 문서는 `CLAUDE.md`에서 분리된 저장소 구조 참조 문서다.
AI가 저장소 탐색 시 오리엔테이션용으로 사용한다.

---

## 스킬 (10개)

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
| `/adt:decision` | `skills/decision/` | ADR 생성/조회 (아키텍처 결정 기록) |

---

## 에이전트 (1개)

개발 절차(구체화 → 설계 → 구현 → 검토)를 수행하는 에이전트는 두지 않는다 — `superpowers` 플러그인에 맡긴다
([ADR-002](decisions/ADR-002-slim-down-delegate-process-to-superpowers.md)).
호출 시에는 플러그인 네임스페이스가 붙는다 — `adt:gap-detector`.

| 에이전트 | 위치 | 역할 | 모델 | effort |
|---------|------|------|------|--------|
| `gap-detector` | `agents/gap-detector.md` | 설계 문서 ↔ 구현 매칭율 측정 | opus | high |

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
├── skills/ (10개)                  # ▼ 플러그인 스킬
│   ├── ai-platform-defconfig/SKILL.md
│   ├── project-init/SKILL.md
│   ├── project-configure/SKILL.md
│   ├── project-update/SKILL.md
│   ├── project-absorb/SKILL.md
│   ├── optimize-docs/SKILL.md
│   ├── handoff/SKILL.md            #   (커맨드→스킬 변환)
│   ├── sync-check/SKILL.md
│   ├── doc-gen/SKILL.md
│   └── decision/SKILL.md
│
├── agents/ (1개)                   # ▼ 플러그인 에이전트
│   └── gap-detector.md
│
├── templates/ (1개)                # ▼ 문서 템플릿
│   └── decision.template.md        #   /adt:decision이 사용
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
├── docs/                           # ▼ 사용 가이드 및 문서
│   ├── usage-guide.md
│   ├── project-structure.md        #   이 파일
│   ├── decisions/                  #   ADR 시스템
│   ├── superpowers/                #   설계서(specs/) · 구현 계획(plans/)
│   └── archive/                    #   완료된 작업 문서 월별 보관
│
├── workstations/                   # ▼ 워크스테이션 환경 상태 + 배포 추적
├── CLAUDE.md                       # 프로젝트 규칙
├── HANDOFF.md                      # 세션 간 인수인계
├── VERSION
├── LICENSE
└── CHANGELOG.md
```

---

## 계층 구조

**blueprints/** — 도구 무관 공유 지식의 원본(Single Source of Truth)
- 모든 도구의 지침이 여기서 파생됨
- `project-configure` 스킬이 프로젝트 특성에 맞는 blueprint를 선택하여 적용

**skills/** — 플러그인 스킬 (실행 가능한 액션)
- `adt:` 네임스페이스로 호출 (예: `/adt:project-init`)

**agents/** — 플러그인 에이전트
- `adt:` 네임스페이스로 노출. 다른 도구가 대신하지 못하는 것만 둔다

**templates/** — 문서 템플릿
- 스킬이 참조하여 문서 생성
