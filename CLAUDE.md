# My_AI_manual — 프로젝트 규칙
> 이 파일은 Claude Code가 이 저장소에서 작업할 때 참조하는 프로젝트 규칙입니다.
> 글로벌 규칙(`~/.claude/CLAUDE.md`)을 상속하며, 이 파일의 규칙이 우선합니다.

---

## 1. 저장소 개요

AI 코딩 어시스턴트(Claude Code, Cursor, Copilot, Windsurf)의 **기본 골격과 동작 방향**을 관리하는 저장소.
각 프로젝트의 세부 규칙은 해당 프로젝트에서 정의하며, 이 저장소는 그 기반이 되는 공통 지식과 템플릿을 제공한다.
**2계층 구조**: 공유 기반 지식(`_shared/`) 위에 도구별 지침(`claude/`, `cursor/` 등)을 쌓는다.

### 디렉토리 구조
```
My_AI_manual/
├── CLAUDE.md              ← 이 파일 (프로젝트 규칙)
├── README.md              # 저장소 소개
├── TOOL_REFERENCE.md      # 도구별 설정 파일 매핑 레퍼런스
│
├── _shared/               # ▼ 계층 1: 도구 무관 공유 지식
│   ├── README.md          #   이 계층의 구조와 확장 계획
│   └── (개별 파일은 위 테이블 참조 — 순차 작성 예정)
│
├── claude/                # ▼ 계층 2: 도구별 지침
│   ├── global_CLAUDE.md   #   → ~/.claude/CLAUDE.md (심볼릭 링크)
│   ├── project_CLAUDE.md  #   → <project>/CLAUDE.md (템플릿)
│   └── README.md
├── cursor/                #   Cursor (.mdc 형식)
├── copilot/               #   GitHub Copilot
└── windsurf/              #   Windsurf
```

### 계층 구조와 파일 역할

**계층 1 — `_shared/` (도구 무관 공유 지식)**
| 파일 | 역할 | 상태 |
|------|------|------|
| `base-directives.md` | AI 도구 종류 무관 기본 지침 (응답 언어, 커뮤니케이션 규칙 등) | 미작성 |
| `environment.md` | 환경 감지 및 적응 (WSL2, SSH, 로컬) | 미작성 (현재 `global_CLAUDE.md` 1절에 포함) |
| `design-principles.md` | 설계 우선 원칙 (설계 의도 설명, 대안 제안, 문서 산출, 기술 부채) | 미작성 (현재 `global_CLAUDE.md` 3절에 포함) |
| `coding-standards.md` | C/C++ 임베디드 코딩 표준 | ✅ 분리 완료 |
| `git-workflow.md` | Git 브랜치/커밋/워크트리 규칙 | ✅ 분리 완료 |
| `build-environment.md` | 크로스 컴파일, 빌드 산출물 구조 | ✅ 분리 완료 |

**계층 2 — 도구별 디렉토리**
| 파일 | 역할 |
|------|------|
| `claude/global_CLAUDE.md` | Claude Code 글로벌 규칙 원본 (`_shared/` 내용을 Claude 형식으로 통합) |
| `claude/project_CLAUDE.md` | 프로젝트별 규칙 템플릿 (placeholder 채워서 사용) |
| `TOOL_REFERENCE.md` | 도구별 소스→배포 위치 매핑 정보 |

> **관계**: `_shared/`는 지식의 원본(Single Source of Truth). 도구별 지침은 `_shared/`를 참조하거나 도구 형식에 맞게 변환하여 사용한다. 현재는 `claude/global_CLAUDE.md`가 `_shared/` 내용을 직접 포함하고 있으며, 향후 분리 예정.

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
  - Claude Code: 표준 Markdown
  - Cursor: MDC (Markdown + YAML frontmatter)
  - Copilot: Markdown (glob 패턴 frontmatter)
  - Windsurf: Markdown (파일당 12,000자 제한)

### 2.3 지침 파일 수정 시 주의사항
- 글로벌 규칙(`global_CLAUDE.md`) 수정은 **모든 프로젝트에 영향** — 신중하게
- 새 섹션 추가 시 기존 섹션 번호 체계 유지
- 도구 공통 내용은 `_shared/`로 분리 가능성을 고려
- `TOOL_REFERENCE.md` 변경 시 해당 도구의 README.md도 함께 갱신

