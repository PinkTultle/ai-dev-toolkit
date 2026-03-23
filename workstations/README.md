# workstations/

워크스테이션별 환경 상태 파일을 저장한다.
`/ai-platform-defconfig` 스킬이 실행 시 이 디렉토리에 JSON 파일을 생성/갱신한다.

## 파일 명명 규칙

- `<alias>.json` — 별칭은 사용자 지정 (기본값: hostname의 kebab-case 변환)
- 영문 소문자, 숫자, 하이픈만 허용
- 예: `pink-turtle.json`, `office-server.json`

## JSON 스키마 (v1)

```json
{
  "$schema": "workstation-state-v1",
  "alias": "pink-turtle",
  "hostname": "Pink-turtle",

  "environment": {
    "os": "Linux 6.6.87.2-microsoft-standard-WSL2 x86_64",
    "platform": "WSL2",
    "wsl_distro": "Ubuntu-20.04",
    "is_ssh": false,
    "user": "innn",
    "home": "/home/innn"
  },

  "repo_path": "/home/innn/My_AI_manual",

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

## 갱신 규칙

- defconfig 재실행 시 `defconfig_history`에 항목을 추가하고, 나머지 필드는 최신 값으로 갱신한다
- 기존 이력은 보존한다
