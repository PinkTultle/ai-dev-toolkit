# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-11-17
**작업 내용**: v0.7.0 — 슬림화(개발 절차를 superpowers에 위임) + Claude Code v2.1.326 대응
**버전**: v0.6.0 → **v0.7.0**
**브랜치**: `feat/slim-revival` (PR → main 필요)
**작업 워크스테이션**: `pink-turtle-rt`

### 배경

7월 갱신(v0.5.0·v0.6.0) 이후 다시 4개월 공백. 그동안 팀 배포 플러그인 `rkit`을 썼지만 꼭 맞지 않았고,
`rkit` 대신 `adt`를 일상 도구로 쓰기로 했다. 한 세션에 `rkit`·`superpowers`·`adt` 규칙이 겹쳐
절차 지시가 세 갈래로 들어오던 것이 `adt`를 안 쓰게 된 구조적 원인이었다.

- 설계서: `docs/superpowers/specs/2026-11-17-adt-slim-revival-design.md`
- 구현 계획: `docs/superpowers/plans/2026-11-17-adt-slim-revival.md`
- 결정 기록: `docs/decisions/ADR-002-slim-down-delegate-process-to-superpowers.md`

### 이번 세션 완료 작업

- [x] **슬림화** — 에이전트 12 → 1(`gap-detector`), 스킬 11 → 10(코드 리뷰 스킬 삭제), 템플릿 4 → 1(ADR)
- [x] **절차 규칙 제거** — `design-principles.md`·글로벌 `workflow.md`에서 단계 프리셋, 단계별 산출물 디렉토리,
      서브에이전트 파이프라인 삭제. 절차는 superpowers(없으면 기본 plan mode)에 위임
- [x] **참조 정리** — README, project-structure, 프로젝트 템플릿 §7, project-configure/absorb 예시.
      옛 PDCA 산출물은 `docs/archive/2026-04/`로 이동, `docs/index.html` 삭제
- [x] **"다음 추천" 한 줄** — 저장소 전용이던 규칙을 글로벌 규칙으로 승격 (rkit에서 가져온 유일한 요소)
- [x] **플러그인 검증** — 훅 경로 인용, `plugin.json` 작성자·라이선스, `LICENSE` 추가
- [x] **Claude Code v2.1.220 → v2.1.326 격차 반영** — 플랫폼 blueprint 3종 + `global-platform.md`
- [x] **외부 지식 흡수 절차** — `blueprints/README.md`
- [x] `/adt:project-update` 위생 검사에 (d) 옛 파이프라인 참조 점검 추가
- [x] PR `PinkTultle/ai-dev-toolkit#11`(모델 버전 표기·팀 분할 임계치) 닫음 — 구조 자체가 사라짐

### 검증 결과

| 항목 | 결과 |
|------|------|
| 구성 요소 수 | 에이전트 1 / 스킬 10 / 템플릿 1 |
| JSON 4개 유효성 | 통과 |
| 지침 파일 200줄 제한 | 전부 이내 |
| 삭제된 이름 잔존 검색 | 0건 (CHANGELOG·ADR·archive·설계서, project-update 위생 검사 문구 제외) |
| 모델 버전 숫자 표기 | 0건 |
| `claude plugin validate . --strict` (v2.1.325) | 루트 `CLAUDE.md` 경고 + `ICON_MISSING`만 남음 (둘 다 의도적으로 유지) |
| 훅 실동작 (공백 포함 경로, stdin JSON) | 201줄 파일에 경고, 10줄 파일은 무출력 |

### 현재 상태

