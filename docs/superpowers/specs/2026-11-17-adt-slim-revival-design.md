# adt 슬림화 및 재가동 설계

- **날짜**: 2026-11-17
- **기준 버전**: v0.6.0 (`origin/main` `4fd6659`) → 목표 **v0.7.0**
- **작업 브랜치**: `feat/slim-revival`
- **상태**: 승인됨 (2026-11-17)

표기: **[사용자 결정]** 은 대화에서 사용자가 정한 것, **[제안]** 은 작성자가 채운 것으로 사용자가 고칠 수 있다.

---

## 1. 의도

`adt`는 4월과 7월에 두 번 갱신했지만 실제로는 쓰이지 않았다. 사용자가 프로젝트 진행 중
상급자가 배포한 `rkit` 플러그인으로 옮겨 갔기 때문이다. 그런데 rkit도 특정 기능을 골라 쓴 기억은
없고, 꼭 맞지도 않았다. 설치된 rkit(0.9.14)은 2026-05-13 이후 갱신이 없다.

**[사용자 결정]** rkit 대신 `adt`를 일상 도구로 쓴다. 그러기 위해 `adt`를 다시 살린다.

지금 한 세션에 `rkit`, `superpowers`, `adt` 글로벌 규칙이 동시에 걸려 "작업을 어떤 절차로
진행하라"는 지시가 세 갈래로 들어온다. `adt`가 다시 쓰이려면 다른 도구가 이미 하는 일을 덜어내고,
`adt`만 하는 일에 집중해야 한다.

## 2. 목표 / 비목표 / 하면 안 되는 것

### 목표

1. **절차 충돌 제거** — 개발 절차(구체화 → 설계 → 구현 → 검증)는 `superpowers`에 맡긴다.
   `adt`는 절차를 지시하지 않는다.
2. **고유 영역만 유지** — 지침 라이브러리(blueprints, rules), 프로젝트 배포·추적, 인수인계,
   결정 기록, 코드 설명 문서, 설계 대비 구현 일치도 측정.
3. **응답 말미 "다음 추천" 한 줄** — rkit에서 사용자가 좋게 본 유일한 요소.
4. **Claude Code v2.1.220 → v2.1.326 격차 반영** — 설치 버전은 v2.1.325.
5. **rkit 없이 동작** — 이 저장소 작업 시 rkit을 꺼도 아쉬운 것이 없게 한다.

### 비목표 (이번에 하지 않음)

- rkit 도메인 스킬(`stm32-hal`, `freertos`, `misra-c`, `yocto-*` 등)의 일괄 이식.
  필요해진 시점에 한 건씩 가져오는 절차만 만든다 (§5.5).
- `cursor/`, `copilot/`, `windsurf/` 지침 갱신.
- 다른 워크스테이션(`pink-turtle`, `pink-turtle-win`)과 배포 프로젝트 3개로의 전파.
  이 워크스테이션에는 배포 프로젝트가 없다. 전파는 릴리스 후 해당 워크스테이션에서 별도로 한다.
- rkit의 PDCA 상태 머신, 품질 게이트 자동화, 다국어 트리거 (ADR-001에서 이미 비채택).

### 하면 안 되는 것

- **프로젝트 디렉토리에 숨김 상태 폴더나 상태 파일을 만들지 않는다.** [사용자 결정]
  rkit의 `.rkit/`이 `.gitignore` 관리에서 골칫거리였다. `adt`가 프로젝트에 두는 것은
  `CLAUDE.md`, `.claude/rules/`, `.claude/settings*.json`, `HANDOFF.md`, `docs/` 산출물처럼
  사용자가 읽고 커밋하는 파일뿐이다. 실행 상태가 필요해지면 `${CLAUDE_PLUGIN_DATA}`
  (`~/.claude/plugins/data/<id>/`)를 쓴다.
- **상시 개입을 늘리지 않는다.** SessionStart 훅으로 긴 안내를 주입하거나, 출력 스타일을 강제하거나,
  세션 시작 시 선택지를 강요하지 않는다. 지금 훅 1개(줄 수 검사) 수준을 유지한다.
- 사용자와 합의하지 않은 내용을 지침·blueprint에 추가하지 않는다 (기존 "지식 축적 규칙").

