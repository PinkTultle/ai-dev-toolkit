# 훅 (Hooks)

> 도구 무관 공유 지식 — 라이프사이클 자동화
> Claude Code 기준 검증 버전: **v2.1.220**

훅은 **AI의 판단과 무관하게** 정해진 시점에 실행되는 셸 명령이다.
"반드시 지켜져야 하는 것"은 지침이 아니라 훅으로 강제한다.

| 필요 | 수단 |
|------|------|
| 커밋 전에 항상 린트 | 훅 |
| 특정 경로 수정 금지 | `permissions.deny` |
| 상황에 따라 참고할 컨벤션 | 지침(rules/CLAUDE.md) — 훅이 아니다 |

---

## 1. 입출력 계약

**훅은 인자가 아니라 stdin으로 JSON을 받는다.** `$CLAUDE_FILE_PATH` 같은 환경변수는 없다.

```bash
#!/bin/bash
INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE" ] && exit 0
```

| 종료 코드 | 의미 |
|-----------|------|
| `0` | 통과. stdout은 참고 정보로 전달 |
| `2` | **차단** — stderr 내용이 AI에게 전달되어 재시도를 유도 |
| 그 외 | 비차단 경고 |

- 경고성 검사는 반드시 `exit 0` — 개발 흐름을 막지 않는다
- `timeout`을 명시한다 (밀리초). 훅이 멈추면 세션이 멈춘다
- 플러그인 훅의 스크립트 경로는 `${CLAUDE_PLUGIN_ROOT}` 기준으로 쓴다

---

## 2. 이벤트

| 분류 | 이벤트 |
|------|--------|
| 세션 | `SessionStart` `SessionEnd` `Setup` |
| 턴 | `UserPromptSubmit` `UserPromptExpansion` `Stop` `StopFailure` |
| 도구 루프 | `PreToolUse` `PostToolUse` `PostToolUseFailure` `PostToolBatch` |
| 권한 | `PermissionRequest` `PermissionDenied` |
| 에이전트/작업 | `SubagentStart` `SubagentStop` `TaskCreated` `TaskCompleted` `TeammateIdle` |
| 컨텍스트 | `PreCompact` `PostCompact` `InstructionsLoaded` |
| 환경 | `CwdChanged` `DirectoryAdded` `FileChanged` `ConfigChange` |
| 워크트리 | `WorktreeCreate` `WorktreeRemove` |
| 기타 | `Notification` `MessageDisplay` `Elicitation` `ElicitationResult` |

자주 쓰는 조합:

| 목적 | 이벤트 |
|------|--------|
| 편집 후 포맷/린트/제한 검사 | `PostToolUse` |
| 위험 명령 차단 | `PreToolUse` (exit 2) |
| 세션 시작 시 컨텍스트 주입 | `SessionStart` |
| 지침 파일 로드 디버깅 | `InstructionsLoaded` |
| 서브에이전트 작업 완료 추적 | `SubagentStop` / `TaskCompleted` |

---

## 3. 대상 좁히기

### 3.1 `matcher`

도구 이름 기준 필터. 정확히 일치하거나 `|`로 나열하며, 그 외 문자가 섞이면 정규식으로 해석된다.

```json
{ "matcher": "Write|Edit" }
{ "matcher": "mcp__memory__.*" }
```

### 3.2 `if`

권한 규칙 문법으로 한 번 더 좁힌다. 도구 이벤트에서만 쓸 수 있다.

| 조건 | 의미 |
|------|------|
| `Bash(git *)` | `git`으로 시작하는 Bash 명령 |
| `Edit(*.ts)` | TypeScript 파일 편집/생성 |
| `Edit(src/**)` | **작업 디렉토리 바로 아래** `src/` |
| `Edit(**/src/**)` | 임의 깊이의 `src/` |

> 단일 세그먼트 `dir/**`는 `<cwd>/dir`만 매칭한다. 깊이 무관 매칭은 `**/dir/**`로 쓴다.

### 3.3 구성 예

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "if": "Edit(**/*.md)",
        "hooks": [
          { "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/check.sh",
            "timeout": 5000 }
        ]
      }
    ]
  }
}
```

`type`은 `command` 외에 `http`(HTTP 엔드포인트 호출), `mcp_tool`(MCP 도구 직접 호출)을 지원한다.

---

## 4. 작성 규칙

1. **검증 없이 배포하지 않는다** — 훅은 조용히 실패한다. 실제 JSON을 파이프해서 확인한다
   ```bash
   echo '{"tool_input":{"file_path":"/tmp/x.md"}}' | bash hooks/check.sh; echo "exit=$?"
   ```
2. **범위를 좁힌다** — `matcher` + `if`로 필요한 경우에만 실행한다. 모든 편집마다 도는 훅은 비용이다
3. **멱등하게 작성한다** — 같은 입력에 같은 결과. 부수효과가 있으면 되돌릴 수 있어야 한다
4. **의존 도구를 가정하지 않는다** — `jq` 등이 없는 환경을 위한 fallback 또는 명확한 안내를 둔다
5. **차단(exit 2)은 아껴 쓴다** — 오탐이 잦은 검사는 경고로 시작해 신뢰가 쌓인 뒤 차단으로 승격

---

## 5. 안전 관련 기본 동작

런타임이 이미 막아 주는 것은 훅으로 중복 구현하지 않는다.

- 명시적으로 요청하지 않은 파괴적 git 명령
  (`git reset --hard`, `git checkout -- .`, `git clean -fd`, `git stash drop`)
- 대상을 지정하지 않은 `terraform destroy` / `pulumi destroy` / `cdk destroy`
- 데몬 리다이렉트 플래그가 붙은 `docker` 명령

프로젝트 고유의 위험 명령(장비 플래싱, 운영 DB 접근 등)만 `PreToolUse`로 추가 차단한다.
