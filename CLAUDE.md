# My_AI_manual — 프로젝트 규칙
> 이 파일은 Claude Code가 이 저장소에서 작업할 때 참조하는 프로젝트 규칙입니다.
> 글로벌 규칙(`~/.claude/CLAUDE.md`)을 상속하며, 이 파일의 규칙이 우선합니다.

---

## 0. 인수인계

**새 세션 시작 시 [`HANDOFF.md`](HANDOFF.md)를 먼저 읽는다.**
이전 세션의 작업 내용, 현재 상태, 다음 작업 후보가 기록되어 있다.
작업 완료 시 `HANDOFF.md`를 갱신하고 커밋한다.

---

## 1. 저장소 개요

AI 코딩 어시스턴트의 **지침 라이브러리이자 플랫폼 도구**.
워크스테이션 세팅부터 프로젝트 초기화까지 3개 스킬로 자동화된 흐름을 제공한다.

### 핵심 흐름
```
워크스테이션 클론 → /ai-platform-defconfig (1회)
                        ↓
              새 프로젝트마다 → /project-init → /project-configure
```

### 스킬
| 스킬 | 위치 | 역할 |
|------|------|------|
| `/ai-platform-defconfig` | `.claude/skills/ai-platform-defconfig/` | 워크스테이션 환경 구성 (심볼릭 링크, 패키지, MCP 등) |
| `/project-init` | `.claude/skills/project-init/` | 타겟 디렉토리에 AI 설정 골격 복제 |
| `/project-configure` | `.claude/skills/project-configure/` | 대화형으로 프로젝트 설정 구체화 |

### 디렉토리 구조
```
My_AI_manual/
├── CLAUDE.md              ← 이 파일 (프로젝트 규칙)
├── README.md              # 저장소 소개 및 사용법
├── HANDOFF.md             # 세션 간 인수인계
├── TOOL_REFERENCE.md      # 도구별 설정 파일 매핑
│
├── .claude/
│   ├── skills/            # ▼ 스킬 (이 저장소의 핵심 기능)
│   │   ├── ai-platform-defconfig/SKILL.md
│   │   ├── project-init/SKILL.md
│   │   └── project-configure/SKILL.md
│   └── settings.local.json
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
├── cursor/                #   Cursor (추후 확장)
├── copilot/               #   GitHub Copilot (추후 확장)
└── windsurf/              #   Windsurf (추후 확장)
```

### 계층 구조