## 3. 제약

- 지침 성격 파일은 200줄 이내 (`docs/` 하위 제외).
- `main` 직접 push 금지. `feat/slim-revival` → PR → squash merge.
- `blueprints/`가 원본이고 `.claude/rules/`는 파생본이다. 둘을 함께 고친다 (`/adt:sync-check`로 확인).
- 이 워크스테이션은 registry의 `pink-turtle-rt`다 (defconfig 2026-03-24, v0.3.0 기준).
  `~/.claude/rules/`에는 링크가 4개뿐이고 v0.5.0에서 추가된 `platform.md`가 없다.
- **글로벌 규칙 심볼릭 링크는 `main` 브랜치가 아니라 이 작업 트리(`/home/inseok/my_ai_manual`)의
  파일을 가리킨다.** 이 체크아웃에서 `global-*.md`를 고치면 커밋 전에도 모든 세션에 바로 적용된다.
  따라서 **구현은 별도 git worktree에서 한다** [제안]. 작업 중인 규칙이 다른 세션에 새지 않게 하기 위해서다.
- 로컬 `main`은 v0.4.2에 머물러 있다 (원격보다 5커밋 뒤, 로컬 전용 커밋 없음). 머지 후 이 작업 트리를
  `main`으로 되돌리고 fast-forward 해야 새 규칙이 실제로 적용된다.

## 4. 접근 방식

| 방식 | 내용 | 대가 |
|------|------|------|
| **A. 슬림화** | 절차는 superpowers에 맡기고 `adt`는 고유 영역에 집중 | superpowers에 의존 |
| B. 자립형 | 파이프라인 유지·최신화, rkit PDCA 요소 추가 흡수 | 유지량 최대, superpowers와 충돌 지속 |
| C. 최소 갱신 | 구조 그대로, 4개월치 플랫폼 변화만 반영 | 안 쓰게 된 원인이 그대로 남음 |

**[사용자 결정] A.** 혼자 유지하는 도구라 범위가 작아야 살아 있고, 대신할 도구가 없는 부분만
남겨야 손이 간다. superpowers를 계속 쓴다는 전제다.

## 5. 설계

### 5.1 슬림화 — 무엇을 덜어내고 무엇을 남기는가 [제안]

**에이전트 12개 → 1개**

| 에이전트 | 처리 | 이유 |
|---------|------|------|
| `ideation`, `product-manager` | 삭제 | `superpowers:brainstorming`과 동일 |
| `designer`, `design-validator`, `reviewer` | 삭제 | brainstorming의 설계서·검토, `writing-plans`와 동일 |
| `implementer`, `cto-lead` | 삭제 | `subagent-driven-development`, `executing-plans`, `dispatching-parallel-agents`와 동일 |
| `code-analyzer` | 삭제 | `requesting-code-review` 및 내장 `/code-review`와 동일 |
| `verifier`, `tester` | 삭제 | `verification-before-completion`, `test-driven-development`가 대신 |
| `report-generator` | 삭제 | 파이프라인 산출물을 종합하는 역할인데 그 산출물이 없어짐 |
| **`gap-detector`** | **유지, 입력 경로 변경** | 설계 대비 구현 일치도를 수치로 내는 것은 다른 곳에 없음 |

`gap-detector`는 입력을 `docs/artifacts/design/...`에서 "사용자가 지정한 설계 문서 경로
(기본: `docs/superpowers/specs/`의 최신 문서)"로 바꾸고, 설명에서 PDCA·`verifier` 언급을 뺀다.
결과는 파일로 쓰지 않고 응답으로 돌려준다 (사용자가 저장을 요청하면 지정 경로에 쓴다).

**스킬 11개 → 10개**

- `/adt:review` 삭제 — 내장 `/code-review`, `superpowers:requesting-code-review`와 겹친다.
- 나머지 10개 유지: `ai-platform-defconfig`, `project-init`, `project-configure`, `project-update`,
  `project-absorb`, `optimize-docs`, `handoff`, `sync-check`, `doc-gen`, `decision`.

**템플릿 4개 → 1개**

- `plan.template.md`, `design.template.md`, `report.template.md` 삭제 (삭제되는 에이전트만 참조).
- `decision.template.md` 유지 (`/adt:decision`이 사용).

