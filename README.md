# AI Dev Toolkit

AI 코딩 어시스턴트(Claude Code, Cursor, Copilot 등)의 **지침 라이브러리이자 플랫폼 도구**.

> **현재 버전**: [`VERSION`](VERSION) 참조 | **변경 이력**: [`CHANGELOG.md`](CHANGELOG.md)

---

## 왜 필요한가?

AI 코딩 어시스턴트를 여러 프로젝트에서 사용하다 보면 같은 지침을 반복 작성하게 된다.
이 저장소는 그 문제를 해결한다:

- **한 곳에서 관리** — 코딩 표준, Git 워크플로우, 설계 원칙 등을 `blueprints/`에 모아두고 모든 프로젝트가 참조
- **스킬로 자동화** — 워크스테이션 세팅, 프로젝트 초기화, 설정 구체화를 대화형 명령 하나로 완료
- **양방향 동기화** — 프로젝트에서 발전한 지침을 라이브러리로 흡수하고, 업데이트를 다른 프로젝트에 전파

---

## 전제 조건

| 항목 | 요구사항 |
|------|----------|
| OS | Linux / WSL2 / macOS / **Windows** (Git for Windows 필수) |
| Git | 2.20 이상 |
| Claude Code | CLI 또는 Desktop 설치 완료 ([설치 가이드](https://docs.anthropic.com/en/docs/claude-code)) |
| 패키지 | `jq` (필수), `dos2unix` (WSL2만) |

---

## 빠른 시작

### 1. 클론

**Linux / WSL2 / macOS:**
```bash
git clone <repo-url> ~/ai-dev-toolkit
cd ~/ai-dev-toolkit
```

**Windows (Git Bash):**
```bash
git clone <repo-url> ~/Documents/ai-dev-toolkit
cd ~/Documents/ai-dev-toolkit
```

### 2. 워크스테이션 환경 구성 (최초 1회)

Claude Code에서 실행:
```
/ai-platform-defconfig
```
심볼릭 링크, 패키지 확인, MCP 설정 등을 자동으로 처리한다.

### 3. 프로젝트에 적용

```
/project-init ~/my-project        # AI 설정 골격 복제
/project-configure                 # 대화형으로 기술 스택·컨벤션 구체화
```

> 상세 사용법은 [사용 가이드](docs/usage-guide.md)를 참조한다.

---

## 워크플로우

```
┌─────────────────────────────────────────────────────┐
│                    최초 1회                           │
│  워크스테이션 클론 → /ai-platform-defconfig           │
└────────────────────────┬────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────┐
│                 프로젝트마다                          │
│  /project-init → /project-configure                  │
└────────────────────────┬────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────┐
│                   유지보수                            │
│  /project-absorb ← 프로젝트에서 발전한 지침 흡수       │
│  /project-update → 라이브러리 최신 버전 전파           │
│  /optimize-docs  → 지침 파일 200줄 제한 유지           │
└─────────────────────────────────────────────────────┘
```

---

## 스킬

| 스킬 | 역할 | 실행 시점 |
|------|------|----------|
| `/ai-platform-defconfig` | 워크스테이션 환경 구성 (심볼릭 링크, 패키지, MCP) | 최초 1회 |
| `/project-init` | 타겟 디렉토리에 AI 설정 골격 복제 + 배포 추적 | 프로젝트 시작 시 |
| `/project-configure` | 대화형으로 기술 스택, 모듈 구조, 컨벤션 구체화 | init 직후 |
| `/project-update` | 라이브러리 최신 버전을 프로젝트에 적용 (커스텀 보존) | 라이브러리 업데이트 시 |
| `/project-absorb` | 프로젝트에서 발전한 지침을 라이브러리로 흡수 | 프로젝트 지침 개선 후 |
| `/optimize-docs` | 지침 파일 줄 수 검사 및 200줄 이내 최적화 | 정기 유지보수 |

---

## 디렉토리 구조

```
ai-dev-toolkit/
├── .claude/skills/        # 스킬 (이 저장소의 핵심 기능)
├── blueprints/            # 도구 무관 공유 지식 (Single Source of Truth)
├── claude/                # Claude Code 지침 및 템플릿
├── docs/                  # 사용 가이드 및 산출물
├── workstations/          # 워크스테이션 환경 상태 + 배포 추적
├── cursor/                # Cursor (추후 확장)
├── copilot/               # GitHub Copilot (추후 확장)
├── windsurf/              # Windsurf (추후 확장)
├── VERSION                # 현재 라이브러리 버전
├── VERSIONING.md          # 버전 정책 정의
└── CHANGELOG.md           # 버전별 변경 이력
```

- **`blueprints/`** — 코딩 표준, Git 워크플로우, 설계 원칙 등 모든 도구가 참조하는 공통 지식
- **도구별 디렉토리** — blueprints를 해당 도구 형식에 맞게 변환한 지침

---

## 지원 도구

| 도구 | 상태 | 글로벌 설정 | 프로젝트 설정 |
|------|------|------------|--------------|
| Claude Code | **활성** | `~/.claude/CLAUDE.md` | `CLAUDE.md` |
| Cursor | 예정 | Settings UI | `.cursor/rules/` |
| GitHub Copilot | 예정 | — | `.github/` |
| Windsurf | 예정 | `~/.windsurf/rules/` | `.windsurf/rules/` |

상세 매핑: [`TOOL_REFERENCE.md`](TOOL_REFERENCE.md)

---

## 버전 정책

**SemVer + Local** 4자리 체계: `Major.Minor.Patch.Local`

| 위치 | 버전 예시 | 관리 주체 |
|------|----------|----------|
| 라이브러리 | `0.1.0` | 이 저장소 (`VERSION` + git tag) |
| 배포된 프로젝트 | `0.1.0.3` | 각 프로젝트 (`CLAUDE.md` 헤더) |

- **Major**: 기존 프로젝트에 수동 마이그레이션 필요
- **Minor**: 새 지침/스킬 추가 — 선택적 채택 가능
- **Patch**: 오타, 표현 개선
- **Local**: 프로젝트에서 지침 수정 시 증가 — 업데이트 적용 시 리셋

상세 정책: [`VERSIONING.md`](VERSIONING.md)

---

## 새 도구 추가

1. 루트에 도구명 디렉토리 생성 (예: `aider/`)
2. `README.md` 작성 — 설정 형식, 배포 위치, 사용법
3. `TOOL_REFERENCE.md`에 매핑 정보 추가
4. blueprints를 해당 도구 형식으로 변환하여 지침 파일 작성

---

## 환경

- Windows 네이티브 (Claude Code Desktop + Git Bash)
- Windows + WSL2
- 원격 서버 SSH
- 주요 도메인: C/C++ 임베디드 시스템
