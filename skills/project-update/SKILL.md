---
name: project-update
description: 라이브러리 최신 버전을 배포된 프로젝트에 적용 — diff 비교, 커스텀 보존, 버전 갱신
argument-hint: "[target-directory-path]"
allowed-tools: Read, Bash, Glob, Grep, Write, Edit
disable-model-invocation: true
---

# Project Update

라이브러리의 최신 지침을 기존 배포 프로젝트에 적용한다.
프로젝트의 커스텀 내용을 보존하면서 템플릿 골격을 갱신한다.

## 인자

- `$0` — 타겟 프로젝트 경로 (미지정 시 deploy.json에서 목록 제시)

## 이 저장소 경로

`REPO_DIR`은 `ai-dev-toolkit` 저장소의 **git 클론 경로**다. 아래 순서로 정한다:

1. `~/.claude/CLAUDE.md`가 심볼릭 링크면 그 대상(`<REPO_DIR>/claude/global_CLAUDE.md`)에서 역산한다
2. 아니면 `${CLAUDE_PLUGIN_ROOT}`가 git 작업 트리일 때 그 경로를 쓴다
   (`git -C "${CLAUDE_PLUGIN_ROOT}" rev-parse --is-inside-work-tree`)
3. 둘 다 아니면 사용자에게 클론 경로를 묻는다. 클론이 없으면 `git clone` 안내 후 중단한다

플러그인 캐시(`~/.claude/plugins/cache/...`)는 `REPO_DIR`로 쓰지 않는다 — 플러그인 업데이트 때
교체되어 심볼릭 링크가 끊기고 `workstations/` 기록이 사라진다. 정한 경로는 사용자에게 보여 주고 확인받는다.

## 사전 조건

- 타겟 프로젝트에 `CLAUDE.md`가 존재해야 한다 (project-init 완료 상태)
- `CLAUDE.md` 헤더에 기반 버전이 기록되어 있어야 한다

## 실행 흐름

### 1. 대상 선정

인자가 없으면:
1. `workstations/` 디렉토리에서 현재 워크스테이션의 `<alias>.local.json`을 찾는다
2. `deployed_projects`에서 배포된 프로젝트 목록을 번호로 제시 (현재 버전 함께 표시)
3. 사용자가 선택

### 2. 버전 비교

```
라이브러리 VERSION 파일  →  현재 버전 (예: 0.2.0)
프로젝트 CLAUDE.md 헤더  →  기반 버전 (예: 0.1.0.3)
```

- 라이브러리 버전 > 기반 버전 앞 3자리 → 업데이트 가능
- 동일 → "이미 최신 버전입니다" 안내 후 종료
- 라이브러리 버전 < 기반 버전 → 비정상 상태 경고

### 3. 변경사항 분석

라이브러리의 기반 버전 태그와 현재 버전 사이의 변경을 분석한다:
1. `git diff v<기반버전>..HEAD` 로 변경된 파일 목록 확인
2. 프로젝트에 영향 있는 변경만 필터링:
   - `claude/project_CLAUDE.md` 변경 → 프로젝트 CLAUDE.md에 반영
   - `.claude/rules/project-*.md` 변경 → 프로젝트 `.claude/rules/`에 반영
   - `blueprints/` 변경 → 프로젝트에 해당 blueprint 참조가 있으면 안내
3. 변경 요약을 사용자에게 제시

### 3.5 위생 검사

버전 diff와 별개로, 배포 프로젝트에 누적된 부채를 함께 점검한다.

```bash
# (a) 플러그인 로컬 복제본 — v0.4.0 플러그인 전환 이전 배포분에 남아 있다
ls -d <target>/.claude/{agents,commands,hooks,skills,templates} 2>/dev/null

# (b) 미커스터마이즈 마커 / 템플릿 헤더 잔존
grep -rn 'MUST-CUSTOMIZE\|{{.*}}\|프로젝트 rules 템플릿' <target>/.claude/rules/ <target>/CLAUDE.md

# (c) 이전 업데이트가 남긴 백업 파일
find <target> -name '*.bak' -not -path '*/.git/*'

# (d) v0.7.0에서 제거된 파이프라인 참조 — 단계 프리셋, 산출물 디렉토리, 삭제된 에이전트·스킬·템플릿
grep -rnE 'docs/artifacts|프리셋|\b(Small|Medium|Large)\b|adt:review|ideation|product-manager|designer|design-validator|implementer|cto-lead|code-analyzer|verifier|report-generator|(plan|design|report)\.template' <target>/CLAUDE.md <target>/.claude/rules/
```

