# 001. plugin-migration — Plan

- **날짜**: 2026-04-12
- **작업 유형**: Large
- **작성자**: Claude (PDCA Plan)

---

## Executive Summary

| 항목 | 내용 |
|------|------|
| **Feature** | ai-dev-toolkit을 Claude Code 플러그인으로 전환 |
| **시작일** | 2026-04-12 |
| **현재 버전** | v0.3.0 (git clone + symlink 배포) |
| **목표 버전** | v0.4.0 (Claude Code Plugin 전환) |

### Value Delivered

| 관점 | 내용 |
|------|------|
| **Problem** | 현재 git clone → defconfig → project-init 3단계 수동 배포가 번거롭고, 에이전트/스킬 업데이트 시 모든 워크스테이션에서 git pull 필요 |
| **Solution** | Claude Code 플러그인 시스템으로 패키징하여 설치/업데이트를 단일 명령으로 자동화 |
| **Function UX Effect** | `claude plugin install` 한 줄로 12 에이전트 + 6 스킬 + 5 커맨드 + 훅 즉시 사용 가능, 업데이트도 자동 |
| **Core Value** | AI 개발 파이프라인의 재사용성과 이식성 극대화 — 워크스테이션/프로젝트 간 일관된 개발 경험 |

---

## 1. 배경 및 동기

### 현재 방식의 한계

1. **배포 복잡성** — git clone → `/ai-platform-defconfig` → 프로젝트마다 `/project-init` + `/project-configure`. 워크스테이션 3대 × 프로젝트 4개 = 12회 수동 작업
2. **업데이트 동기화** — 에이전트/스킬 로직 수정 시 라이브러리를 git pull한 뒤 각 프로젝트에 `/project-update` 재실행 필요
3. **공유 불가** — 현재 구조는 개인 워크스테이션에 맞춰진 심볼릭 링크 기반이라 다른 사용자와 공유가 어려움
4. **버전 추적 수동** — `workstations/registry.md`와 `<alias>.local.json`을 수동 관리

### 플러그인화의 이점

1. **설치 단순화** — GitHub 저장소 등록 후 `claude plugin install`로 즉시 사용
2. **자동 업데이트** — git push만 하면 모든 머신에서 플러그인 업데이트로 반영
3. **네임스페이스 격리** — `adt:` 접두사로 rkit 등 다른 플러그인과 충돌 없이 독립 공존
4. **라이프사이클 훅** — SessionStart, PreToolUse 등 플러그인 전용 훅 활용 가능

## 2. 목표

- [ ] Claude Code 플러그인 매니페스트(`.claude-plugin/plugin.json`) 생성
- [ ] 기존 스킬 6개를 플러그인 `skills/` 구조로 이전
- [ ] 기존 커맨드 5개를 스킬로 변환하여 `skills/`에 통합
- [ ] 기존 에이전트 12개를 플러그인 `agents/` 구조로 이전
- [ ] 훅을 플러그인 `hooks/hooks.json` 형식으로 변환
- [ ] blueprints를 스킬 imports 또는 컨텍스트로 참조 가능하게 재구성
- [ ] 글로벌 규칙(rules) 배포 메커니즘을 플러그인 방식으로 전환
- [ ] GitHub 저장소에서 플러그인으로 설치 가능한 상태 달성

## 3. 범위

### 포함

#### Phase 1: 플러그인 골격 구성
- `.claude-plugin/plugin.json` 매니페스트
- `.claude-plugin/marketplace.json` 메타데이터
- `package.json` NPM 메타데이터
- `hooks/hooks.json` 라이프사이클 훅

#### Phase 2: 스킬/에이전트 이전
- `skills/` 디렉토리에 11개 스킬 (기존 6 + 커맨드 변환 5)
- `agents/` 디렉토리에 12개 에이전트
- 템플릿 파일 참조 경로 갱신 (`${CLAUDE_PLUGIN_ROOT}` 활용)

#### Phase 3: 컨텍스트 시스템
- blueprints를 스킬의 `imports`로 참조하는 구조 설계
- 글로벌 규칙을 SessionStart 훅에서 주입하는 방식 검토

#### Phase 4: 배포 스킬 갱신
- `project-init`, `project-configure` 등이 플러그인 컨텍스트에서 동작하도록 수정
- `REPO_DIR` → `${CLAUDE_PLUGIN_ROOT}` 치환

