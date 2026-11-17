# adt 슬림화 및 재가동 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `adt` 플러그인에서 superpowers와 겹치는 개발 절차를 덜어내고, Claude Code v2.1.326 기준으로 맞춰 v0.7.0으로 릴리스한다.

**Architecture:** 이 저장소는 코드가 아니라 Markdown 지침·JSON 매니페스트·셸 훅 1개로 이루어진 플러그인이다. `blueprints/`가 원본, `.claude/rules/`가 파생본이며 둘은 항상 함께 고친다. "테스트"는 `claude plugin validate`, 이름 검색(`grep`), 줄 수 검사, 훅 stdin 입력 실행이다.

**Tech Stack:** Markdown, JSON, Bash, `claude` CLI v2.1.325+, `gh`, `git`

**Spec:** `docs/superpowers/specs/2026-11-17-adt-slim-revival-design.md` — 각 Task의 "설계서 §"는 이 문서의 절 번호다. 문장을 쓸 때는 반드시 해당 절을 읽는다.

## Global Constraints

- **작업 위치**: 별도 git worktree에서 한다 (`superpowers:using-git-worktrees`, 브랜치 `feat/slim-revival`). 원래 체크아웃 `/home/inseok/my_ai_manual`의 `.claude/rules/global-*.md`는 `~/.claude/rules/`에 심볼릭 링크로 걸려 있어, 거기서 고치면 모든 세션에 즉시 적용된다. 원래 체크아웃의 파일을 수정하지 않는다.
- `~/.claude/` 아래는 건드리지 않는다. `/adt:ai-platform-defconfig` 실행, rkit 비활성화, 로컬 `main` fast-forward는 머지 후 사용자가 한다.
- 지침 성격 파일(SKILL.md, `blueprints/*.md`, `CLAUDE.md`, `.claude/rules/*.md`, `claude/*.md`, `agents/*.md`)은 **200줄 이내**. `docs/` 하위는 제외.
- 문서는 한국어. 코드·명령어·경로·기술 용어는 영어 그대로. UTF-8, LF.
- 지침에 **특정 모델 버전 숫자를 적지 않는다**. 별칭 `opus` / `sonnet` / `haiku` / `fable`만 쓴다.
- 프로젝트 디렉토리에 숨김 상태 폴더·상태 파일을 만드는 코드나 지시를 넣지 않는다. 상태가 필요하면 `${CLAUDE_PLUGIN_DATA}`.
- SessionStart 훅, 출력 스타일, 새 훅을 추가하지 않는다. 훅은 지금의 PostToolUse 1개만 둔다.
- 설계서에 없는 규칙·지식을 지침이나 blueprint에 추가하지 않는다. 설계서 §5.3의 "확인하지 못한 것"은 반영하지 않는다.
- 커밋은 Conventional Commits (`feat` / `docs` / `chore`), 메시지 끝에 `Co-Authored-By: Claude Fable 5.2 <noreply@anthropic.com>`. `main`에 직접 push하지 않는다.
- 삭제는 `git rm`으로 한다 (git에서 복구 가능).

### 공통 점검 명령

각 Task 마지막의 "공통 점검"은 worktree 루트에서 다음 네 가지를 실행하는 것이다.

```bash
# (1) 삭제된 이름 잔존 — 출력이 없어야 한다 (Task 3 완료 전까지는 그 Task가 맡은 파일만 본다)
grep -rnE "ideation|product-manager|designer|design-validator|\breviewer\b|implementer|cto-lead|code-analyzer|verifier|\btester\b|report-generator|adt:review|(plan|design|report)\.template|docs/artifacts|0[1-4]-(plan|design|analysis|report)" \
  --include=*.md --include=*.json --include=*.html --include=*.sh . \
  | grep -vE "node_modules|^./CHANGELOG.md|^./docs/decisions/|^./docs/archive/|^./docs/superpowers/|^./HANDOFF.md"
```

```bash
# (2) 200줄 초과 지침 파일 — 출력이 없어야 한다
wc -l skills/*/SKILL.md blueprints/*.md CLAUDE.md .claude/rules/*.md claude/*.md agents/*.md | awk '$1>200 && $2!="total"'
```

