# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-03-13
**작업 내용**: 저장소 방향 전환 — "AI 플랫폼 도구"로 리팩토링 착수

### 방향 전환 결정 사항

저장소를 **수동 문서 모음**에서 **3개 스킬을 갖춘 AI 플랫폼 도구**로 전환한다.

**스킬 3개 구조:**
| 스킬 | 실행 시점 | 역할 |
|------|----------|------|
| `ai-platform-defconfig` | 워크스테이션 최초 세팅 | 사용자명, 경로, 패키지, 스킬, MCP, 심볼릭 링크 등 플랫폼 기반 구성 |
| `project-init` | 새 프로젝트 생성 시 | 타겟 디렉토리에 템플릿/룰 복제 |
| `project-configure` | init 이후 | 대화형으로 프로젝트 설정 구체화 |

**전체 흐름:**
```
워크스테이션 클론 → ai-platform-defconfig (1회)
                        ↓
              새 프로젝트마다 → project-init → project-configure
```

**핵심 설계 결정:**
- 스킬은 `.claude/skills/<name>/SKILL.md` 구조 (commands/ 아닌 skills/)
- `_shared/` → `blueprints/`로 리네이밍 (완료)
- 심볼릭 링크는 유지하되, `defconfig`가 관리 (저장소 경로 이동 시 재실행으로 해결)
- `global_CLAUDE.md`는 심볼릭 링크 대상으로 유지, 템플릿 변수가 필요한 파일만 생성 방식

### 이번 세션에서 완료된 작업

1. **`_shared/` → `blueprints/` 리네이밍** — git mv + 모든 참조 일괄 변경 완료
   - CLAUDE.md, README.md, claude/global_CLAUDE.md, HANDOFF.md 내 참조 갱신

### 진행 중 — 중단된 지점

**Phase 1: 스킬 디렉토리 생성 직전에 중단**
- `.claude/skills/` 디렉토리 및 3개 스킬 `SKILL.md` 파일 **아직 미생성**
- 다음 세션에서 아래 디렉토리/파일 생성부터 시작:
  ```
  .claude/skills/
  ├── ai-platform-defconfig/SKILL.md
  ├── project-init/SKILL.md
  └── project-configure/SKILL.md
  ```

### 남은 작업 (우선순위순)

#### Phase 1: 스킬 구현
- [ ] `.claude/skills/` 디렉토리 및 3개 스킬 SKILL.md 골격 생성
- [ ] `ai-platform-defconfig` 스킬 내용 작성 (심볼릭 링크 관리, 패키지 확인, MCP 설정 등)
- [ ] `project-init` 스킬 내용 작성 (타겟 경로 지정 → blueprints 복제)
- [ ] `project-configure` 스킬 내용 작성 (대화형 프로젝트 구체화)
- [ ] defconfig용 설정 템플릿 생성 (`platform/` 디렉토리)

#### Phase 2: 내부 지침 수정 (수정할 것 많음)
| 파일 | 수정 사항 | 우선순위 |
|------|----------|---------|
| `CLAUDE.md` (루트) | 스킬 3개 구조 반영, 디렉토리 구조 갱신, 배포 섹션을 defconfig 기반으로 재작성 | 높음 |
| `README.md` (루트) | "AI 플랫폼 도구" 관점으로 재작성 — 스킬 사용법 중심 | 높음 |
| `claude/global_CLAUDE.md` | 수동 배포 안내 제거, 실사용 피드백 반영 보강 | 높음 |
| `claude/project_CLAUDE.md` | project-init이 복제하는 템플릿으로 재설계 | 높음 |
| `claude/README.md` | defconfig/스킬 기반 배포로 재작성 | 중간 |
| `TOOL_REFERENCE.md` | Claude 섹션을 defconfig 관리 방식으로 재작성 | 중간 |
| `blueprints/README.md` | 리네이밍 반영, 스킬 참조 방식 설명 | 낮음 |
| `blueprints/base-directives.md` | 인수인계 규칙 중복 재검토 | 낮음 |
| `blueprints/environment.md` | defconfig와의 관계 정리 | 낮음 |

#### Phase 3: 디렉토리 구조 최종 정리
- `cursor/`, `copilot/`, `windsurf/` — 이번 scope 밖, 추후 확장

### 현재 저장소 구조 (변경 후)

```
My_AI_manual/
├── .claude/
│   └── settings.local.json
├── blueprints/              ← _shared/에서 리네이밍 완료
│   ├── README.md
│   ├── base-directives.md
│   ├── build-environment.md
│   ├── coding-standards.md
│   ├── design-principles.md
│   ├── environment.md
│   └── git-workflow.md
├── claude/
│   ├── README.md
│   ├── global_CLAUDE.md
│   └── project_CLAUDE.md
├── copilot/README.md
├── cursor/README.md
├── windsurf/README.md
├── CLAUDE.md
├── HANDOFF.md
├── README.md
└── TOOL_REFERENCE.md
```

---

## 워크스테이션 환경 메모

| 워크스테이션 | 환경 | 심볼릭 링크 상태 |
|-------------|------|-----------------|
| (기록 필요) | WSL2 | `~/.claude/CLAUDE.md` — 미설정 (defconfig로 관리 예정) |

> 심볼릭 링크는 `ai-platform-defconfig` 스킬이 관리할 예정.
> 스킬 완성 전 수동 설정이 필요하면:
> ```bash
> ln -sf ~/my_ai_manual/claude/global_CLAUDE.md ~/.claude/CLAUDE.md
> ```
