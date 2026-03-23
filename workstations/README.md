# workstations/

워크스테이션별 환경 상태 파일을 저장한다.
`/ai-platform-defconfig` 스킬이 실행 시 이 디렉토리에 JSON 파일을 생성/갱신한다.

## 파일 구조

| 파일 | 역할 |
|------|------|
| `registry.md` | 전체 워크스테이션 + 배포 프로젝트 현황 인덱스 |
| `<alias>.json` | 워크스테이션 환경 상태 (defconfig 결과) |
| `<alias>.deploy.json` | 해당 워크스테이션에 배포된 프로젝트 목록 |

## 파일 명명 규칙

- 별칭은 사용자 지정 (기본값: hostname의 kebab-case 변환)
- 영문 소문자, 숫자, 하이픈만 허용
- 예: `pink-turtle.json`, `pink-turtle.deploy.json`

## JSON 스키마 (v1)

```json
{
  "$schema": "workstation-state-v1",
  "alias": "<alias>",
  "hostname": "<hostname>",

  "environment": {
    "os": "Linux ...",
    "platform": "WSL2",
    "wsl_distro": "Ubuntu-20.04",
    "is_ssh": false,
    "user": "<user>",
    "home": "~"
  },

  "repo_path": "~/my_ai_manual",

  "packages": {
    "git": "2.25.1",
    "jq": "1.6",
    "dos2unix": "7.4.0"
  },

  "symlinks": {
    "~/.claude/CLAUDE.md": {
      "target": "<repo>/claude/global_CLAUDE.md",
      "status": "ok"
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

### 필드 설명

| 필드 | 설명 |
|------|------|
| `$schema` | 스키마 버전 (`workstation-state-v1`) |
| `alias` | 사용자 지정 별칭 (파일명과 동일) |
| `hostname` | 실제 hostname |
| `environment` | OS, 플랫폼, WSL 배포판, SSH 여부, 사용자, 홈 디렉토리 |
| `repo_path` | 이 저장소의 절대 경로 |
| `packages` | 필수 패키지 버전 |
| `symlinks` | 심볼릭 링크 상태 (키: 타겟 경로) |
| `mcp_servers` | 설정된 MCP 서버 목록 |
| `claude_settings_path` | Claude Code 설정 파일 경로 |
| `defconfig_history` | 실행 이력 (누적) |
| `last_updated` | 파일 최종 갱신일 |

## deploy.json 스키마

```json
{
  "workstation": "<alias>",
  "projects": [
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

| 필드 | 설명 |
|------|------|
| `base_version` | 배포 시점의 라이브러리 버전 (3자리) |
| `local_version` | 프로젝트에서 지침 수정 횟수 |
| `deployed_date` | 최초 배포일 |
| `last_synced` | 라이브러리 버전과 마지막 동기화일 |

## 경로 기록 규칙

- 경로는 **`~`(홈 디렉토리) 기준 상대 경로**로 기록한다 — 절대 경로(`/home/user/...`) 금지
- 스킬에서 읽을 때 `~`를 `$HOME`으로 확장하여 사용

## 갱신 규칙

- defconfig 재실행 시 `defconfig_history`에 항목을 추가하고, 나머지 필드는 최신 값으로 갱신한다
- `/project-init` 실행 시 `deploy.json`에 프로젝트 항목을 추가/갱신한다
- `registry.md`는 위 변경 시 함께 갱신한다
- 기존 이력은 보존한다