```bash
# (3) 모델 버전 숫자 — 출력이 없어야 한다
grep -rnE "(Opus|Sonnet|Haiku|Fable) [0-9]" --include=*.md . | grep -vE "node_modules|^./CHANGELOG.md|^./docs/(archive|superpowers|decisions)/|^./HANDOFF.md"
```

```bash
# (4) 플러그인 검증 — Task 5 이후 "Validation passed"
claude plugin validate . --strict
```

`HANDOFF.md`는 Task 8에서 다시 쓰므로 그 전까지 (1)(3)에서 제외한다. Task 8 이후에는 제외 목록에서 `HANDOFF.md`를 빼고 실행한다.

## Review Focus

설계서가 암시하지만 놓치기 쉬운 조건들. 각 항목의 확인 단계는 괄호 안 Task에 들어 있다.

1. **superpowers가 설치되지 않은 환경** — 글로벌 규칙이 "절차는 superpowers가 수행"이라고만 하면 지시가 공중에 뜬다. 없을 때의 대안(기본 plan mode)이 같은 문단에 있어야 한다. (Task 2)
2. **`gap-detector`를 경로 없이 호출했고 `docs/superpowers/specs/`도 없는 프로젝트** — 추측으로 진행하지 않고 사용자에게 경로를 물어야 한다. (Task 1)
3. **플러그인 설치 경로에 공백이 있는 환경** (Windows 사용자 폴더 등, `pink-turtle-win`) — 훅 명령이 단어로 쪼개지지 않아야 한다. (Task 5)
4. **이미 배포된 프로젝트에 남은 옛 참조** — 배포 프로젝트의 `CLAUDE.md`·rules가 삭제된 `docs/artifacts/`나 에이전트 이름을 계속 가리킬 수 있다. `/adt:project-update`의 위생 검사가 이를 잡아야 다음 전파 때 드러난다. (Task 2)
5. **blueprint와 rules 파생본의 불일치** — 한쪽만 고치면 다른 도구용 지침과 Claude Code 지침이 갈라진다. 파생본마다 원본 대조 단계를 둔다. (Task 2, 4, 6)

---

### Task 1: 에이전트·스킬·템플릿 삭제와 `gap-detector` 재정의

설계서 §5.1 "에이전트 12개 → 1개", "스킬 11개 → 10개", "템플릿 4개 → 1개".

**Files:**
- Delete: `agents/{ideation,product-manager,designer,design-validator,reviewer,implementer,cto-lead,code-analyzer,verifier,tester,report-generator}.md` (11개)
- Delete: `skills/review/` 디렉토리
- Delete: `templates/{plan,design,report}.template.md`
- Modify: `agents/gap-detector.md`
- Modify: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `package.json` (설명 문구·키워드)

**Interfaces:**
- Produces: 남는 구성 요소 이름 — 에이전트 `gap-detector` 1개, 스킬 10개(`ai-platform-defconfig`, `project-init`, `project-configure`, `project-update`, `project-absorb`, `optimize-docs`, `handoff`, `sync-check`, `doc-gen`, `decision`), 템플릿 `decision.template.md` 1개. 이후 Task의 문서는 이 목록만 언급한다.
- Produces: 설명 문구 — `plugin.json`·`package.json`: `"AI 지침 라이브러리 — 10 스킬, blueprints 지식 체계, 프로젝트 배포·추적"`. `marketplace.json`의 plugin `description`: `"10 skills, blueprints knowledge system, project scaffolding and tracking"`, `metadata.description`: `"AI Development Toolkit — instruction library and project scaffolding"`.

- [ ] **Step 1: 삭제 전 상태 기록**

Run: `ls agents | wc -l; ls skills | wc -l; ls templates | wc -l`
Expected: `12`, `11`, `4`

- [ ] **Step 2: `git rm`으로 삭제**

위 Files의 Delete 대상 전부. `skills/review`는 `git rm -r`.

- [ ] **Step 3: `agents/gap-detector.md` 재정의**