---

## 3. 배포 및 동기화

이 저장소는 **기본 골격과 동작 방향**을 제공한다.
각 프로젝트의 세부 규칙은 해당 프로젝트 워크스페이스에서 정의하며, 여기서는 그 기반만 잡아준다.

### 3.1 현재 배포 상태
| 소스 | 배포 위치 | 방식 | 상태 |
|------|-----------|------|------|
| `claude/global_CLAUDE.md` | `~/.claude/CLAUDE.md` | 심볼릭 링크 | ✅ 활성 |
| `claude/project/` | 각 프로젝트 `<root>/.claude/` | 골격 복사 후 프로젝트별 확장 | 구조 설계 중 |

### 3.2 Claude Code 배포

**글로벌 규칙** — 동작 방향의 기본 배경 (설정 완료):
```bash
ln -sf ~/My_AI_manual/claude/global_CLAUDE.md ~/.claude/CLAUDE.md
```

**프로젝트 규칙** — 골격 제공, 세부는 프로젝트에서 정의:
프로젝트별 Claude 설정은 `.claude/` 하위 계층 구조로 배포한다.
이 저장소에서는 시작점이 되는 골격 구조(서브에이전트 기본 구조, 코드 컨벤션 템플릿 등)를 제공하고,
프로젝트 고유 내용(타겟 보드, 모듈 구조, 서브에이전트 구체화, 프로젝트별 컨벤션 확장 등)은 각 프로젝트에서 채운다.
구체적 구조는 `claude/README.md`에서 정의한다.

### 3.3 다른 도구 배포
각 도구 디렉토리의 `README.md`에 배포 방법이 기재되어 있다.
새 도구 지침 추가 시:
1. 도구 디렉토리에 지침 파일 작성
2. 도구 디렉토리 `README.md`에 배포 방법 기재
3. `TOOL_REFERENCE.md`에 매핑 정보 추가

---

## 4. 이 저장소에서의 작업 원칙

### 4.1 역할 인식
이 저장소는 코드 프로젝트가 아니라 **AI 동작의 기반 골격을 관리하는 지식 저장소**다.
- 글로벌 규칙의 임베디드 C/C++ 관련 섹션(4~6절)은 이 저장소 자체에는 적용하지 않는다
- 여기서 작성하는 지침은 **다른 프로젝트에서 AI가 참조할 기반**이 된다는 점을 항상 의식한다

### 4.2 골격 유지 원칙
- 지침은 **방향과 원칙** 수준으로 작성한다 — 지나치게 구체적인 프로젝트별 내용은 넣지 않는다
- 프로젝트에서 확장/오버라이드할 수 있는 여지를 남긴다
- 예시를 포함하되, 특정 프로젝트에 종속되지 않는 범용적인 예시를 사용한다
- 하나의 지침이 여러 도구에 공통이면 `_shared/`에, 특정 도구 전용이면 해당 도구 디렉토리에 배치한다

### 4.3 변경 영향 인식
- `_shared/` 수정 → 모든 도구의 지침에 영향 가능
- `claude/global_CLAUDE.md` 수정 → 심볼릭 링크로 **모든 프로젝트에 즉시 반영**
- 영향 범위가 큰 변경은 사전에 변경 의도와 영향 범위를 설명한 후 진행
- 변경 후 심볼릭 링크가 정상 동작하는지 확인한다

### 4.4 커밋 규칙
- Conventional Commits 형식 준수
- 타입: `docs` (지침 내용 변경), `chore` (구조/배포 변경), `feat` (새 도구/새 지침 파일 추가)
- 예시: `docs(claude): 글로벌 규칙 Git 섹션 보강`

### 4.5 일관성 유지
- 새 지침 파일 작성 시 기존 파일의 톤, 구조, 형식을 따른다
- 도구 디렉토리 추가 시 `README.md`를 반드시 포함한다
- `TOOL_REFERENCE.md`와 각 도구 `README.md`의 정보를 동기화 상태로 유지한다

---

*이 파일은 `My_AI_manual` 저장소 루트에 위치하며, Claude Code가 이 저장소 작업 시 자동 참조합니다.*