**절차 규칙**

- `blueprints/design-principles.md`: §1(개발 단계 워크플로우 프리셋), §2의 `docs/artifacts/` 단계별
  디렉토리, §3(서브에이전트 파이프라인·에이전트 팀·품질 루프)을 걷어낸다. 남기는 것:
  - 설계 우선 원칙 한 단락: 작업 크기에 맞는 절차를 밟고, 설계는 사용자 승인 후 구현한다.
    Claude Code에서는 `superpowers`가 이 절차를 수행하며, 없으면 기본 plan mode를 쓴다.
  - 코드 설명 문서 규칙 (`docs/source/`, `/adt:doc-gen`이 사용).
  - 기술 부채 표기 규칙 (`TODO`/`FIXME`/`HACK`).
- `.claude/rules/global-workflow.md`: 위와 같은 내용으로 파생본을 줄인다.
- `claude/global_CLAUDE.md`의 rules 표 설명, `claude/project_CLAUDE.md`의 파이프라인·산출물 관련
  절을 같은 방향으로 고친다.
- `claude/project_CLAUDE.md` §7 (모든 신규·갱신 프로젝트로 복제되는 템플릿) [제안]:
  - 설계 문서 위치를 템플릿에 고정하지 않는다. "절차 도구가 정한 위치를 따른다
    (superpowers를 쓰면 `docs/superpowers/specs/`)"로 적는다. superpowers가 없는 프로젝트와 어긋나지 않게 하기 위해서다.
  - 월별 archive 패턴은 유지하되 대상을 다시 정의한다: 완료된 작업의 설계서·계획서를
    `docs/archive/YYYY-MM/<feature>/`로 옮기고 `_INDEX.md`에 한 줄을 남긴다.
    `{plan,design,analysis,report}.md` 고정 구조와 Match Rate 열은 없앤다 (일치도를 쟀다면 비고에 적는다).
  - `gap-detector`는 설계 문서 경로를 인자로 받는다. 인자가 없으면 `docs/superpowers/specs/`의 최신
    문서를 쓰고, 그것도 없으면 사용자에게 경로를 묻는다.
- `blueprints/agent-runtime.md`에서 삭제된 에이전트를 예시로 든 부분을 고친다.

**참조 정리** — 삭제 대상을 가리키는 곳을 모두 고친다: `README.md`, `docs/project-structure.md`,
`docs/usage-guide.md`, `TOOL_REFERENCE.md`, `plugin.json`·`marketplace.json`·`package.json`의 설명 문구
("12 에이전트, 11 스킬"). `skills/project-init`·`project-configure`·`project-update`에는 삭제 대상
이름이 없음을 확인했다. `project-update`의 위생 검사 문구만 새 구조와 맞는지 본다.

- `HANDOFF.md`는 릴리스 단계에서 이번 세션 기준으로 다시 쓰므로 과거 에이전트 이름이 자연히 빠진다.
- `docs/index.html`(410줄, 4월에 만든 소개 페이지, 다른 문서에서 링크하지 않음)은 페이지 전체가
  삭제되는 파이프라인을 설명한다. **삭제한다** [사용자 승인, 2026-11-17]. `README.md`가 소개
  역할을 하고, 혼자 유지하는 도구에 소개 페이지를 따로 두면 또 어긋난다.

**기존 PDCA 산출물** — `docs/01-plan/`, `docs/02-design/`, `docs/03-analysis/`, `docs/04-report/`의
`plugin-migration.*` 4개 파일은 `project_CLAUDE.md` §7의 archive 패턴대로
`docs/archive/2026-04/plugin-migration/`으로 옮기고 `_INDEX.md`를 둔다. 삭제하지 않는다.

**결정 기록** — `docs/decisions/ADR-002-slim-down-delegate-process-to-superpowers.md`를 추가한다.
ADR-001(rkit 패턴 채택)의 "에이전트 템플릿 참조" 항목이 이 결정으로 대체됨을 적는다.

### 5.2 응답 말미 리포트 [사용자 결정]

사용자가 rkit 리포트에서 좋게 본 것은 **"다음 추천"** 한 가지다. 그것만 가져온다.

