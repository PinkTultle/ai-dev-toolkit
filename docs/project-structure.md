# 프로젝트 구조 참조

이 문서는 `CLAUDE.md`에서 분리된 저장소 구조 참조 문서다.
AI가 저장소 탐색 시 오리엔테이션용으로 사용한다.

---

## 스킬

| 스킬 | 위치 | 역할 |
|------|------|------|
| `/ai-platform-defconfig` | `.claude/skills/ai-platform-defconfig/` | 워크스테이션 환경 구성 (심볼릭 링크, 패키지, MCP 등) |
| `/project-init` | `.claude/skills/project-init/` | 타겟 디렉토리에 AI 설정 골격 복제 + 배포 추적 |
| `/project-configure` | `.claude/skills/project-configure/` | 대화형으로 프로젝트 설정 구체화 |
| `/project-update` | `.claude/skills/project-update/` | 라이브러리 최신 버전을 프로젝트에 적용 |
| `/project-absorb` | `.claude/skills/project-absorb/` | 프로젝트에서 발전한 지침을 라이브러리로 흡수 |
| `/optimize-docs` | `.claude/skills/optimize-docs/` | 지침 파일 200줄 제한 검사 및 최적화 |

---

## 커맨드

| 커맨드 | 위치 | 역할 |
|--------|------|------|
| `/handoff` | `.claude/commands/handoff.md` | 세션 종료 시 HANDOFF.md 갱신 + 커밋 + 푸시 |
| `/sync-check` | `.claude/commands/sync-check.md` | blueprints ↔ rules 동기화 상태 점검 |
| `/doc-gen` | `.claude/commands/doc-gen.md` | 소스 파일의 코드 설명 문서 자동 생성/갱신 |
| `/review` | `.claude/commands/review.md` | 변경사항 코드 리뷰 (보안/성능/가독성/규칙) |
| `/decision` | `.claude/commands/decision.md` | ADR 생성/조회 (아키텍처 결정 기록) |

---

## 디렉토리 구조