**blueprints/** — 도구 무관 공유 지식의 원본(Single Source of Truth)
- 모든 도구의 지침이 여기서 파생됨
- `project-configure` 스킬이 프로젝트 특성에 맞는 blueprint를 선택하여 적용

**도구별 디렉토리** — blueprints를 도구 형식에 맞게 변환한 배포판
- `claude/global_CLAUDE.md`는 blueprints 1~3절을 인라인 포함

### 디렉토리 탐색 규칙
새 디렉토리에 진입할 때는 다음 순서를 따른다:
1. 해당 디렉토리에 `README.md`가 있는지 확인
2. **있으면** → `README.md`를 먼저 읽고 그 안내에 따라 작업 진행
3. **없으면** → 상위 디렉토리의 `README.md`를 참조

---

## 2. 파일 편집 규칙

### 2.1 문서 작성 언어
- **한국어** 기본 (코드, 명령어, 기술 용어, 파일 경로는 영어 그대로)
- 도구 지침 파일 내 규칙 설명도 한국어

### 2.2 파일 형식
- 인코딩: UTF-8, LF 줄바꿈 (CRLF 금지)
- Markdown 형식 준수
- 각 도구의 지침 파일은 해당 도구가 요구하는 형식을 따름:
  - Claude Code: 표준 Markdown (스킬은 YAML frontmatter 포함)
  - Cursor: MDC (Markdown + YAML frontmatter)
  - Copilot: Markdown (glob 패턴 frontmatter)
  - Windsurf: Markdown (파일당 12,000자 제한)

### 2.3 지침 파일 수정 시 주의사항
- 글로벌 규칙(`global_CLAUDE.md`) 수정은 **모든 프로젝트에 영향** — 신중하게
- 새 섹션 추가 시 기존 섹션 번호 체계 유지
- 도구 공통 내용은 `blueprints/`로 분리 가능성을 고려
- `TOOL_REFERENCE.md` 변경 시 해당 도구의 README.md도 함께 갱신

### 2.4 스킬 수정 시 주의사항
- 스킬 파일은 `.claude/skills/<name>/SKILL.md`에 위치
- YAML frontmatter의 `allowed-tools`, `description` 변경은 동작에 직접 영향
- 스킬이 참조하는 템플릿 파일(`claude/project_CLAUDE.md` 등)과 동기화 유지

---

## 3. 배포 및 동기화

이 저장소는 **스킬을 통해 배포를 자동화**한다.

### 3.1 배포 방식
| 대상 | 스킬 | 방식 |
|------|------|------|
| 글로벌 규칙 (`~/.claude/CLAUDE.md`) | `/ai-platform-defconfig` | 심볼릭 링크 생성/갱신 |
| 프로젝트 규칙 (`<project>/CLAUDE.md`) | `/project-init` | 템플릿 복제 |
| 프로젝트 구체화 | `/project-configure` | 대화형 placeholder 채움 |

### 3.2 수동 배포 (스킬 미사용 시)
```bash
# 글로벌 규칙 심볼릭 링크
ln -sf $(pwd)/claude/global_CLAUDE.md ~/.claude/CLAUDE.md

# 프로젝트 규칙 복제
cp claude/project_CLAUDE.md <project-root>/CLAUDE.md
```

### 3.3 다른 도구 배포
각 도구 디렉토리의 `README.md`에 배포 방법이 기재되어 있다.
새 도구 지침 추가 시:
1. 도구 디렉토리에 지침 파일 작성
2. 도구 디렉토리 `README.md`에 배포 방법 기재
3. `TOOL_REFERENCE.md`에 매핑 정보 추가

---

## 4. 이 저장소에서의 작업 원칙

### 4.1 역할 인식
이 저장소는 **AI 도구 지침의 라이브러리이자 플랫폼 도구**다.
- 글로벌 규칙의 임베디드 C/C++ 관련 섹션은 이 저장소 자체에는 적용하지 않는다
- 여기서 작성하는 지침은 **다른 프로젝트에서 AI가 참조할 기반**이 된다는 점을 항상 의식한다
- 스킬은 **실제 사용하면서 점진적으로 구체화**한다 — 완벽하게 만들고 배포하는 방식이 아님

### 4.2 골격 유지 원칙
- 지침은 **방향과 원칙** 수준으로 작성한다 — 지나치게 구체적인 프로젝트별 내용은 넣지 않는다
- 프로젝트에서 확장/오버라이드할 수 있는 여지를 남긴다
- 예시를 포함하되, 특정 프로젝트에 종속되지 않는 범용적인 예시를 사용한다
- 하나의 지침이 여러 도구에 공통이면 `blueprints/`에, 특정 도구 전용이면 해당 도구 디렉토리에 배치한다

### 4.3 변경 영향 인식
- `blueprints/` 수정 → 모든 도구의 지침에 영향 가능
- `claude/global_CLAUDE.md` 수정 → 심볼릭 링크로 **모든 프로젝트에 즉시 반영**
- `.claude/skills/` 수정 → 이 저장소에서 실행하는 스킬에 즉시 반영
- 영향 범위가 큰 변경은 사전에 변경 의도와 영향 범위를 설명한 후 진행

### 4.4 커밋 규칙
- Conventional Commits 형식 준수
- 타입: `docs` (지침 내용 변경), `chore` (구조/배포 변경), `feat` (새 스킬/새 지침 파일 추가)
- 예시: `feat(skills): ai-platform-defconfig 스킬 추가`

### 4.5 일관성 유지
- 새 지침 파일 작성 시 기존 파일의 톤, 구조, 형식을 따른다
- 도구 디렉토리 추가 시 `README.md`를 반드시 포함한다
- `TOOL_REFERENCE.md`와 각 도구 `README.md`의 정보를 동기화 상태로 유지한다

---

*이 파일은 `My_AI_manual` 저장소 루트에 위치하며, Claude Code가 이 저장소 작업 시 자동 참조합니다.*
