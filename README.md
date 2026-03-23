# My AI Manual

AI 코딩 어시스턴트의 지침 라이브러리이자 플랫폼 도구.
워크스테이션 세팅부터 프로젝트 초기화까지 자동화된 흐름을 제공한다.

---

## 사용 흐름

```
1. 워크스테이션에 클론
   git clone <repo-url> ~/my_ai_manual

2. 워크스테이션 환경 구성 (최초 1회)
   /ai-platform-defconfig
   → 심볼릭 링크, 패키지, MCP 등 세팅

3. 새 프로젝트 초기화
   /project-init <target-path>
   → 타겟 디렉토리에 AI 설정 골격 복제

4. 프로젝트 설정 구체화
   /project-configure
   → 대화형으로 기술 스택, 모듈 구조, 컨벤션 채움
```

---

## 스킬

| 스킬 | 역할 |
|------|------|
| `/ai-platform-defconfig` | 워크스테이션 환경 구성 (사용자 정보, 경로, 패키지, MCP, 심볼릭 링크) |
| `/project-init` | 타겟 디렉토리에 CLAUDE.md, .claude/ 등 골격 복제 |
| `/project-configure` | 복제된 템플릿을 대화형으로 프로젝트에 맞게 구체화 |

---

## 디렉토리 구조

```
My_AI_manual/
├── .claude/skills/        # 스킬 (이 저장소의 핵심 기능)
├── blueprints/            # 도구 무관 공유 지식 (Single Source of Truth)
├── claude/                # Claude Code 지침 및 템플릿
├── workstations/          # 워크스테이션별 환경 상태 (defconfig 결과)
├── cursor/                # Cursor (추후 확장)
├── copilot/               # GitHub Copilot (추후 확장)
├── windsurf/              # Windsurf (추후 확장)
├── CLAUDE.md              # 이 저장소의 프로젝트 규칙
├── HANDOFF.md             # 세션 간 인수인계
└── TOOL_REFERENCE.md      # 도구별 설정 파일 매핑
```

- **`blueprints/`** — 모든 도구가 참조하는 공통 지식 (코딩 표준, Git 워크플로우, 설계 원칙 등)
- **도구별 디렉토리** — blueprints를 해당 도구 형식에 맞게 변환한 지침

---

## 환경

- Windows + WSL2 (주 개발환경)
- 원격 서버 SSH
- 주요 도메인: C/C++ 임베디드 시스템

---

## 새 도구 추가

1. 루트에 도구명으로 디렉토리 생성 (예: `aider/`)
2. `README.md` 작성 — 설정 형식, 배포 위치, 사용법
3. `TOOL_REFERENCE.md`에 매핑 정보 추가
4. 지침 파일 작성

배포 위치 상세는 [`TOOL_REFERENCE.md`](TOOL_REFERENCE.md) 참조.