프론트매터: `name: gap-detector`, `model: opus`, `effort: high`, `color: cyan` 유지, `tools`에서 `Write` 제거(`Read`, `Glob`, `Grep`, `Bash`). `hooks`/`mcpServers`/`permissionMode`/`initialPrompt` 필드는 두지 않는다.
`description`: PDCA·`verifier` 언급을 빼고 "설계 문서와 구현 코드의 일치도를 항목별로 판정해 매칭율을 산출한다. 구현을 마친 뒤 설계 대비 누락을 확인할 때 사용" 취지로 쓴다.
본문 입력 절은 다음 순서로 정한다:
1. 호출 시 전달받은 설계 문서 경로
2. 없으면 `docs/superpowers/specs/`에서 수정 시각이 가장 최근인 `.md`
3. 그것도 없으면 **진행하지 않고 설계 문서 경로를 요청**한다
출력: 파일을 쓰지 않고 응답으로 돌려준다. 판정 기호(✅ ⚠️ ❌ 🔄)와 매칭율 산식 `(일치 + 부분일치×0.5) / 전체 × 100`은 기존 그대로 둔다.

- [ ] **Step 4: 매니페스트 설명 문구·키워드 교체**

Interfaces의 문구를 그대로 넣는다. `keywords`에서 `development-pipeline`, `code-review`, `agents`를 빼고 `instruction-library`를 넣는다. 버전 숫자는 Task 8에서 바꾼다.

- [ ] **Step 5: 확인**

Run: `ls agents skills templates; grep -c "docs/artifacts\|PDCA\|verifier" agents/gap-detector.md; python3 -c "import json;[json.load(open(f)) for f in ['.claude-plugin/plugin.json','.claude-plugin/marketplace.json','package.json']];print('json ok')"`
Expected: `agents`에 `gap-detector.md`만, `skills`에 10개, `templates`에 `decision.template.md`만, grep 결과 `0`, `json ok`. `gap-detector.md` 본문에 "경로를 요청" 문구가 있는지 눈으로 확인한다 (Review Focus 2).

- [ ] **Step 6: 커밋**

`feat!: 파이프라인 에이전트 11개, /adt:review, 템플릿 3개 제거 — 개발 절차를 superpowers에 위임`

---

### Task 2: 절차 규칙 슬림화

설계서 §5.1 "절차 규칙". 원본과 파생본, 배포용 템플릿을 한 Task에서 함께 고친다.

**Files:**
- Modify: `blueprints/design-principles.md` (현재 185줄, §1~§4)
- Modify: `.claude/rules/global-workflow.md` (현재 88줄)
- Modify: `blueprints/agent-runtime.md` (삭제된 에이전트를 예로 든 부분만)
- Modify: `claude/global_CLAUDE.md` (rules 표의 `workflow.md` 설명)
- Modify: `claude/project_CLAUDE.md` §7 (121~156줄)
- Modify: `skills/project-update/SKILL.md` (§3.5 위생 검사)
- Modify: `.claude/rules/README.md` (`global-workflow.md` 행 설명이 바뀌면)

**Interfaces:**
- Consumes: Task 1의 남는 구성 요소 이름.
- Produces: `design-principles.md`의 새 절 구성 — `## 1. 설계 우선 원칙`, `## 2. 코드 설명 문서`, `## 3. 기술 부채 명시`. 다른 문서가 이 blueprint의 절을 가리킬 때 이 번호를 쓴다.

- [ ] **Step 1: `blueprints/design-principles.md` 다시 쓰기**

지우는 것: 기존 §1(단계·프리셋·단계 결정 규칙), §2.1~§2.4 중 `docs/artifacts/` 단계별 디렉토리·파일 네이밍·문서 헤더·프리셋별 산출물, §3 전체(파이프라인·팀·품질 루프).
남기는 것:
- §1 설계 우선 원칙 — 한두 단락. 반드시 담을 내용: (a) 작업 크기에 맞는 절차를 밟는다, (b) 설계는 사용자 승인 후 구현한다, (c) Claude Code에서는 `superpowers` 플러그인이 이 절차를 수행한다, (d) **superpowers가 없으면 기본 plan mode를 쓴다**, (e) 설계 문서 위치는 절차 도구가 정한 곳을 따른다(superpowers면 `docs/superpowers/specs/`), (f) 더 나은 방법이 있으면 설계 단계에서 대안을 제안한다.
- §2 코드 설명 문서 — 기존 `docs/source/` 규칙 그대로.
- §3 기술 부채 명시 — 기존 `TODO`/`FIXME`/`HACK` 블록 그대로.

- [ ] **Step 2: `.claude/rules/global-workflow.md`를 같은 내용의 요약본으로 줄이기**