```
ai-dev-toolkit/
├── CLAUDE.md              ← 이 파일 (프로젝트 규칙)
├── README.md              # 저장소 소개 및 사용법
├── HANDOFF.md             # 세션 간 인수인계
├── TOOL_REFERENCE.md      # 도구별 설정 파일 매핑
├── VERSION                # 현재 라이브러리 버전
├── VERSIONING.md          # 버전 정책 정의
├── CHANGELOG.md           # 버전별 변경 이력
│
├── .claude/
│   ├── agents/            # ▼ 서브에이전트 정의 (11개)
│   │   ├── ideation.md    #     파이프라인: 아이디어 구체화 (sonnet)
│   │   ├── product-manager.md #  파이프라인: 요구사항 구조화 (opus)
│   │   ├── designer.md    #     파이프라인: 설계 (opus)
│   │   ├── design-validator.md # 검증: 설계 완성도 판정 (sonnet)
│   │   ├── reviewer.md    #     파이프라인: 설계 검토 (opus)
│   │   ├── implementer.md #     파이프라인: 구현 (opus, worktree)
│   │   ├── verifier.md    #     파이프라인: 구현 검증 (sonnet)
│   │   ├── gap-detector.md #    검증: 설계↔구현 매칭율 측정 (sonnet)
│   │   ├── code-analyzer.md #   검증: 코드 품질 심층 분석 (sonnet)
│   │   ├── tester.md      #     파이프라인: 테스트 (sonnet)
│   │   ├── report-generator.md # 보고: 완료 보고서 생성 (sonnet)
│   │   └── cto-lead.md    #     조율: Large 팀 오케스트레이션 (opus)
│   ├── rules/             # ▼ 세부 규칙 파일 (Claude Code 자동 로드)
│   │   ├── global-*.md    #     글로벌 rules (defconfig이 ~/.claude/rules/에 배포)
│   │   └── project-*.md   #     프로젝트 rules 템플릿 (project-configure가 선택 복제)
│   ├── commands/          # ▼ 커스텀 슬래시 커맨드
│   │   ├── handoff.md     #     세션 종료 인수인계 자동화
│   │   ├── sync-check.md  #     blueprints↔rules 동기화 점검
│   │   ├── doc-gen.md     #     코드 설명 문서 자동 생성
│   │   ├── review.md      #     코드 리뷰 (보안/성능/가독성)
│   │   └── decision.md    #     ADR 생성/조회
│   ├── templates/         # ▼ 문서 템플릿 (에이전트/커맨드가 참조)
│   │   ├── plan.template.md      # Plan 산출물 템플릿
│   │   ├── design.template.md    # Design 산출물 템플릿
│   │   ├── report.template.md    # Report 산출물 템플릿
│   │   └── decision.template.md  # ADR 템플릿
│   ├── hooks/             # ▼ Hook 스크립트
│   │   └── post-edit-check.sh    # 지침 파일 줄 수 검사
│   ├── skills/            # ▼ 스킬 (이 저장소의 핵심 기능)
│   │   ├── ai-platform-defconfig/SKILL.md
│   │   ├── project-init/SKILL.md
│   │   ├── project-configure/SKILL.md
│   │   ├── project-update/SKILL.md
│   │   ├── project-absorb/SKILL.md
│   │   └── optimize-docs/SKILL.md
│   ├── settings.json      #   팀 공유 설정 (deny, hooks)
│   └── settings.local.json #  로컬 전용 설정 (gitignore)
│
├── docs/                  # ▼ 사용 가이드 및 산출물
│   ├── usage-guide.md     #   스킬별 상세 사용법 + FAQ
│   ├── project-structure.md # 이 파일 (구조 참조)
│   └── decisions/         # ▼ ADR (Architecture Decision Records)
│       └── ADR-001-*.md   #   rkit 패턴 채택 결정
│
├── blueprints/            # ▼ 도구 무관 공유 지식 (Single Source of Truth)
│   ├── base-directives.md #   AI 공통 기본 지침
│   ├── environment.md     #   환경 감지 및 적응
│   ├── design-principles.md # 설계 우선 원칙
│   ├── coding-standards.md  # C/C++ 코딩 표준
│   ├── git-workflow.md    #   Git 워크플로우
│   ├── build-environment.md # 빌드 환경
│   └── README.md
│
├── claude/                # ▼ Claude Code 도구별 지침
│   ├── global_CLAUDE.md   #   글로벌 규칙 인덱스 (defconfig가 심볼릭 링크 관리)
│   ├── project_CLAUDE.md  #   프로젝트 규칙 템플릿 (project-init이 복제)
│   └── README.md
├── workstations/          # ▼ 워크스테이션별 환경 상태 + 배포 추적
│   ├── README.md
│   ├── registry.md        #   전체 현황 인덱스
│   ├── <alias>.json       #   공개 환경 상태 (커밋)
│   └── <alias>.local.json #   로컬 전용: hostname, 경로, 배포 목록 (gitignore)
├── .github/
│   └── workflows/
│       └── claude.yml     #   @claude PR 자동화 워크플로우
├── cursor/                #   Cursor (추후 확장)
├── copilot/               #   GitHub Copilot (추후 확장)
└── windsurf/              #   Windsurf (추후 확장)
```

---

## 계층 구조

**blueprints/** — 도구 무관 공유 지식의 원본(Single Source of Truth)
- 모든 도구의 지침이 여기서 파생됨
- `project-configure` 스킬이 프로젝트 특성에 맞는 blueprint를 선택하여 적용

**도구별 디렉토리** — blueprints를 도구 형식에 맞게 변환한 배포판
- `claude/global_CLAUDE.md`는 rules 인덱스 + 기술 표준 참조 테이블
- `.claude/rules/`는 blueprints를 Claude Code `paths` frontmatter 포함 형태로 변환한 파생물
