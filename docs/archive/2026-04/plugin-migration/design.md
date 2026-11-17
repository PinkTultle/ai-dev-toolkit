# 001. plugin-migration — Design

- **날짜**: 2026-04-12
- **Plan 참조**: `docs/01-plan/features/plugin-migration.plan.md`
- **작성자**: Claude (PDCA Design)

---

## Executive Summary

| 항목 | 내용 |
|------|------|
| **접근 방식** | 기존 `.claude/` 구조를 최상위 플러그인 디렉토리로 이전 + 커맨드→스킬 변환 |
| **핵심 변경** | `.claude-plugin/`, `skills/`, `agents/`, `hooks/` 신규 + `.claude/` 삭제 |
| **리스크** | `${CLAUDE_PLUGIN_ROOT}` 경로 참조 일관성, defconfig 스킬의 하위 호환 |

---

## 1. 설계 결정

### 선택한 접근 방식

**In-place 전환**: 현재 저장소를 그대로 플러그인 저장소로 변환한다.
별도 저장소를 만들지 않고, 기존 구조 위에 플러그인 매니페스트를 추가하고
`.claude/` 내용을 최상위로 이동한다.

### 검토한 대안

| 대안 | 장점 | 단점 | 탈락 사유 |
|------|------|------|----------|
| A. 별도 플러그인 저장소 생성 | 깔끔한 분리 | 두 저장소 관리, blueprints 중복 | 유지보수 부담 2배 |
| B. 모노레포 (plugin/ 하위디렉토리) | 기존 구조 유지 | 플러그인 루트가 서브디렉토리 — 마켓플레이스 비호환 | plugin.json이 저장소 루트에 있어야 함 |
| **C. In-place 전환 (채택)** | 단일 저장소, 기존 히스토리 유지 | 전환 과정에서 경로 변경 많음 | — |

## 2. 아키텍처

### 2.1 전환 전후 구조도

```
전환 전 (v0.3.0)                    전환 후 (v0.4.0)
─────────────────                   ─────────────────
.claude/                            .claude-plugin/
  skills/ (6)          ──→            skills/ (최상위, 11개)
  agents/ (12)         ──→            agents/ (최상위, 12개)
  commands/ (5)        ──→            skills/ (스킬로 변환)
  templates/ (4)       ──→            templates/ (최상위)
  hooks/               ──→            hooks/ (최상위, hooks.json)
  settings.json        ──→            (deny만 문서로 안내)
  rules/ (7)           ──→            blueprints/ (기존 유지)
```

### 2.2 플러그인 디렉토리 최종 구조

```
ai-dev-toolkit/
├── .claude-plugin/
│   ├── plugin.json                 ← 매니페스트 (신규)
│   └── marketplace.json            ← 마켓플레이스 (신규)
├── package.json                    ← NPM 메타 (신규)
│
├── skills/                         ← 스킬 (신규 위치)
│   ├── ai-platform-defconfig/SKILL.md
│   ├── project-init/SKILL.md
│   ├── project-configure/SKILL.md
│   ├── project-update/SKILL.md
│   ├── project-absorb/SKILL.md
│   ├── optimize-docs/SKILL.md
│   ├── handoff/SKILL.md            ← command 변환
│   ├── sync-check/SKILL.md         ← command 변환
│   ├── doc-gen/SKILL.md            ← command 변환
│   ├── review/SKILL.md             ← command 변환
│   └── decision/SKILL.md           ← command 변환
│
├── agents/                         ← 에이전트 (신규 위치)
│   ├── ideation.md
│   ├── product-manager.md
│   ├── designer.md
│   ├── design-validator.md
│   ├── reviewer.md
│   ├── implementer.md
│   ├── verifier.md
│   ├── gap-detector.md
│   ├── code-analyzer.md
│   ├── tester.md
│   ├── report-generator.md
│   └── cto-lead.md
│
├── templates/                      ← 템플릿 (신규 위치)
│   ├── plan.template.md
│   ├── design.template.md
│   ├── report.template.md
│   └── decision.template.md
│
├── hooks/                          ← 훅 (신규)
│   ├── hooks.json
│   └── post-edit-check.sh
│
├── blueprints/                     ← 유지 (변경 없음)
├── claude/                         ← 유지 (하위 호환 배포 파일)
│   ├── global_CLAUDE.md
│   ├── project_CLAUDE.md
│   └── README.md
├── .claude/
│   └── rules/                      ← 유지 (이 프로젝트 자체의 rules)
│       ├── global-*.md
│       └── project-*.md
├── docs/                           ← 유지
├── workstations/                   ← 유지
├── CLAUDE.md                       ← 유지 (이 프로젝트 자체 규칙)
├── HANDOFF.md
├── VERSION
└── CHANGELOG.md
```