프론트매터 `description`을 `"설계 우선 원칙 — 절차 위임, 코드 설명 문서, 기술 부채 표기"`로 바꾼다. `> 원본: blueprints/design-principles.md` 줄 유지. Step 1의 (a)~(f)가 모두 들어가야 한다.

- [ ] **Step 3: 나머지 파일 정리**

- `blueprints/agent-runtime.md`: `designer`, `implementer` 등 삭제된 에이전트 예시를 `gap-detector` 또는 일반 표현으로 바꾼다. 필드 표와 수치는 Task 6에서 고치므로 여기서는 건드리지 않는다.
- `claude/global_CLAUDE.md`: rules 표 `workflow.md` 행 역할을 "설계 우선 원칙, 코드 설명 문서, 기술 부채 표기"로.
- `claude/project_CLAUDE.md` §7: 설계서 §5.1의 "`claude/project_CLAUDE.md` §7" 세 항목대로. `docs/artifacts/` 트리, `{plan,design,analysis,report}.md` 고정 구조, `_INDEX.md`의 Match Rate 열을 없애고, archive 대상을 "완료된 작업의 설계서·계획서"로 다시 적는다. 설계 문서 위치는 고정하지 않는다.
- `skills/project-update/SKILL.md` §3.5 위생 검사 목록에 한 항목 추가: 대상 프로젝트의 `CLAUDE.md`·`.claude/rules/`에 `docs/artifacts/` 또는 v0.7.0에서 삭제된 에이전트 이름(`ideation`, `designer`, `implementer` 등)이 남아 있으면 보고한다 (Review Focus 4).

- [ ] **Step 4: 확인**

Run: `grep -c "plan mode" blueprints/design-principles.md .claude/rules/global-workflow.md; grep -c "superpowers" blueprints/design-principles.md .claude/rules/global-workflow.md; grep -n "Small\|Medium\|Large\|프리셋\|docs/artifacts" blueprints/design-principles.md .claude/rules/global-workflow.md claude/global_CLAUDE.md claude/project_CLAUDE.md blueprints/agent-runtime.md`
Expected: 앞의 두 grep은 파일마다 1 이상 (Review Focus 1), 세 번째는 출력 없음.

원본·파생본 대조 (Review Focus 5): `design-principles.md`의 (a)~(f) 각각이 `global-workflow.md`에 있는지 한 줄씩 확인한다.

공통 점검 (1)을 이 Task의 Files에 한정해 실행 → 출력 없음. (2) → 출력 없음.

- [ ] **Step 5: 커밋**

`docs!: 개발 단계 프리셋·서브에이전트 파이프라인 규칙 제거 — 설계 우선 원칙만 유지`

---

### Task 3: 문서 참조 정리, 옛 산출물 보관, 결정 기록

설계서 §5.1 "참조 정리", "기존 PDCA 산출물", "결정 기록".

**Files:**
- Modify: `README.md`, `docs/project-structure.md`, `docs/usage-guide.md`, `TOOL_REFERENCE.md`
- Delete: `docs/index.html`
- Move: `docs/01-plan/features/plugin-migration.plan.md`, `docs/02-design/features/plugin-migration.design.md`, `docs/03-analysis/plugin-migration.analysis.md`, `docs/04-report/plugin-migration.report.md` → `docs/archive/2026-04/plugin-migration/{plan,design,analysis,report}.md`
- Create: `docs/archive/2026-04/_INDEX.md`
- Create: `docs/decisions/ADR-002-slim-down-delegate-process-to-superpowers.md`

**Interfaces:**
- Consumes: Task 1의 구성 요소 목록, Task 2의 `design-principles.md` 절 번호.

- [ ] **Step 1: 옛 산출물 이동과 소개 페이지 삭제**

`git mv`로 4개 파일을 옮기고 빈 `docs/0[1-4]-*` 디렉토리가 남지 않게 한다. `git rm docs/index.html`.
`_INDEX.md`: 표 한 줄 — 기능명 `plugin-migration`, 완료 월 `2026-04`, 한 줄 요약(v0.4.0 플러그인 전환), 비고 "v0.7.0에서 PDCA 산출물 구조 폐기 후 보관".

- [ ] **Step 2: ADR-002 작성**