| 발견 | 조치 |
|------|------|
| (a) 로컬 복제본 | 플러그인이 동일 내용을 제공하므로 **제거를 제안**한다. 제거 전 라이브러리 최신본과 diff하여 흡수할 프로젝트 커스터마이징이 없는지 확인 — 있으면 `/adt:project-absorb` 안내 |
| (b) 마커 잔존 | 미커스터마이즈 상태 — 사용자와 함께 실제 값으로 채운다 |
| (c) `.bak` | 커밋 이력이 있으면 불필요 — 제거를 제안한다 |
| (d) 옛 파이프라인 참조 | 존재하지 않는 프리셋·에이전트·디렉토리를 가리킨다 — 매치된 줄뿐 아니라 그 규칙이 속한 절 전체를 사용자와 함께 현재 구조(`blueprints/design-principles.md` 1절)에 맞게 고친다. 보고용 검사라 오탐이 있을 수 있다 |

**`CLAUDE.md`와 `.claude/rules/*.md`의 내용 충돌도 확인한다.** 둘 다 항상 로드되므로
같은 주제(브랜치 전략 등)를 다르게 적어두면 AI가 상충 지침을 받는다. 충돌 시 CLAUDE.md 기준.

### 4. 적용 방식 선택

프로젝트 CLAUDE.md에 대해:
- **자동 병합** — 템플릿 골격만 갱신, 커스텀 섹션 보존 (추천)
- **수동 검토** — 변경 항목을 하나씩 보여주고 적용 여부를 1문 1답으로 결정
- **스킵** — 이번 업데이트에서 제외

프로젝트 `.claude/rules/*.md`에 대해:
- 프로젝트에 해당 rules 파일이 존재하는 경우만 갱신 대상
- 프로젝트가 커스터마이즈한 부분 보존 (CLAUDE.md와 동일한 병합 로직)
- rules 파일이 없는 경우 → 사용자에게 rules 추가 여부 안내

### 5. 적용 및 버전 갱신

1. 선택한 방식으로 파일 갱신
2. 프로젝트 `CLAUDE.md` 헤더의 기반 버전을 새 버전으로 갱신, Local을 0으로 리셋
   - 예: `v0.1.0.3` → `v0.2.0.0`
3. `local.json`의 `deployed_projects`에서 `base_version`, `last_synced` 갱신
4. `registry.md` 갱신

### 6. 커밋 (필수 단계)

**변경을 미커밋 상태로 남긴 채 종료하지 않는다.** 배포 기록과 실제 저장소 상태가 어긋나는
주된 원인이다 — v0.4.1 배포분이 3개 프로젝트 모두 미커밋으로 3개월간 방치된 사례가 있다.

1. `git status`로 변경 파일을 보여주고 **커밋을 제안**한다
   - 타겟이 git 저장소가 아니면 이 단계를 건너뛰고 그 사실을 명시한다
   - 커밋 이력이 없는 저장소면 초기 커밋임을 알린다
2. 이번 업데이트와 무관한 기존 변경은 **스테이징하지 않는다** (예: `settings.local.json`)
3. 사용자가 거절하면 "미커밋 상태로 남김"을 결과 안내와 registry 비고에 명시한다
4. push는 별도로 확인받는다 — 대상 저장소의 브랜치 규칙(`CLAUDE.md`, `rules/git-workflow.md`)을
   먼저 읽고, 규칙과 실제 이력이 어긋나면 그 사실을 알린 뒤 판단을 넘긴다

### 7. 결과 안내

- 갱신된 파일 목록 + 위생 검사에서 정리한 항목
- 버전 변경 내역 (`v0.1.0.3 → v0.2.0.0`)
- **커밋 해시** (또는 미커밋 사유)

## 주의사항

- 프로젝트의 커스텀 내용(사용자가 추가한 섹션, 수정한 값)을 **절대 유실하지 않는다**
- 백업은 **git이 담당**한다 — git 저장소에서는 `.bak` 파일을 만들지 않는다.
  git 저장소가 아닌 경우에만 `.bak` 백업 후, 커밋 대신 백업 위치를 안내한다
- 충돌이 발생하면 사용자에게 수동 해결을 안내
- 커밋은 **제안**한다 — 승인 없이 자동 커밋하지 않되, 제안 없이 끝내지도 않는다