**핵심 결정: `.claude/` 완전 삭제가 아닌 부분 유지**

플러그인의 `skills/`, `agents/`는 최상위로 이동하지만,
`.claude/rules/`는 **이 저장소 자체의 프로젝트 규칙**이므로 그대로 유지한다.
삭제 대상은 `.claude/skills/`, `.claude/agents/`, `.claude/commands/`, `.claude/templates/`, `.claude/hooks/`, `.claude/settings.json`이다.

### 2.3 변경 파일 목록

| 파일 | 변경 유형 | 설명 |
|------|----------|------|
| `.claude-plugin/plugin.json` | 신규 | 플러그인 매니페스트 |
| `.claude-plugin/marketplace.json` | 신규 | 마켓플레이스 메타데이터 |
| `package.json` | 신규 | NPM 메타데이터 |
| `hooks/hooks.json` | 신규 | 훅 정의 (기존 settings.json 훅 이전) |
| `hooks/post-edit-check.sh` | 이동 | `.claude/hooks/` → `hooks/` |
| `skills/*/SKILL.md` (6개) | 이동 | `.claude/skills/` → `skills/` |
| `skills/*/SKILL.md` (5개) | 신규 | commands → skills 변환 |
| `agents/*.md` (12개) | 이동 | `.claude/agents/` → `agents/` |
| `templates/*.md` (4개) | 이동 | `.claude/templates/` → `templates/` |
| `.claude/skills/` | 삭제 | 플러그인 skills/로 이전 완료 |
| `.claude/agents/` | 삭제 | 플러그인 agents/로 이전 완료 |
| `.claude/commands/` | 삭제 | skills/로 변환 완료 |
| `.claude/templates/` | 삭제 | 플러그인 templates/로 이전 완료 |
| `.claude/hooks/` | 삭제 | 플러그인 hooks/로 이전 완료 |
| `.claude/settings.json` | 삭제 | 훅은 hooks.json으로, deny는 문서 안내로 |
| `CLAUDE.md` | 수정 | 프로젝트 구조 섹션 갱신 |
| `docs/project-structure.md` | 수정 | 구조도 갱신 |
| `VERSION` | 수정 | 0.3.0 → 0.4.0 |

## 3. 상세 설계

### 3.1 plugin.json

```json
{
  "name": "adt",
  "version": "0.4.0",
  "displayName": "adt — AI Development Toolkit",
  "description": "AI 개발 파이프라인 — 12 에이전트, 11 스킬, 문서 템플릿, blueprints 지식 체계",
  "engines": {
    "claude-code": ">=2.1.78"
  }
}
```

- `userConfig` 없음 — 외부 서비스 연동 없음
- `outputStyles` 없음 — 커스텀 출력 스타일 없음 (향후 추가 가능)

### 3.2 marketplace.json

```json
{
  "name": "PinkTultle-adt",
  "owner": {
    "name": "PinkTultle"
  },
  "metadata": {
    "description": "AI Development Toolkit — development pipeline agents and project scaffolding",
    "version": "0.4.0"
  },
  "plugins": [
    {
      "name": "adt",
      "source": "./",
      "description": "12 pipeline agents, 11 skills, document templates, blueprints knowledge system",
      "version": "0.4.0",
      "author": { "name": "PinkTultle" },
      "repository": "https://github.com/PinkTultle/My_AI_manual",
      "license": "MIT",
      "keywords": [
        "development-pipeline",
        "project-scaffolding",
        "code-review",
        "blueprints",
        "agents",
        "claude-code-plugin"
      ],
      "category": "development-tools"
    }
  ]
}
```

### 3.3 package.json

```json
{
  "name": "adt",
  "version": "0.4.0",
  "displayName": "adt — AI Development Toolkit",
  "description": "AI 개발 파이프라인 — 12 에이전트, 11 스킬, 문서 템플릿, blueprints 지식 체계",
  "author": { "name": "PinkTultle" },
  "repository": "https://github.com/PinkTultle/My_AI_manual",
  "license": "MIT",
  "keywords": [
    "development-pipeline",
    "project-scaffolding",
    "code-review",
    "blueprints",
    "claude-code-plugin"
  ],
  "engines": {
    "claude-code": ">=2.1.78"
  }
}
```

### 3.4 hooks.json

```json
{
  "$schema": "https://json.schemastore.org/claude-code-hooks.json",
  "description": "adt — AI Development Toolkit v0.4.0",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/post-edit-check.sh $CLAUDE_FILE_PATH",
            "timeout": 5000
          }
        ]
      }
    ]
  }
}
```