`templates/decision.template.md` 형식. 필수 내용: 날짜 2026-11-17, 상태 채택, 맥락(설계서 §1), 검토한 선택지 A/B/C(설계서 §4 표), 결정 A, 결과(에이전트 12→1, 스킬 11→10, 템플릿 4→1), 그리고 "ADR-001의 채택 항목 4 '에이전트 템플릿 참조'는 이 결정으로 대체된다"는 문장. ADR-001 파일에도 상태 줄 아래에 "항목 4는 ADR-002로 대체됨" 한 줄을 더한다.

- [ ] **Step 3: 네 문서 고치기**

- `docs/project-structure.md`: 스킬 표 10개, 에이전트 표 1개(`gap-detector`, opus), 디렉토리 구조(templates 1개, `docs/archive/`, `docs/superpowers/` 추가, `docs/index.html`·`docs/0x-*` 제거, `VERSION` 주석의 버전 숫자 제거), 계층 설명의 "서브에이전트 파이프라인" 문구.
- `README.md`, `docs/usage-guide.md`: 파이프라인·PDCA·`/adt:review`·삭제된 템플릿을 설명하는 부분을 빼고, "개발 절차는 superpowers를 함께 설치해 쓴다"는 안내를 설치 절 근처에 한 번 넣는다. 재구성 범위는 구현자 재량(설계서 §8).
- `TOOL_REFERENCE.md`: 삭제된 이름 언급만 정리한다 (`AGENTS.md` 내용 추가는 Task 6).

- [ ] **Step 4: 확인**

공통 점검 (1) 전체 실행 → 출력 없음 (`HANDOFF.md` 제외 상태). (2) → 출력 없음.
Run: `ls docs; ls docs/archive/2026-04/plugin-migration`
Expected: `docs`에 `01-plan`~`04-report`, `index.html` 없음. archive에 4개 파일.

- [ ] **Step 5: 커밋**

`docs: 삭제된 파이프라인 참조 정리, PDCA 산출물 보관, ADR-002 추가`

---

### Task 4: 응답 말미 "다음 추천" 규칙

설계서 §5.2.

**Files:**
- Modify: `blueprints/base-directives.md` (원본)
- Modify: `.claude/rules/global-communication.md` (파생본, "커뮤니케이션 규칙" 절)
- Modify: `CLAUDE.md` (§4.8 삭제)

- [ ] **Step 1: 원본과 파생본에 규칙 추가**

두 파일의 커뮤니케이션 규칙 목록에 같은 뜻의 항목을 넣는다. 고정 문구:

```
- 다음 작업 제안이 있을 때만 응답 맨 끝에 `💡 다음: <추천>` 한 줄을 붙인다 (제안할 내용이 없으면 생략)
```

사용한 기능·안 쓴 기능을 나열하는 리포트는 넣지 않는다. 기존 "선택지 제시 시 제안사항과 추천 포함" 항목은 그대로 두고 문구를 합치지 않는다.

- [ ] **Step 2: `CLAUDE.md` §4.8 삭제**

"### 4.8 응답 말미 규칙" 절 전체(rkit 언급 포함)를 지운다. 뒤따르는 절 번호가 없으므로 번호 조정은 없다.

- [ ] **Step 3: 확인**

Run: `grep -c "💡 다음" blueprints/base-directives.md .claude/rules/global-communication.md CLAUDE.md; grep -rn "rkit" CLAUDE.md`
Expected: `1`, `1`, `0`. 두 번째 명령은 출력 없음.

- [ ] **Step 4: 커밋**

`docs: 응답 말미 "다음 추천" 한 줄 규칙을 글로벌 규칙으로 승격`

---

### Task 5: 플러그인 검증 통과

설계서 §5.3 "플러그인 자체".

**Files:**
- Modify: `hooks/hooks.json`
- Modify: `.claude-plugin/plugin.json`
- Create: `LICENSE`

- [ ] **Step 1: 실패 확인**

Run: `claude plugin validate . --strict`
Expected: 실패. `hooks.PostToolUse: Shell command uses ${CLAUDE_PLUGIN_ROOT} without quotes` 경고와 `LICENSE_MISSING`.

- [ ] **Step 2: 훅 명령을 공백 안전하게**