- **형식**: 다음 작업 제안이 있을 때만 응답 맨 끝에 한 줄. 없으면 생략한다.
  ```
  💡 다음: <추천하는 다음 작업 한 가지>
  ```
  rkit의 "사용한 기능", "안 쓴 기능" 줄은 넣지 않는다.
- **수단** [제안, 승인됨]: 글로벌 규칙 `.claude/rules/global-communication.md`(원본
  `blueprints/base-directives.md`)에 규칙 몇 줄로 넣는다. 훅, 출력 스타일, 상태 파일을 쓰지 않는다.
  - Stop 훅은 응답 뒤에 문구를 덧붙이는 용도가 아니다 (공식 문서상 작업 계속·검증 용도).
  - 플러그인 출력 스타일(`force-for-plugin`)은 사용자의 출력 스타일 설정을 덮어쓰므로 "상시 개입을
    늘리지 않는다"에 어긋난다.
- 이 저장소 `CLAUDE.md` §4.8은 같은 규칙이 글로벌로 올라가므로 삭제한다. 기존 선택지 규칙
  ("선택지 제시 시 제안사항과 추천 포함")과 겹치지 않게 한 곳에만 적는다.

### 5.3 Claude Code 격차 반영 (v2.1.220 → v2.1.326)

공식 문서와 CHANGELOG를 직접 읽어 확인한 항목만 반영한다. 조사 원문 사본:
세션 scratchpad의 `cc/CHANGELOG.md` (세션이 끝나면 사라질 수 있으므로 필요 시 공식 CHANGELOG를 다시 받는다).

**플러그인 자체**

| 항목 | 조치 |
|------|------|
| `claude plugin validate <dir> --strict` 가 공식 검증 도구 | 검증 절차로 채택. 현재 훅 따옴표 경고 외에 4건이 더 나온다 (아래) |
| `plugin.json`에 `author`, `license` 없음 (`LICENSE_MISSING`은 problem으로 표시) | `package.json`에 이미 있는 값(`author.name: PinkTultle`, `license: MIT`)을 `plugin.json`에 넣고, 루트에 MIT `LICENSE` 파일을 추가한다 (저작권자 표기 `PinkTultle`) [제안] |
| `ICON_MISSING` | 플러그인 디렉토리 등재용 검사다. 등재 계획이 없으므로 **기준에서 제외**, 아이콘을 만들지 않는다 [제안] |
| 루트 `CLAUDE.md` 경고 ("플러그인 루트의 CLAUDE.md는 로드되지 않음") | 이 파일은 저장소 작업용 규칙이라 그대로 둔다. **기준에서 제외** [제안] |
| `engines["claude-code"]`가 v2.1.323부터 강제됨 (범위 밖이면 로드 안 됨) | 현재 `>=2.1.202`. 값은 유지하되 validate 결과로 형식을 확인한다. 공식 레퍼런스 필드 표에는 없고 CHANGELOG에만 있으므로, validate가 경고하면 그 안내를 따른다 |
| 셸 형식 훅에서 `${CLAUDE_PLUGIN_ROOT}` 를 따옴표 없이 쓰면 경고 (v2.1.281) | `hooks/hooks.json`의 명령을 따옴표 처리하거나 exec 형식(`args`)으로 바꾼다 |
| 플러그인 서브에이전트에서 `hooks`, `mcpServers`, `permissionMode`, `initialPrompt`는 무시됨 | `gap-detector`에 해당 필드가 없는지 확인 |
| 플러그인 이름 예약어(`claude-`, `anthropic-` 등) | `adt`는 해당 없음. 조치 없음 |

**blueprint 3종 갱신** (`agent-runtime.md`, `hooks.md`, `memory-and-context.md` + 요약본 `global-platform.md`)

- 서브에이전트: 세션당 200개 생성 상한이 v2.1.224에서 제거됨 → `agent-runtime.md` §2.3의 해당 행 삭제.
  새 필드 `omitClaudeMd`(v2.1.271), `autoCompactWindow`(v2.1.296), `experimental.cacheTtl`(v2.1.248) 추가.
  `CLAUDE_CODE_SUBAGENT_EFFORT`(v2.1.316), 플러그인 에이전트에서 무시되는 필드 4개 명시.