### 제외

- **rkit 기능 이식** — rkit의 PDCA, 도메인 감지 등은 별개 플러그인. 이 프로젝트는 자체 기능만 플러그인화
- **다른 AI 도구 지원** — cursor/, copilot/, windsurf/ 디렉토리는 이번 범위에서 제외
- **워크스테이션 관리 자동화** — `workstations/` 추적은 플러그인 데이터로 이전하지 않음 (향후 과제)
- **MCP 서버** — 현재 MCP 서버가 없으므로 미포함

## 4. 제약조건

| 제약 | 설명 |
|------|------|
| **Claude Code 버전** | `>= 2.1.78` 필요 (현재 2.1.104 — 충족) |
| **하위 호환성** | 기존 git clone + symlink 방식도 병행 가능해야 함 (전환 기간) |
| **글로벌 rules** | 플러그인이 `~/.claude/rules/`에 직접 파일을 넣을 수 없음 — 대안 필요 |
| **프로젝트 파일 쓰기** | 플러그인 스킬이 외부 디렉토리에 파일을 쓸 때 권한 설정 필요 |
| **네이밍** | `adt` 확정 — rkit 독립 실행 보장, 동시 사용 시 네임스페이스 격리 |

## 5. 전환 전략: 하이브리드 접근

### 5.1 디렉토리 구조 (목표)

```
ai-dev-toolkit/                    ← GitHub 저장소 (플러그인 소스)
├── .claude-plugin/
│   ├── plugin.json                ← 플러그인 매니페스트
│   └── marketplace.json           ← 마켓플레이스 메타데이터
├── package.json                   ← NPM 메타데이터
├── hooks/
│   └── hooks.json                 ← 라이프사이클 훅 정의
├── skills/                        ← 플러그인 스킬 (11개)
│   ├── ai-platform-defconfig/SKILL.md
│   ├── project-init/SKILL.md
│   ├── project-configure/SKILL.md
│   ├── project-update/SKILL.md
│   ├── project-absorb/SKILL.md
│   ├── optimize-docs/SKILL.md
│   ├── handoff/SKILL.md           ← 커맨드→스킬 변환
│   ├── sync-check/SKILL.md        ← 커맨드→스킬 변환
│   ├── doc-gen/SKILL.md           ← 커맨드→스킬 변환
│   ├── review/SKILL.md            ← 커맨드→스킬 변환
│   └── decision/SKILL.md          ← 커맨드→스킬 변환
├── agents/                        ← 플러그인 에이전트 (12개)
│   ├── ideation.md
│   ├── product-manager.md
│   ├── designer.md
│   ├── ... (12개 그대로)
│   └── cto-lead.md
├── templates/                     ← 문서 템플릿 (스킬에서 import)
│   ├── plan.template.md
│   ├── design.template.md
│   ├── report.template.md
│   └── decision.template.md
├── blueprints/                    ← 공유 지식 (유지)
│   ├── base-directives.md
│   ├── design-principles.md
│   └── ...
├── claude/                        ← 기존 배포 파일 (하위 호환)
│   ├── global_CLAUDE.md
│   └── project_CLAUDE.md
├── workstations/                  ← 워크스테이션 추적 (유지)
└── docs/                          ← 문서 (유지)
```

### 5.2 기존 `.claude/` → 플러그인 이전 매핑

| 기존 경로 | 플러그인 경로 | 변환 |
|-----------|-------------|------|
| `.claude/skills/*/SKILL.md` | `skills/*/SKILL.md` | 최상위 이동 |
| `.claude/agents/*.md` | `agents/*.md` | 최상위 이동 |
| `.claude/commands/*.md` | `skills/*/SKILL.md` | 커맨드→스킬 변환 |
| `.claude/templates/*.md` | `templates/*.md` | 최상위 이동, imports로 참조 |
| `.claude/hooks/` | `hooks/hooks.json` + 스크립트 | 형식 변환 |
| `.claude/settings.json` | `hooks/hooks.json` (훅 부분) | deny는 플러그인 범위 밖 |
| `.claude/rules/` | `blueprints/` (참조용 유지) | 글로벌 배포는 defconfig 유지 |