`hooks/hooks.json`의 `command`에서 `${CLAUDE_PLUGIN_ROOT}`가 포함된 경로를 큰따옴표로 감싸거나 exec 형식(`"command": "bash", "args": ["${CLAUDE_PLUGIN_ROOT}/hooks/post-edit-check.sh"]`)으로 바꾼다. `matcher`, `if`, `timeout`은 그대로.

- [ ] **Step 3: 라이선스·작성자 표기**

`plugin.json`에 `"author": { "name": "PinkTultle" }`, `"license": "MIT"` 추가 (`package.json`의 값과 동일). 루트에 표준 MIT `LICENSE` 파일, 저작권 줄 `Copyright (c) 2026 PinkTultle`.

- [ ] **Step 4: 검증 통과 확인**

Run: `claude plugin validate . --strict`
Expected: `Validation passed`. 디렉토리 등재용 안내에 `ICON_MISSING`만 남는다 (아이콘은 만들지 않는다). 루트 `CLAUDE.md` 경고가 나와 `--strict`가 실패하면 `--strict` 없이 실행해 남은 항목이 그 경고와 `ICON_MISSING`뿐인지 확인하고, 그 사실을 커밋 메시지 본문에 적는다.

- [ ] **Step 5: 훅 동작 확인 (공백 포함 경로)**

```bash
D="$(mktemp -d)/my dir/blueprints"; mkdir -p "$D"; seq 1 201 > "$D/big.md"; seq 1 10 > "$D/small.md"
printf '{"tool_input":{"file_path":"%s"}}' "$D/big.md"   | bash hooks/post-edit-check.sh
printf '{"tool_input":{"file_path":"%s"}}' "$D/small.md" | bash hooks/post-edit-check.sh
```

Expected: 첫 줄만 `[warn] ... 201줄 — 200줄 제한 초과` 출력, 둘째는 출력 없음 (Review Focus 3). 스크립트가 공백 경로에서 실패하면 `post-edit-check.sh`의 변수 인용을 고친다.

- [ ] **Step 6: 커밋**

`fix(plugin): 훅 명령 경로 인용, plugin.json 라이선스·작성자 표기, LICENSE 추가`

---

### Task 6: Claude Code v2.1.326 격차를 blueprint에 반영

설계서 §5.3 "blueprint 3종 갱신", "모델 표기". 넣을 사실은 설계서 §5.3 목록이 전부다. 목록에 없는 내용은 넣지 않는다.

**Files:**
- Modify: `blueprints/agent-runtime.md` (135줄), `blueprints/hooks.md` (136줄), `blueprints/memory-and-context.md` (128줄)
- Modify: `.claude/rules/global-platform.md` (51줄, 세 blueprint의 요약본)
- Modify: `TOOL_REFERENCE.md`
- Modify: `.claude-plugin/plugin.json`, `package.json`의 `engines` (값 확인만, 필요 시)

- [ ] **Step 1: `agent-runtime.md`**

- §2.3 상한 표에서 "세션당 총 생성 수 | 200 | `CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION`" 행 삭제, 바로 아래 "상한에 닿을 규모라면…" 문장을 남은 상한(중첩 깊이, 동시 실행)에 맞게 고친다.
- 서브에이전트 필드 표에 `omitClaudeMd`, `autoCompactWindow`, `experimental.cacheTtl`(`5m`/`1h`) 추가.
- "플러그인 서브에이전트에서는 `hooks`, `mcpServers`, `permissionMode`, `initialPrompt`가 무시된다 — 훅은 `hooks/hooks.json`, MCP는 `.mcp.json`에 둔다" 추가.
- effort: 환경변수 `CLAUDE_CODE_SUBAGENT_EFFORT` 추가.
- 스킬 필드 표를 현재 목록에 맞춘다: `when_to_use`, `disallowed-tools`, `user-invocable`, `background`, `paths`, `shell` 추가. `description`+`when_to_use` 합산 1,536자에서 잘림.
- `disable-model-invocation`: AI가 호출하려 하면 사용자에게 직접 실행을 요청한다.
- `allowed-tools`나 hooks를 선언한 스킬은 예약 작업·`/loop`에서 실행 전 확인을 받는다.
- 신규 모델에서는 `TodoWrite`·`Task*` 도구를 쓸 수 없다 — 스킬·에이전트 지시가 이 도구를 전제하지 않게 한다.

- [ ] **Step 2: `hooks.md`**