**기존 settings.json의 deny 규칙 처리**:
플러그인은 프로젝트의 `settings.json` deny 규칙을 설정할 수 없다.
`/adt:ai-platform-defconfig` 스킬 실행 시 사용자의 `~/.claude/settings.json`에 deny 규칙 추가를 안내하는 방식으로 유지한다 (현재와 동일).

### 3.5 커맨드 → 스킬 변환 상세

5개 커맨드를 스킬 YAML frontmatter 형식으로 변환한다.
본문(프롬프트)은 그대로 유지하고, frontmatter만 추가한다.

| 커맨드 | 스킬 name | description | argument-hint | allowed-tools |
|--------|-----------|-------------|---------------|---------------|
| `handoff.md` | `handoff` | 세션 종료 시 HANDOFF.md 갱신 + 커밋 + 푸시 | `""` | Read, Write, Edit, Bash, Glob, Grep |
| `sync-check.md` | `sync-check` | blueprints ↔ rules 동기화 상태 점검 | `""` | Read, Bash, Glob, Grep |
| `doc-gen.md` | `doc-gen` | 소스 파일의 코드 설명 문서 자동 생성/갱신 | `"[file-path]"` | Read, Write, Edit, Bash, Glob, Grep |
| `review.md` | `review` | 변경사항 코드 리뷰 (보안/성능/가독성) | `"[file-path]"` | Read, Bash, Glob, Grep |
| `decision.md` | `decision` | ADR 생성/조회 (아키텍처 결정 기록) | `"[title]"` | Read, Write, Edit, Bash, Glob, Grep |

**변환 예시 — handoff**:

```yaml
---
name: handoff
description: 세션 종료 시 HANDOFF.md 갱신 + 커밋 + 푸시
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

이번 세션의 작업 내용을 정리하여 HANDOFF.md를 갱신하고, 커밋 후 푸시한다.

## 수행 절차
... (기존 본문 그대로)
```

### 3.6 스킬 경로 참조 갱신

기존 스킬에서 `REPO_DIR`이나 `CLAUDE_SKILL_DIR` 기반 상대 경로를 사용하는 부분을 `${CLAUDE_PLUGIN_ROOT}`로 치환한다.

**영향 받는 스킬**: `project-init`, `project-configure`

```bash
# 변환 전 (project-init/SKILL.md)
REPO_DIR=${CLAUDE_SKILL_DIR}/../../..

# 변환 후
REPO_DIR=${CLAUDE_PLUGIN_ROOT}
```

| 기존 경로 표현 | 변환 후 |
|-------------|--------|
| `${CLAUDE_SKILL_DIR}/../../..` | `${CLAUDE_PLUGIN_ROOT}` |
| `${CLAUDE_SKILL_DIR}/../../templates/` | `${CLAUDE_PLUGIN_ROOT}/templates/` |

### 3.7 에이전트 이전

에이전트 파일은 **내용 변경 없이** `.claude/agents/` → `agents/`로 이동만 한다.

에이전트 내부에서 템플릿을 참조하는 경로가 있다면 갱신이 필요하다:

```markdown
# 변환 전 (ideation.md)
**반드시 `.claude/templates/plan.template.md`를 읽고 그 구조를 따른다.**

# 변환 후
**반드시 `templates/plan.template.md`를 읽고 그 구조를 따른다.**
```

**전체 에이전트 경로 참조 점검 목록**:

| 에이전트 | `.claude/templates/` 참조 여부 | 수정 필요 |
|---------|-------------------------------|----------|
| ideation.md | plan.template.md | O |
| designer.md | design.template.md | 확인 필요 |
| reviewer.md | — | X |
| implementer.md | — | 확인 필요 |
| report-generator.md | report.template.md | 확인 필요 |
| 나머지 7개 | — | 확인 필요 |

구현 시 전체 에이전트를 grep하여 `.claude/` 참조를 찾고 일괄 치환한다.

### 3.8 rkit 독립성 보장 설계

rkit과의 충돌을 방지하는 설계 원칙:

1. **네임스페이스 격리**: 모든 스킬은 `adt:` 접두사, 에이전트도 `adt:` 접두사로 노출
2. **훅 비간섭**: adt 훅은 자체 스크립트만 실행 — rkit 훅과 독립 체인
3. **상태 비공유**: adt는 `.rkit-memory.json` 등 rkit 상태 파일에 접근하지 않음
4. **에이전트 이름 비충돌**: adt 에이전트 이름 12개가 rkit 41개와 겹치는지 확인 필요

**이름 충돌 확인**:

| adt 에이전트 | rkit에도 존재? | 처리 |
|-------------|--------------|------|
| ideation | X | 충돌 없음 |
| product-manager | X | 충돌 없음 |
| designer | X | 충돌 없음 |
| design-validator | O (`rkit:design-validator`) | 네임스페이스로 구분 (`adt:design-validator`) |
| reviewer | X | 충돌 없음 |
| implementer | X | 충돌 없음 |
| verifier | X | 충돌 없음 |
| gap-detector | O (`rkit:gap-detector`) | 네임스페이스로 구분 |
| code-analyzer | O (`rkit:code-analyzer`) | 네임스페이스로 구분 |
| tester | X | 충돌 없음 |
| report-generator | O (`rkit:report-generator`) | 네임스페이스로 구분 |
| cto-lead | O (`rkit:cto-lead`) | 네임스페이스로 구분 |

5개 에이전트가 이름이 겹치나, 플러그인 네임스페이스(`adt:` vs `rkit:`)로 자동 구분된다.
동일 이름이라도 **내용이 다른 별개 에이전트**이므로 문제 없다.

## 4. 품질 기준

| 기준 | 목표값 |
|------|--------|
| 플러그인 설치 | `claude plugin install` 성공 |
| 스킬 호출 | 11개 모두 `adt:` 접두사로 호출 가능 |
| 에이전트 호출 | 12개 모두 `adt:` 접두사로 Agent tool에 노출 |
| 훅 동작 | PostToolUse 줄 수 검사 정상 실행 |
| rkit 독립성 | rkit 미설치 시 단독 동작, rkit과 동시 사용 시 충돌 없음 |
| 하위 호환 | 기존 git clone + defconfig 방식 동작 |

## 5. 구현 순서

### Step 1: 플러그인 매니페스트 생성
1. `.claude-plugin/plugin.json` 생성
2. `.claude-plugin/marketplace.json` 생성
3. `package.json` 생성

### Step 2: 최상위 디렉토리 구성 + 이동
4. `skills/` 디렉토리 생성, 기존 6개 스킬 이동
5. `agents/` 디렉토리 생성, 12개 에이전트 이동
6. `templates/` 디렉토리 생성, 4개 템플릿 이동
7. `hooks/` 디렉토리 생성, `hooks.json` + `post-edit-check.sh` 배치

### Step 3: 커맨드 → 스킬 변환
8. 5개 커맨드 파일을 SKILL.md 형식으로 변환하여 `skills/`에 생성

### Step 4: 경로 참조 갱신
9. 스킬 내 `REPO_DIR` / `CLAUDE_SKILL_DIR` → `${CLAUDE_PLUGIN_ROOT}` 치환
10. 에이전트 내 `.claude/templates/` → `templates/` 경로 갱신
11. 에이전트 내 기타 `.claude/` 참조 일괄 점검 + 갱신

### Step 5: 기존 구조 정리
12. `.claude/skills/`, `.claude/agents/`, `.claude/commands/`, `.claude/templates/`, `.claude/hooks/` 삭제
13. `.claude/settings.json` 삭제
14. `.claude/rules/`는 유지 (이 프로젝트 자체의 규칙)

### Step 6: 문서 갱신
15. `CLAUDE.md` 프로젝트 구조 섹션 갱신
16. `docs/project-structure.md` 갱신
17. `VERSION` → `0.4.0`
18. `CHANGELOG.md` 갱신

### Step 7: 검증
19. 로컬 설치 테스트
20. 스킬/에이전트 호출 테스트
21. rkit 동시 사용 테스트

## 6. 리스크 및 완화

| 리스크 | 영향 | 완화 방안 |
|--------|------|----------|
| `${CLAUDE_PLUGIN_ROOT}` 미지원 환경 | High | engines 제약으로 CC >= 2.1.78 보장, 미지원 시 설치 자체 불가 |
| 에이전트 내 `.claude/` 하드코딩 경로 누락 | Medium | grep으로 전체 검색 후 일괄 치환, 검증 단계에서 재확인 |
| 기존 배포 프로젝트에 영향 | Medium | 배포된 프로젝트의 CLAUDE.md, rules/는 복사본이므로 영향 없음 |
| defconfig 스킬의 심볼릭 링크 경로 변경 | High | `${CLAUDE_PLUGIN_ROOT}` 기반으로 링크 타겟 갱신, 기존 링크는 재실행으로 수정 |
| 플러그인 + 프로젝트 `.claude/rules/` 충돌 | Low | 플러그인은 rules/ 미사용, 프로젝트 자체 rules는 `.claude/rules/`에 잔류하여 분리 |

---

> 이 문서는 `.claude/templates/design.template.md` 기반으로 생성됨
