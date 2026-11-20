# 에이전트 · 스킬 실행 모델

> 도구 무관 공유 지식 — 서브에이전트와 스킬의 정의·실행 규칙
> Claude Code 기준 검증 버전: **v2.1.326**. 다른 도구는 지원 필드가 다를 수 있다.

---

## 1. 서브에이전트 정의 파일

`agents/<name>.md` — YAML frontmatter + 시스템 프롬프트 본문.

### 1.1 필드

| 필드 | 필수 | 설명 |
|------|------|------|
| `name` | ✔ | **소문자와 하이픈만** (`gap-detector`). 공백·대문자·`:` 금지 — `:`는 플러그인 네임스페이스 예약 |
| `description` | ✔ | 언제 이 에이전트에 위임할지. 구체적일수록 자동 선택이 정확해진다 |
| `tools` | | 허용 도구 목록. 생략 시 전체 상속 |
| `disallowedTools` | | 상속/지정 목록에서 제외할 도구 |
| `model` | | `sonnet` `opus` `haiku` `fable` \| 전체 모델 ID \| `inherit` (기본) |
| `effort` | | `low` `medium` `high` `xhigh` `max` — 세션 effort를 덮어씀. 환경변수 `CLAUDE_CODE_SUBAGENT_EFFORT`로 일괄 지정 가능 |
| `isolation` | | `worktree` — 임시 git worktree에서 실행. 변경이 없으면 자동 정리 |
| `background` | | `true`면 항상 백그라운드. 미지정 시 런타임이 판단 (기본 백그라운드) |
| `permissionMode` | | `default` `acceptEdits` `auto` `dontAsk` `bypassPermissions` `plan`. **플러그인 에이전트에서는 무시됨** |
| `maxTurns` | | 에이전트 루프 상한 |
| `autoCompactWindow` | | 이 에이전트의 자동 압축 기준 컨텍스트 크기 |
| `omitClaudeMd` | | `true`면 CLAUDE.md를 이 에이전트 컨텍스트에 넣지 않는다 |
| `skills` | | 시작 시 컨텍스트에 선주입할 스킬 (설명이 아닌 전문이 주입된다) |
| `memory` | | `user` `project` `local` — 에이전트 전용 영속 메모리 활성화 |
| `mcpServers` | | 이 에이전트가 쓸 MCP 서버. **플러그인 에이전트에서는 무시됨** |
| `hooks` / `initialPrompt` | | 에이전트 전용 훅 / 시작 프롬프트. **플러그인 에이전트에서는 무시됨** |
| `experimental.cacheTtl` | | 프롬프트 캐시 유지 시간 `5m` \| `1h` |
| `color` | | `red` `blue` `green` `yellow` `purple` `orange` `pink` `cyan` |

### 1.2 규칙

- `name`은 **파일명과 일치**시킨다 — 강제는 아니지만 권한 규칙(`Agent(name)`)과 훅
  (`SubagentStart`의 `agent_type`)이 이 값을 쓰므로 불일치는 추적을 어렵게 한다
- 플러그인으로 배포하는 에이전트에는 `hooks` / `mcpServers` / `permissionMode` / `initialPrompt`를
  넣지 않는다 — 무시된다. 훅은 `hooks/hooks.json`, MCP는 `.mcp.json`에 둔다
- 신규 모델에서는 `TodoWrite`와 `Task*` 도구를 쓸 수 없다 — 에이전트·스킬 지시가 이 도구를 전제하지 않게 쓴다
- `memory`는 **기본으로 켜지 않는다**. 디스크에 학습 내용을 누적하므로 프로젝트별로 합의 후 활성화

---

## 2. 실행 모델

### 2.1 백그라운드가 기본

서브에이전트는 **기본적으로 백그라운드에서 실행**된다. 메인 세션은 대기하지 않고 계속 진행하며,
완료 시 알림을 받는다.

| 상황 | 처리 |
|------|------|
| 다음 단계의 입력이 되는 산출물 | **완료를 확인한 뒤 진행** — 승인 게이트가 있는 흐름은 반드시 대기 |
| 서로 의존하지 않는 조사·탐색 | 병렬로 띄우고 나중에 수거 |
| 항상 동기 실행이 필요한 에이전트 | 정의 파일에 `background: false` 명시 |

> 아직 끝나지 않은 에이전트의 결과를 **추측해서 보고하지 않는다.** 완료 알림을 받은 뒤 보고한다.

### 2.2 컨텍스트 분리 vs 복제

| 방식 | 컨텍스트 | 용도 |
|------|---------|------|
| 서브에이전트 (`/subtask`) | 빈 컨텍스트 + 전달한 프롬프트 | 대화를 오염시키지 않을 독립 작업 |
| 포크 (`/fork`) | 부모 대화 전체 복제 | 같은 맥락에서 갈래를 나눠 진행. 프롬프트 캐시를 재사용해 더 저렴 |