- 이벤트 목록을 33종으로 맞춘다: SessionStart, Setup, UserPromptSubmit, UserPromptExpansion, PreToolUse, PermissionRequest, PermissionDenied, PostToolUse, PostToolUseFailure, PostToolBatch, Notification, MessageDisplay, SubagentStart, SubagentStop, TaskCreated, TaskCompleted, Stop, StopFailure, TeammateIdle, InstructionsLoaded, ConfigChange, CwdChanged, DirectoryAdded, FileChanged, WorktreeCreate, WorktreeRemove, PreCompact, PostCompact, PreModelSwitch, PostModelSwitch, Elicitation, ElicitationResult, SessionEnd.
- 공통 stdin 필드에 `prompt_id`, `scratchpad_dir`, `effort` 추가.
- Stop·SubagentStop에서 마지막 응답은 `last_assistant_message`로 읽는다.
- `additionalContext`·`systemMessage`·stdout 상한 10,000자 (넘으면 파일로 저장되고 2,000자 미리보기만 전달).
- `onFailure: "block"`.
- `if`는 권한 규칙 1개만 받고 도구 이벤트 5종에서만 평가된다.
- 셸 형식 명령에서 `${CLAUDE_PLUGIN_ROOT}`는 따옴표로 감싸거나 exec 형식을 쓴다.
- 플러그인 상태는 `${CLAUDE_PLUGIN_DATA}`(`~/.claude/plugins/data/<id>/`)에 두고 `${CLAUDE_PLUGIN_ROOT}`나 프로젝트 디렉토리에 쓰지 않는다.

- [ ] **Step 3: `memory-and-context.md`**

- `AGENTS.md`: 작업 디렉토리와 상위에 `CLAUDE.md`가 없을 때만 읽는다.
- `MEMORY.md`는 세션 시작 시 첫 200줄 또는 25KB만 로드된다.
- `/doctor prompt-audit`로 CLAUDE.md·rules·skills·agents를 감사할 수 있다.
- 플러그인 루트의 `CLAUDE.md`는 플러그인 사용자에게 로드되지 않는다.

- [ ] **Step 4: 파생본과 `TOOL_REFERENCE.md`**

`.claude/rules/global-platform.md`: 위 세 파일에서 바뀐 사실 중 요약본이 이미 다루는 항목(상한, 훅 입출력, auto memory)을 맞춘다. 200개 상한 문구가 있으면 지운다.
`TOOL_REFERENCE.md`: Claude Code 항목에 `AGENTS.md` 조건부 로드 한 줄.

- [ ] **Step 5: 확인**

Run: `grep -rn "CLAUDE_CODE_MAX_SUBAGENTS_PER_SESSION\|세션 200\|세션당 총" blueprints .claude/rules; grep -c "PreModelSwitch" blueprints/hooks.md; grep -c "CLAUDE_PLUGIN_DATA" blueprints/hooks.md; grep -c "AGENTS.md" blueprints/memory-and-context.md TOOL_REFERENCE.md; grep -rnE "TodoWrite|TaskCreate" skills .claude/rules`
Expected: 첫 명령 출력 없음, 다음 셋은 각 1 이상, 마지막은 출력 없음.

원본·파생본 대조 (Review Focus 5): `global-platform.md`의 각 문장이 세 blueprint와 어긋나지 않는지 읽어 확인한다.
공통 점검 (2)(3)(4) → 통과. `engines` 값 `>=2.1.202`에 대해 validate가 경고하지 않으면 그대로 둔다.

- [ ] **Step 6: 커밋**

`docs(blueprints): Claude Code v2.1.326 기준 에이전트·스킬·훅·메모리 사양 반영`

---

### Task 7: 외부 지식 흡수 절차

설계서 §5.5, §5.4 중 저장소 안에서 할 수 있는 부분.

**Files:**
- Modify: `blueprints/README.md` ("새 blueprint 추가" 절)

- [ ] **Step 1: 절차 추가**