- 스킬: 프론트매터 `when_to_use`, `disallowed-tools`, `user-invocable`, `background`, `paths`, `shell` 등
  현재 필드 목록으로 맞춘다. `description`+`when_to_use` 합산 1,536자 상한.
  `disable-model-invocation` 스킬을 AI가 호출하려 하면 사용자에게 직접 실행을 요청하도록 바뀜 (v2.1.222).
  `allowed-tools`나 hooks를 선언한 스킬은 예약 작업·`/loop`에서 확인 프롬프트가 뜸 (v2.1.325).
- 훅: 이벤트 33종으로 목록 갱신 (`PreModelSwitch`/`PostModelSwitch` v2.1.251 등). 공통 stdin 필드
  `scratchpad_dir`, `prompt_id`, `effort`. Stop/SubagentStop은 `last_assistant_message` 사용.
  출력 문자열 상한 10,000자. `onFailure`(v2.1.295). `if`는 권한 규칙 1개만, 도구 이벤트에서만 평가.
- 메모리·지침: `AGENTS.md` 지원 (v2.1.277, `CLAUDE.md`가 없을 때만 읽음). MEMORY.md는 첫 200줄 또는
  25KB만 로드. `/doctor prompt-audit`. 플러그인 상태 보관은 `${CLAUDE_PLUGIN_DATA}`.
  플러그인 루트의 `CLAUDE.md`는 플러그인 사용자에게 로드되지 않음 (이 저장소의 `CLAUDE.md`는
  저장소 작업용이라 영향 없음. 사실만 기록).
- 신규 모델에서 `TodoWrite`/`Task*` 도구 사용 불가 (v2.1.233) → 스킬·blueprint에 해당 도구 전제가
  있으면 제거한다.
- `TOOL_REFERENCE.md`: `AGENTS.md` 관련 내용 추가.

**모델 표기**

- 지침에 특정 모델 버전 숫자를 적지 않는다. 별칭(`opus`/`sonnet`/`haiku`/`fable`)만 쓴다.
- 열려 있는 PR `PinkTultle/ai-dev-toolkit#11`은 "현재 Opus 4.7 / Sonnet 4.6 / Haiku 4.5"와
  Large 프리셋 팀 분할 임계치를 추가하는 내용인데, 버전 숫자는 이미 구식이고 팀 분할은
  §5.1에서 사라지는 구조다. **닫는다** [사용자 승인, 2026-11-17].
- `gap-detector`의 `model`은 `opus` 유지, `effort: high` 추가 [제안].

**확인하지 못한 것** (추측으로 반영하지 않는다)

- `marketplace.json` 전체 스키마 → validate 결과에 따른다.
- 플러그인이 `rules/`를 직접 제공할 수 있는지 → 확인 안 됨. 지금의 심볼릭 링크 배포 방식을 유지한다.
- 사용자 레벨 `~/.claude/rules/` 로드에 대한 문서상 명시 문구 → 실제로는 로드되고 있음(이 세션에서 확인).

### 5.4 rkit 없이 쓰기

- 이 저장소의 `.gitignore`에서 `.rkit/` 항목은 rkit을 끈 뒤에도 남겨 둔다 (다른 워크스테이션에서
  rkit이 켜져 있을 수 있다). 작업 트리의 `.rkit/` 폴더는 사용자가 지운다.
- `CLAUDE.md` §4.8의 rkit 언급은 §5.2에 따라 삭제된다.
- **rkit 비활성화는 사용자가 직접 한다.** 팀에서 배포한 플러그인이므로 끄는 범위(이 저장소만 /
  사용자 전체)는 사용자가 정한다. 구현 범위에 넣지 않고, 완료 보고에 방법만 안내한다.
- OpenProject 연동은 별도 플러그인 `rootech-openproject`가 제공하므로 rkit과 무관하게 유지된다.

### 5.5 외부 지식 흡수 절차

`blueprints/README.md`의 "새 blueprint 추가" 절에 몇 줄을 더한다. 새 스킬은 만들지 않는다.

