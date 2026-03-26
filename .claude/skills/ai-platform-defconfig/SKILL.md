---
name: ai-platform-defconfig
description: 워크스테이션 최초 세팅 — 사용자 정보, 경로, 심볼릭 링크, 패키지, MCP 등 AI 플랫폼 기반 구성
argument-hint: ""
allowed-tools: Read, Bash, Glob, Grep, Write, Edit
---

# AI Platform Defconfig

이 저장소(`ai-dev-toolkit`)가 위치한 워크스테이션의 AI 개발 환경을 구성한다.
워크스테이션당 최초 1회 실행하며, 환경 변경 시 재실행한다.

## 수집할 정보

사용자와 대화하여 아래 정보를 수집한다. 각 항목에 대해 현재 환경을 먼저 탐색하고, 감지된 값을 제시한 뒤 확인/수정을 받는다.

### 0. 워크스테이션 식별
- 별칭: 사용자 지정 (기본값: hostname을 kebab-case로 변환)
- hostname: !`hostname`
- 기존 상태 파일: `workstations/<alias>.json` 존재 여부 확인
  - 있으면 이전 상태를 읽어와 표시

별칭 규칙:
- 영문 소문자, 숫자, 하이픈만 허용
- 파일명(`workstations/<alias>.json`)에 사용됨

### 1. 사용자 정보
- 사용자명: !`whoami`
- 홈 디렉토리: !`echo $HOME`
- 이 저장소 경로: `${CLAUDE_SKILL_DIR}/../../..`

### 2. 환경 감지
- OS/플랫폼: !`uname -a`
  - `MINGW64_NT*` 또는 `MSYS_NT*` → **Windows 네이티브 (Git Bash)**
  - `uname` 실패 → Windows에서 Git Bash 미설치. 설치 안내 출력 후 중단
- WSL2 여부: !`echo ${WSL_DISTRO_NAME:-"not WSL"}`
- SSH 여부: !`echo ${SSH_CLIENT:-"not SSH"}`

### 3. 필수 패키지 확인
아래 패키지들의 설치 여부를 확인하고, 미설치 시 설치 안내를 제공한다:
- `git` — 버전 관리
- `jq` — JSON 처리 (MCP 설정 등)
  - Windows 미설치 시: `scoop install jq` 또는 `choco install jq` 안내
- `dos2unix` — WSL2 환경 CRLF 방지 (**Windows 네이티브에서는 스킵**)

### 4. 심볼릭 링크 설정
현재 상태를 확인하고, 필요 시 생성/갱신한다:

| 소스 (이 저장소) | 타겟 | 용도 |
|-----------------|------|------|
| `claude/global_CLAUDE.md` | `~/.claude/CLAUDE.md` | Claude Code 글로벌 규칙 |

심볼릭 링크 생성 전 타겟 파일이 이미 존재하는지 확인한다:
- 심볼릭 링크가 이미 올바르게 연결 → 스킵
- 일반 파일이 존재 → 백업 후 심볼릭 링크 생성
- 없음 → 새로 생성

**Windows 네이티브**: `ln -sf` 시도 → 실패 시(Developer Mode 미활성) `cp`로 fallback
- fallback 사용 시 사용자에게 안내: "파일 복사로 대체합니다. 원본 변경 시 수동 동기화 또는 defconfig 재실행이 필요합니다."
- 상태 파일에 `"method": "copy"` 기록 (symlink과 구분)

### 5. MCP 서버 설정
`~/.claude/settings.json`의 MCP 서버 설정을 확인한다.
사용자에게 필요한 MCP 서버 목록을 물어보고, 설정을 안내한다.

### 6. Claude Code 설정 확인
`~/.claude/settings.json`의 현재 설정을 확인하고 표시한다.

## 실행 흐름

1. **환경 탐색** — 위 1~2 항목을 자동 감지하여 표시
2. **확인** — 감지된 정보가 맞는지 사용자에게 확인
3. **워크스테이션 별칭** — 0번 항목. hostname을 기본값으로 제시하고 사용자 확인/수정
   - 기존 `workstations/<alias>.json`이 있으면 이전 상태를 표시
4. **패키지 확인** — 3번 항목 체크, 미설치 목록 안내
5. **심볼릭 링크** — 4번 항목 확인/생성
6. **MCP/설정** — 5~6번 항목 확인/안내
7. **상태 파일 저장** — 2개 파일 생성/갱신 (스키마: `workstations/README.md` 참조)
   - `workstations/<alias>.json` (공개) — 패키지, 링크, MCP, 이력
   - `workstations/<alias>.local.json` (gitignore) — hostname, 사용자, 경로, 배포 프로젝트
   - 기존 파일이 있으면 `defconfig_history`에 항목 추가, 나머지 필드 갱신
8. **결과 요약** — 수행된 작업과 현재 상태를 정리하여 출력
   - HANDOFF.md 워크스테이션 테이블도 갱신

## 주의사항

- 파괴적 작업(기존 파일 덮어쓰기 등)은 반드시 사전 확인
- 패키지 설치는 직접 수행하지 않고, 설치 명령어를 안내만 한다
- 공개 상태 파일(`<alias>.json`)은 커밋, 로컬 파일(`<alias>.local.json`)은 gitignore
- 기존 상태 파일이 있는 경우 `defconfig_history`를 보존하며 갱신한다
- 실행 결과를 HANDOFF.md의 워크스테이션 환경 메모에 기록한다