### 5.3 글로벌 Rules 전략

플러그인 시스템은 `~/.claude/rules/`에 직접 파일을 배치할 수 없다.
**하이브리드 전략**으로 해결:

1. **`/ai-platform-defconfig` 스킬 유지** — 글로벌 rules 심볼릭 링크 생성은 이 스킬이 담당 (1회 실행)
2. **SessionStart 훅 추가** — 플러그인 활성화 시 blueprints의 핵심 규칙을 컨텍스트에 주입
3. **장기적으로** — Claude Code가 플러그인 레벨의 rules 지원을 추가하면 전환

### 5.4 커맨드 → 스킬 변환 규칙

기존 커맨드(`.claude/commands/*.md`)는 단순 프롬프트 파일이다.
스킬은 YAML frontmatter가 필요하므로 다음과 같이 변환:

```yaml
# 변환 전 (command)
# .claude/commands/handoff.md
세션 종료 시 HANDOFF.md를 갱신하고 커밋...

# 변환 후 (skill)
# skills/handoff/SKILL.md
---
name: handoff
description: 세션 종료 시 HANDOFF.md 갱신 + 커밋 + 푸시
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---
세션 종료 시 HANDOFF.md를 갱신하고 커밋...
```

## 6. 성공 기준

- [ ] `claude plugin install <github-url>` 명령으로 플러그인 설치 가능
- [ ] 설치 후 `adt:project-init`, `adt:review` 등 `adt:` 접두사로 스킬 호출 가능
- [ ] rkit 미설치 환경에서 단독 동작 확인
- [ ] rkit과 동시 활성화 시 충돌 없이 양쪽 모두 정상 동작 확인
- [ ] 12개 에이전트가 플러그인 컨텍스트에서 정상 동작
- [ ] 기존 git clone + defconfig 방식도 여전히 동작 (하위 호환)
- [ ] 플러그인 업데이트 시 스킬/에이전트 변경이 즉시 반영
- [ ] 기존 배포된 프로젝트 4개의 CLAUDE.md와 rules가 영향받지 않음

## 7. 구현 순서 (Phase)

```
Phase 1: 플러그인 골격          Phase 2: 컨텐츠 이전
┌─────────────────────┐       ┌─────────────────────┐
│ plugin.json 생성     │       │ skills/ 이전 (6개)   │
│ marketplace.json     │  ──→  │ commands→skills (5개)│
│ package.json         │       │ agents/ 이전 (12개)  │
│ hooks.json 변환      │       │ templates/ 이전      │
└─────────────────────┘       └─────────────────────┘
                                        │
Phase 4: 검증 + 배포            Phase 3: 경로/참조 갱신
┌─────────────────────┐       ┌─────────────────────┐
│ 로컬 설치 테스트      │       │ REPO_DIR→PLUGIN_ROOT│
│ 기존 방식 호환 확인   │  ←──  │ 템플릿 import 경로   │
│ GitHub 등록          │       │ defconfig 병행 설계  │
│ 워크스테이션 전환 검증 │       │ SessionStart 훅     │
└─────────────────────┘       └─────────────────────┘
```

## 8. 미결 질문

### 해소됨

- [x] **플러그인 이름**: `adt` (ai-dev-toolkit) — 3글자, 저장소명 직관적 약어. Display: `adt — AI Development Toolkit`
- [x] **GitHub 공개 여부**: 이미 public 저장소 — 마켓플레이스 등록 가능
- [x] **기존 `.claude/` 유지**: 플러그인 전환 후 완전 호환이 확인되면 **삭제** (이중 관리 방지)
- [x] **rkit과의 관계**: **독립 실행 보장** 필수. rkit 유무와 관계없이 단독 동작해야 함. 동시 사용 시에도 네임스페이스(`adt:` vs `rkit:`)로 충돌 없음
- [x] **목표 버전**: v0.4.0 — 마켓플레이스 등록이 1.0을 의미하지 않음

### 미해소

(없음 — 모두 해소됨)

- [x] **CC 최소 버전**: `>= 2.1.78` (rkit과 동일). 현재 워크스테이션 CC 2.1.104로 업그레이드 불필요

---

> 이 문서는 `.claude/templates/plan.template.md` 기반으로 생성됨