"새 blueprint 추가" 절 아래에 "외부 플러그인·프로젝트에서 지식 가져오기" 소절을 만든다. 담을 규칙 세 가지 (설계서 §5.5 그대로):
1. 실제 작업에서 그 지식이 필요했던 경우에만 가져온다. 미리 옮기지 않는다.
2. 출처(플러그인명·버전·파일)를 blueprint 머리말에 적고, 프로젝트 종속 내용을 뺀 뒤, 사용자와 합의한 내용만 옮긴다.
3. 도메인 지식은 프로젝트 rules 템플릿(`project-*.md`)으로 두고 `paths` 스코프를 건다. 항상 로드되는 글로벌 규칙에 넣지 않는다.

`.gitignore`의 `.rkit/` 항목은 그대로 둔다 (수정 없음).

- [ ] **Step 2: 확인**

Run: `grep -n "paths" blueprints/README.md; wc -l blueprints/README.md`
Expected: 새 소절에 `paths` 언급 1건 이상, 200줄 이내.

- [ ] **Step 3: 커밋**

`docs(blueprints): 외부 지식 흡수 절차 추가`

---

### Task 8: v0.7.0 릴리스와 PR

설계서 §6-5, §7.

**Files:**
- Modify: `VERSION`, `.claude-plugin/plugin.json`, `package.json`, `.claude-plugin/marketplace.json`(2곳), `hooks/hooks.json`(설명 문구) — 0.6.0 → 0.7.0
- Modify: `CHANGELOG.md`, `HANDOFF.md`

- [ ] **Step 1: 버전 6곳 변경**

`VERSIONING.md`를 읽어 0.x 단계의 호환성 깨짐 표기 규칙을 확인하고 따른다. 규칙이 다른 번호를 요구하면 그 번호를 쓰고 PR 본문에 적는다.

Run: `grep -rn "0\.6\.0" --include=*.json VERSION . | grep -v node_modules`
Expected: 출력 없음.

- [ ] **Step 2: `CHANGELOG.md` `[0.7.0] - 2026-11-17`**

Keep a Changelog 형식. Removed(에이전트 11, `/adt:review`, 템플릿 3, 단계 프리셋·파이프라인 규칙, `docs/index.html`), Changed(`gap-detector` 입력·출력, 절차를 superpowers에 위임, archive 패턴, 설명 문구), Added(다음 추천 규칙, ADR-002, `LICENSE`, 흡수 절차, v2.1.326 사양), Fixed(훅 경로 인용). 호환성 깨짐을 머리말에 명시한다.

- [ ] **Step 3: `HANDOFF.md` 다시 쓰기**

기존 형식(마지막 작업 요약 / 현재 상태 / 주의사항 / 다음 작업 후보 / 워크스테이션 표) 유지, 내용은 이번 작업 기준. "다음 작업 후보"에 머지 후 사용자가 할 일을 순서대로 적는다:
1. 원래 체크아웃을 `main`으로 되돌려 fast-forward
2. `/adt:ai-platform-defconfig` 재실행 (`platform.md` 링크 생성) 후 `workstations/registry.md`의 `pink-turtle-rt` 행 갱신
3. rkit 비활성화와 작업 트리의 `.rkit/` 삭제
4. 태그 `v0.7.0`
5. 다른 워크스테이션·배포 프로젝트 3개 전파
옛 에이전트 이름이 남지 않게 한다.

- [ ] **Step 4: 전체 완료 기준 점검 (설계서 §7)**

공통 점검 (1)을 제외 목록에서 `HANDOFF.md`를 빼고 실행 → 출력 없음. (2)(3) → 출력 없음. (4) → `Validation passed`. Task 5 Step 5의 훅 확인을 다시 실행 → 같은 결과.
Run: `grep -rnE "\.rkit|mkdir.*\.[a-z]+/" skills hooks | grep -v "\.claude"`
Expected: 프로젝트에 숨김 상태 폴더를 만드는 지시가 없다.
Run: `git status --short`
Expected: 커밋되지 않은 변경은 이 Task의 파일뿐.

- [ ] **Step 5: 커밋, push, PR**

커밋: `chore: v0.7.0 — 슬림화 및 Claude Code v2.1.326 대응`
`git push -u origin feat/slim-revival` 후 `gh pr create --repo PinkTultle/ai-dev-toolkit --base main`. PR 본문: 무엇이 빠지고 남았는지, 호환성 깨짐, 머지 후 사용자가 할 일 5가지, 검증 결과. 본문 끝에 `🤖 Generated with [Claude Code](https://claude.com/claude-code)`. 머지와 태그는 하지 않는다.
