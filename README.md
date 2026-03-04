# My AI Manual

AI 코딩 어시스턴트 지침을 중앙에서 관리하는 저장소.
도구별 독립 디렉토리 구조로 확장 가능하게 설계되어 있다.

---

## 디렉토리 구조

```
My_AI_manual/
├── _shared/          # 도구 공통 지식 (향후 확장)
├── claude/           # Claude Code
├── cursor/           # Cursor
├── copilot/          # GitHub Copilot
└── windsurf/         # Windsurf
```

- **`_shared/`** — 모든 도구가 참조하는 공통 규칙 (코딩 표준, Git 워크플로우 등)
- **도구별 디렉토리** — 해당 도구의 설정 형식에 맞춘 지침 파일

---

## 사용 방법

각 도구 디렉토리의 파일을 해당 도구의 설정 위치에 복사 또는 심볼릭 링크한다.
배포 위치 상세는 [`TOOL_REFERENCE.md`](TOOL_REFERENCE.md) 참조.

---

## 새 도구 추가 방법

1. 루트에 도구명으로 디렉토리 생성 (예: `aider/`)
2. `README.md` 작성 — 설정 형식, 배포 위치, 사용법
3. `TOOL_REFERENCE.md`에 매핑 정보 추가
4. 지침 파일 작성

---

## 환경

- Windows + WSL2 (주 개발환경)
- 원격 서버 SSH
- 주요 도메인: C/C++ 임베디드 시스템
