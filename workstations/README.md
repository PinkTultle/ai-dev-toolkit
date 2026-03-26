# workstations/

워크스테이션별 환경 상태 파일을 저장한다.
`/ai-platform-defconfig` 스킬이 실행 시 이 디렉토리에 JSON 파일을 생성/갱신한다.

## 파일 구조

| 파일 | 역할 | Git |
|------|------|-----|
| `registry.md` | 전체 워크스테이션 + 배포 프로젝트 현황 인덱스 | 커밋 |
| `<alias>.json` | 공개 환경 상태 (패키지, 링크, MCP, 이력) | 커밋 |
| `<alias>.local.json` | 로컬 전용 (hostname, 사용자, 경로, 배포 프로젝트) | **gitignore** |

## 파일 명명 규칙

- 별칭은 사용자 지정 (기본값: hostname의 kebab-case 변환)
- 영문 소문자, 숫자, 하이픈만 허용
- 예: `pink-turtle.json` + `pink-turtle.local.json`

## 공개 JSON 스키마 (`<alias>.json`)

공개 저장소에 커밋되는 파일. 민감 정보를 포함하지 않는다.

```json
{
  "$schema": "workstation-state-v1",
  "alias": "<alias>",

  "environment": {
    "platform": "WSL2",
    "wsl_distro": "Ubuntu-20.04",
    "is_ssh": false
  },

  "packages": {
    "git": "2.25.1",
    "jq": "1.6",
    "dos2unix": "7.4.0"
  },

  "symlinks": {
    "~/.claude/CLAUDE.md": {
      "target": "~/ai-dev-toolkit/claude/global_CLAUDE.md",
      "status": "ok",
      "method": "symlink"
    }
  },

  "mcp_servers": [],

  "claude_settings_path": "~/.claude/settings.json",

  "defconfig_history": [
    { "date": "2026-03-23", "result": "ok", "notes": "초기 세팅" }
  ],

  "last_updated": "2026-03-23"
}
```

## 로컬 JSON 스키마 (`<alias>.local.json`)

`.gitignore` 처리되어 로컬에서만 유지. 스킬이 참조하는 민감/환경별 정보.

```json
{
  "alias": "<alias>",
  "hostname": "<hostname>",
  "user": "<user>",
  "home": "~",
  "repo_path": "~/ai-dev-toolkit",

  "deployed_projects": [
    {
      "name": "프로젝트명",
      "path": "~/project/path",
      "base_version": "0.1.0",
      "local_version": 0,
      "deployed_date": "YYYY-MM-DD",
      "last_synced": "YYYY-MM-DD"
    }
  ]
}
```

## 필드 설명

### 공개 (`<alias>.json`)

| 필드 | 설명 |
|------|------|
| `$schema` | 스키마 버전 (`workstation-state-v1`) |
| `alias` | 사용자 지정 별칭 (파일명과 동일) |
| `environment` | 플랫폼(`WSL2`, `Windows`, `Linux`, `macOS`), WSL 배포판, SSH 여부 |
| `packages` | 필수 패키지 버전 |
| `symlinks` | 심볼릭 링크 상태 (`method`: `symlink` 또는 `copy`) |
| `mcp_servers` | 설정된 MCP 서버 목록 |
| `defconfig_history` | 실행 이력 (누적) |
| `last_updated` | 파일 최종 갱신일 |

### 로컬 (`<alias>.local.json`)

| 필드 | 설명 | 비공개 이유 |
|------|------|------------|
| `hostname` | 실제 hostname | 네트워크 식별 |
| `user` | 사용자명 | 계정 식별 |
| `home` | 홈 디렉토리 | 디렉토리 구조 |
| `repo_path` | 저장소 경로 | 디렉토리 구조 |
| `deployed_projects` | 배포 프로젝트 목록+경로 | 경로 노출 |

### deployed_projects 필드

| 필드 | 설명 |
|------|------|
| `base_version` | 배포 시점의 라이브러리 버전 (3자리) |
| `local_version` | 프로젝트에서 지침 수정 횟수 |
| `deployed_date` | 최초 배포일 |
| `last_synced` | 라이브러리 버전과 마지막 동기화일 |

## 경로 기록 규칙

- 경로는 **`~`(홈 디렉토리) 기준 상대 경로**로 기록한다 — 절대 경로(`/home/user/...`, `C:\Users\...`) 금지
- 스킬에서 읽을 때 `~`를 `$HOME`으로 확장하여 사용 (Windows Git Bash에서도 동일)

## 갱신 규칙

- defconfig 재실행 시: 공개 JSON의 `defconfig_history`에 항목 추가, 나머지 필드 최신 값으로 갱신
- `/project-init` 실행 시: 로컬 JSON의 `deployed_projects`에 프로젝트 항목 추가/갱신
- `registry.md`는 위 변경 시 함께 갱신
- 기존 이력은 보존
- 다른 워크스테이션 참조 시: `registry.md`(현황) + 공개 JSON(구성)만으로 충분