- **버전**: **v0.7.0** — 2026-11-20 `main`에 머지 (PR #12 슬림화, #13 전역 gitignore). **태그 없음**
- **스킬**: 10개 / **에이전트**: 1개 / **템플릿**: 1개 / **Blueprints**: 9개
- **글로벌 rules**: 5개 (environment, communication, workflow, platform, code-review)
- **이 워크스테이션(`pink-turtle-rt`)**: 원래 체크아웃 `~/my_ai_manual`은 로컬 `main`(v0.4.2)에 머물러 있다.
  `~/.claude/rules/`에는 링크 4개뿐이고 `platform.md`가 없다 (defconfig 2026-03-24 이후 미실행).
  전역 gitignore(`~/.config/git/ignore`)에는 `.rkit/`, `.superpowers/`, `.claude/worktrees/`를 수동으로 넣어 두었다
- **배포 프로젝트**: NDT-BPE_pork · aralm_program · mr-noti-bot 모두 v0.5.0 (`pink-turtle`에 있음)

### 주의사항

- **글로벌 rules 심볼릭 링크는 브랜치가 아니라 작업 트리의 파일을 가리킨다.** 원래 체크아웃에서
  브랜치를 바꾸거나 `global-*.md`를 고치면 커밋 전에도 모든 세션에 바로 적용된다.
  그래서 이번 구현은 `.claude/worktrees/slim-revival`에서 했다
- **superpowers 의존** — 개발 절차는 superpowers가 수행한다. 없으면 기본 plan mode로 대체된다고
  규칙에 적어 두었지만, 실사용 검증은 superpowers가 있는 환경에서만 했다
- **rkit은 아직 켜져 있다.** 저장소 `CLAUDE.md` §4.8(rkit 리포트 생략 지시)을 지웠으므로,
  rkit을 끄기 전까지 이 저장소에서 rkit의 Feature Usage 리포트 지시가 다시 살아난다
- **`engines`는 `>=2.1.202` 유지** — v2.1.323부터 범위 밖 버전에서는 플러그인이 로드되지 않는다
- **`usage-guide.md`는 손대지 않았다** — 삭제된 이름은 없지만 v0.3.x 시절 설명(프로젝트에 스킬 복제 등)이
  남아 있어 별도 정리가 필요하다
- **`cursor/`, `copilot/`, `windsurf/` 지침은 이번 범위 밖** — 4월 이후 그대로다
- **로컬에 stash 1건** — 닫은 PR #11의 원본 변경. 필요 없으면 삭제 가능

### 다음 작업 후보

순서대로 (전부 사용자가 직접 하는 일):

1. **원래 체크아웃을 `main`으로 fast-forward** — 이때 글로벌 규칙이 새 내용으로 바뀐다
2. **`/adt:ai-platform-defconfig` 재실행** — `platform.md` 링크 생성. 이후 `workstations/registry.md`의
   `pink-turtle-rt` 행을 v0.7.0으로 갱신
3. **rkit 비활성화** + 작업 트리의 `.rkit/` 삭제 (`.gitignore`의 `.rkit/` 항목은 유지)
4. **태그 `v0.7.0`**
5. **다른 워크스테이션·배포 프로젝트 3개 전파** — `/adt:project-update`의 위생 검사 (d)가
   옛 파이프라인 참조를 잡아 준다

그 외:

6. `docs/usage-guide.md` 현행화
7. 타 도구(cursor 등) 지침을 유지할지 정리할지 판단
8. web_hook_server registry 행 삭제 판단 (7월부터 이월)

### 학습 사항

- **최신화만으로는 다시 쓰게 되지 않는다.** 7월에 런타임 격차를 다 메웠는데도 안 쓰였다.
  원인은 낡음이 아니라 **다른 도구와 역할이 겹친 것**이었다. 갱신 전에 "왜 안 썼는가"를 먼저 묻는다
- **겹치는 것은 덜어내는 쪽이 유지된다.** 혼자 유지하는 도구는 다른 도구가 못 하는 것만 남겨야 한다
- **상시 개입은 비용이다.** rkit에서 불편했던 것은 특정 기능이 아니라 프로젝트마다 생기는 상태 폴더와
  세션마다 주입되는 지시였다. `adt`는 훅 1개 수준을 넘기지 않는다
- **로컬만 보고 판단하지 않는다.** 이번 세션 초반에 로컬 `main`(v0.4.2)만 보고 "7개월간 변경 없음"으로
  오판했다. 원격은 v0.6.0이었다. 작업 시작 시 `git fetch`로 원격과의 차이를 먼저 확인한다
- **공식 검증 도구를 완료 기준으로 쓴다.** `claude plugin validate --strict`가 사람이 놓친 5건을 잡았다
- **런타임 사실은 문서를 읽어 확인한다.** blueprint의 "세션당 200개 상한"과 "AGENTS.md를 읽지 않는다"는
  4개월 만에 틀린 내용이 됐다

---

## 워크스테이션 환경 메모

> 상세 환경 정보는 `workstations/<alias>.json` 참조.

| 별칭 | 환경 | 상태 파일 | defconfig 최종 실행일 | 라이브러리 버전 |
|------|------|----------|---------------------|----------------|
| pink-turtle | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle.json` | 2026-04-12 | v0.5.0 |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle-rt.json` | 2026-03-24 | v0.3.0 |
| pink-turtle-win | MINGW64 (Git Bash, Win11) | `workstations/pink-turtle-win.json` | 2026-03-26 | v0.3.0 |
