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
│   ├── skills/            # ▼ 스킬 (이 저장소의 핵심 기능)
│   │   ├── ai-platform-defconfig/SKILL.md
│   │   ├── project-init/SKILL.md
│   │   ├── project-configure/SKILL.md
│   │   ├── project-update/SKILL.md
│   │   ├── project-absorb/SKILL.md
│   │   └── optimize-docs/SKILL.md
│   └── settings.local.json
│
├── docs/                  # ▼ 사용 가이드 및 산출물
│   ├── usage-guide.md     #   스킬별 상세 사용법 + FAQ
│   └── project-structure.md # 이 파일 (구조 참조)
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
│   ├── global_CLAUDE.md   #   글로벌 규칙 (defconfig가 심볼릭 링크 관리)
│   ├── project_CLAUDE.md  #   프로젝트 규칙 템플릿 (project-init이 복제)
│   └── README.md
├── workstations/          # ▼ 워크스테이션별 환경 상태 + 배포 추적
│   ├── README.md
│   ├── registry.md        #   전체 현황 인덱스
│   ├── <alias>.json       #   공개 환경 상태 (커밋)
│   └── <alias>.local.json #   로컬 전용: hostname, 경로, 배포 목록 (gitignore)
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
- `claude/global_CLAUDE.md`는 blueprints 1~3절을 인라인 포함