### 2.3 상한

| 항목 | 기본값 | 환경변수 |
|------|--------|---------|
| 중첩 생성 깊이 | 3 | `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` |
| 동시 실행 수 | 20 | `CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS` |

동시 실행 상한에 닿을 규모라면 **작업을 나누어 순차 실행**한다. 상한에 걸린 생성은 실패한다.
세션당 총 생성 수 상한은 없다.

---

## 3. 모델 · effort 선택 기준

| 작업 성격 | 모델 | effort |
|----------|------|--------|
| 파일 탐색, 목록화, 기계적 변환 | `haiku` / `sonnet` | `low` |
| 코드 작성, 일반 리뷰, 검증 | `sonnet` | 기본 |
| 설계, 설계 검토, 아키텍처 판단 | `opus` | `high` |
| 트레이드오프가 큰 단일 결정 | `opus` | `xhigh` 이상 |

- **effort를 올리기 전에 프롬프트를 먼저 개선한다** — 입력이 모호하면 effort를 올려도 결과가 나아지지 않는다
- 모든 에이전트를 최고 사양으로 돌리지 않는다. 판단이 어려운 작업(설계·검토)에만 집중 투자한다

---

## 4. 스킬 정의 파일

`skills/<name>/SKILL.md` — [Agent Skills 오픈 표준](https://agentskills.io). 동일 형식을
Claude Code 외 다수 도구가 읽는다. 아래 표에서 ★는 Claude Code 확장 필드다.

| 필드 | 설명 |
|------|------|
| `name` | 표시 이름. 생략 시 디렉토리명 |
| `description` | **가장 중요한 필드** — 자동 선택 근거. 핵심 use case를 맨 앞에 |
| `when_to_use` ★ | 언제 쓸지에 대한 보충 설명. `description`과 합쳐 목록에 실린다 |
| `argument-hint` | 자동완성 힌트 (`[file-path]`) |
| `allowed-tools` | 이 스킬이 호출된 턴 동안 권한 확인 없이 쓸 도구 |
| `disallowed-tools` ★ | 스킬 활성 중 쓰지 못하게 할 도구 |
| `paths` ★ | 이 glob에 맞는 파일을 다룰 때만 스킬을 후보로 올린다 |
| `shell` ★ | 스킬 본문의 명령 실행에 쓸 셸 |
| `model` / `effort` ★ | 스킬 활성 중 모델·effort 오버라이드 |
| `disable-model-invocation` ★ | `true` — AI 자동 호출 금지, `/name` 수동 호출만 |
| `user-invocable` ★ | `false` — `/` 메뉴에서 숨김 (배경 지식용) |
| `context: fork` ★ | 포크된 서브에이전트 컨텍스트에서 실행 |
| `agent` ★ | `context: fork` 시 사용할 에이전트 타입 |
| `background` ★ | `context: fork` 전용. `false`면 결과를 그 턴에서 대기 |

### 4.1 description 작성 규칙

자동 선택은 오직 `description`으로 판단한다. 모호하면 영영 호출되지 않는다.

```
✘ "코드를 도와준다"
✔ "변경사항 코드 리뷰 — 보안/성능/가독성/규칙 위반 검사. 커밋 직전 실행"
```

`description`과 `when_to_use`는 합쳐서 스킬 목록에서 **1,536자에서 잘린다** — 핵심을 앞에 둔다.

### 4.2 자동 호출 금지 대상

파괴적이거나 사용자 의도가 명확해야 하는 스킬은 `disable-model-invocation: true`를 붙인다.

- 파일을 덮어쓰거나 배포하는 스킬 (init, update, deploy)
- 커밋·푸시를 수행하는 스킬
- 워크스테이션 전역 설정을 바꾸는 스킬

이 표시가 붙은 스킬을 AI가 쓰려 하면, 실행하지 않고 **사용자에게 `/name`으로 직접 실행해 달라고 요청**한다.

`allowed-tools`나 hooks를 선언한 스킬은 예약 작업·`/loop`에서 실행 전 확인을 받는다.
무인 실행이 필요하면 사용자가 `Skill(name)`을 `permissions.allow`에 추가한다.

---

## 5. 선택 기준 요약

| 필요한 것 | 쓸 것 |
|----------|------|
| 반드시 강제되어야 하는 규칙 | 훅 또는 permissions (`hooks.md`) |
| 상황에 따라 필요한 절차·지식 | 스킬 |
| 컨텍스트를 분리해야 하는 위임 | 서브에이전트 |
| 항상 적용되는 짧은 프로젝트 지침 | CLAUDE.md (`memory-and-context.md`) |
| 특정 경로에서만 필요한 지침 | `.claude/rules/` + `paths` |