- **언제**: 실제 작업에서 그 지식이 필요했던 경우에만. 미리 옮기지 않는다.
- **어떻게**: 출처(플러그인명·버전·파일)를 blueprint 머리말에 적고, 프로젝트에 종속된 내용을 빼고,
  사용자와 합의한 내용만 옮긴다.
- **어디에**: 도메인 지식은 프로젝트 rules 템플릿(`project-*.md`)으로 두고 반드시 `paths` 스코프를
  건다. 항상 로드되는 글로벌 규칙에 넣지 않는다 (7월 위생 정리의 교훈).

## 6. 순서

각 단계는 하나의 커밋 묶음이고, 단계가 끝나면 `claude plugin validate . --strict`(§7의 제외 항목
기준)와 `/adt:sync-check`에 해당하는 점검을 통과해야 한다. 이 설계서와 구현 계획서도 같은 PR에 커밋한다.

1. 슬림화와 참조 정리 (§5.1) — 가장 크고, 뒤 단계가 고칠 파일 수를 줄여 준다.
2. 응답 말미 리포트 (§5.2)
3. Claude Code 격차 반영 (§5.3)
4. rkit 관련 정리와 흡수 절차 (§5.4, §5.5)
5. 릴리스: 버전 표기 6곳(`VERSION`, `plugin.json`, `package.json`, `marketplace.json` 2곳,
   `hooks.json` 설명 문구) 0.7.0, `CHANGELOG.md`, `HANDOFF.md`, PR 생성. 태그는 머지 후.

**머지 후 사용자가 하는 일** (구현 범위 밖, 완료 보고에 안내):
이 작업 트리를 `main`으로 되돌려 fast-forward → `/adt:ai-platform-defconfig` 재실행
(`~/.claude`를 바꾸는 수동 전용 스킬이다. `platform.md` 링크가 이때 생긴다) →
`workstations/registry.md`의 `pink-turtle-rt` 행 갱신 → rkit 비활성화.

**버전** — 에이전트 11개와 스킬 1개가 사라지는 호환성 깨짐이지만 0.x 단계이므로 `VERSIONING.md`의
0.x 규칙에 따라 0.7.0으로 한다. `VERSIONING.md`가 다르게 정하고 있으면 그쪽을 따른다.

## 7. 완료 기준

- `claude plugin validate . --strict` 결과에 루트 `CLAUDE.md` 경고와 `ICON_MISSING` 외의 항목이 없다.
- 저장소 전체에서 삭제된 에이전트·스킬·템플릿 이름을 검색했을 때, 남는 곳은 `CHANGELOG.md`,
  ADR, `docs/archive/`, `docs/superpowers/`뿐이다.
- 지침 성격 파일 전부 200줄 이내.
- blueprints와 `.claude/rules/` 파생본의 내용이 어긋나지 않는다.
- 훅이 실제로 동작한다: 200줄을 넘는 `.md` 편집 입력을 stdin JSON으로 넣었을 때 경고가 나온다.
- 저장소 어디에도 특정 모델 버전 숫자를 "현재 버전"으로 적은 지침이 없다.
- 프로젝트 디렉토리에 새 숨김 폴더·상태 파일을 만드는 코드나 지시가 없다.

## 8. 구현자에게 맡기는 것

- 줄어든 `design-principles.md`와 `global-workflow.md`의 구체적인 문장.
- `README.md`, `docs/usage-guide.md`의 재구성 범위 (삭제된 내용을 빼고 흐름이 읽히게).
- `hooks.json`을 따옴표 처리로 고칠지 exec 형식으로 바꿀지.
- blueprint 3종에서 새 필드를 표에 얼마나 자세히 적을지 (200줄 제한 안에서).
- 커밋을 단계 안에서 어떻게 나눌지.

## 9. 승인 기록

2026-11-17 사용자 승인. 리포트는 "다음 추천" 한 줄로 확정(§5.2)했고, 그 밖에 작성자가 채운 결정
([제안] 표시 항목 전부: 에이전트 1개만 유지, `/adt:review` 삭제, PR #11 닫기, `docs/index.html` 삭제,
도메인 지식 미이식, 타 도구·타 워크스테이션 범위 제외, 라이선스·작성자 표기, 템플릿 archive 단순화,
worktree 구현과 머지 후 수동 defconfig)은 제안대로 승인됐다.
