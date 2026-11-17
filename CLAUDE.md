# ai-dev-toolkit — 프로젝트 규칙
> 이 파일은 Claude Code가 이 저장소에서 작업할 때 참조하는 프로젝트 규칙입니다.
> 글로벌 규칙(`~/.claude/CLAUDE.md`)을 상속하며, 이 파일의 규칙이 우선합니다.

---

## 0. 인수인계

**새 세션 시작 시 [`HANDOFF.md`](HANDOFF.md)를 먼저 읽는다.**
이전 세션의 작업 내용, 현재 상태, 다음 작업 후보가 기록되어 있다.
작업 완료 시 `HANDOFF.md`를 갱신하고 커밋한다.

---

## 1. 저장소 개요

AI 코딩 어시스턴트의 **지침 라이브러리이자 Claude Code 플러그인(`adt`)**.
워크스테이션 세팅부터 프로젝트 초기화까지 스킬로 자동화된 흐름을 제공한다.

### 핵심 흐름
```
플러그인 설치 → /adt:ai-platform-defconfig (1회)
                        ↓
              새 프로젝트마다 → /adt:project-init → /adt:project-configure
```

> 스킬 목록, 디렉토리 구조, 계층 설명은 [`docs/project-structure.md`](docs/project-structure.md) 참조.

### 디렉토리 탐색 규칙
새 디렉토리에 진입할 때는 다음 순서를 따른다:
1. 해당 디렉토리에 `README.md`가 있는지 확인
2. **있으면** → `README.md`를 먼저 읽고 그 안내에 따라 작업 진행
3. **없으면** → 상위 디렉토리의 `README.md`를 참조

---

## 2. 파일 편집 규칙

### 2.1 문서 작성 언어
- **한국어** 기본 (코드, 명령어, 기술 용어, 파일 경로는 영어 그대로)
- 도구 지침 파일 내 규칙 설명도 한국어

### 2.2 파일 형식
- 인코딩: UTF-8, LF 줄바꿈 (CRLF 금지)
- Markdown 형식 준수
- 각 도구의 지침 파일은 해당 도구가 요구하는 형식을 따름:
  - Claude Code: 표준 Markdown (스킬은 YAML frontmatter 포함)
  - Cursor: MDC (Markdown + YAML frontmatter)
  - Copilot: Markdown (glob 패턴 frontmatter)
  - Windsurf: Markdown (파일당 12,000자 제한)

### 2.3 지침 파일 수정 시 주의사항
- 글로벌 규칙(`global_CLAUDE.md`) 수정은 **모든 프로젝트에 영향** — 신중하게
- 새 섹션 추가 시 기존 섹션 번호 체계 유지
- 도구 공통 내용은 `blueprints/`로 분리 가능성을 고려
- `TOOL_REFERENCE.md` 변경 시 해당 도구의 README.md도 함께 갱신

### 2.4 스킬 수정 시 주의사항
- 스킬 파일은 `.claude/skills/<name>/SKILL.md`에 위치
- YAML frontmatter의 `allowed-tools`, `description` 변경은 동작에 직접 영향
- 스킬이 참조하는 템플릿 파일(`claude/project_CLAUDE.md` 등)과 동기화 유지

### 2.5 지침 파일 줄 수 제한
- 지침 성격의 파일(SKILL.md, blueprints/*.md, CLAUDE.md, 도구별 지침)은 **200줄 이내** 유지
- **`docs/` 하위 문서는 제외** — 사용 가이드, 참조 문서 등은 줄 수 제한을 적용하지 않는다
- 초과 시: 섹션 분리, 중복 제거, 표현 압축으로 줄인다
- 의미 보존이 우선 — 줄 수를 맞추기 위해 핵심 내용을 삭제하지 않는다
- 구조적으로 분리가 자연스러운 경우 별도 파일로 분리한다 (blueprints/ 또는 docs/ 활용)
- 일괄 최적화가 필요하면 `/adt:optimize-docs` 스킬을 사용한다

---

## 3. 배포 및 동기화

이 저장소는 **스킬을 통해 배포를 자동화**한다.

### 3.1 배포 방식
| 대상 | 스킬 | 방식 |
|------|------|------|
| 글로벌 규칙 (`~/.claude/CLAUDE.md`) | `/adt:ai-platform-defconfig` | 심볼릭 링크 생성/갱신 |
| 글로벌 rules (`~/.claude/rules/`) | `/adt:ai-platform-defconfig` | 파일별 심볼릭 링크 (접두사 제거) |
| 프로젝트 규칙 (`<project>/CLAUDE.md`) | `/adt:project-init` | 템플릿 복제 |
| 프로젝트 rules (`<project>/.claude/rules/`) | `/adt:project-configure` | 기술 스택에 맞는 파일 선택 복제 |
| 프로젝트 구체화 | `/adt:project-configure` | 대화형 placeholder 채움 |

### 3.2 수동 배포 (스킬 미사용 시)
```bash
# 글로벌 규칙 심볼릭 링크
ln -sf $(pwd)/claude/global_CLAUDE.md ~/.claude/CLAUDE.md

# 프로젝트 규칙 복제
cp claude/project_CLAUDE.md <project-root>/CLAUDE.md
```

### 3.3 다른 도구 배포
각 도구 디렉토리의 `README.md`에 배포 방법이 기재되어 있다.
새 도구 지침 추가 시:
1. 도구 디렉토리에 지침 파일 작성
2. 도구 디렉토리 `README.md`에 배포 방법 기재
3. `TOOL_REFERENCE.md`에 매핑 정보 추가

---

## 4. 이 저장소에서의 작업 원칙

### 4.1 역할 인식
이 저장소는 **AI 도구 지침의 라이브러리이자 플랫폼 도구**다.
- 글로벌 규칙의 임베디드 C/C++ 관련 섹션은 이 저장소 자체에는 적용하지 않는다
- 여기서 작성하는 지침은 **다른 프로젝트에서 AI가 참조할 기반**이 된다는 점을 항상 의식한다
- 스킬은 **실제 사용하면서 점진적으로 구체화**한다 — 완벽하게 만들고 배포하는 방식이 아님

### 4.2 골격 유지 원칙
- 지침은 **방향과 원칙** 수준으로 작성한다 — 지나치게 구체적인 프로젝트별 내용은 넣지 않는다
- 프로젝트에서 확장/오버라이드할 수 있는 여지를 남긴다
- 예시를 포함하되, 특정 프로젝트에 종속되지 않는 범용적인 예시를 사용한다
- 하나의 지침이 여러 도구에 공통이면 `blueprints/`에, 특정 도구 전용이면 해당 도구 디렉토리에 배치한다

### 4.3 변경 영향 인식
- `blueprints/` 수정 → 모든 도구의 지침에 영향 가능
- `claude/global_CLAUDE.md` 수정 → 심볼릭 링크로 **모든 프로젝트에 즉시 반영**
- `.claude/skills/` 수정 → 이 저장소에서 실행하는 스킬에 즉시 반영
- 영향 범위가 큰 변경은 사전에 변경 의도와 영향 범위를 설명한 후 진행

### 4.4 브랜치 전략
- **main** — 안정 브랜치. `~/.claude/CLAUDE.md` 심볼릭 링크가 여기를 가리킴
- **작업 브랜치** — `<type>/<설명>` 형식으로 생성 → PR → squash merge → main
  - 접두사: `feat/`, `fix/`, `docs/`, `chore/`
  - 예: `feat/add-cursor-rules`, `fix/symlink-path`
- main 직접 push 금지 — 반드시 PR을 통해 머지
- `develop` 브랜치 없음 — 이 저장소 규모에 불필요

### 4.5 버전 정책
- 상세 정책: [`VERSIONING.md`](VERSIONING.md), 변경 이력: [`CHANGELOG.md`](CHANGELOG.md)
- 의미 있는 변경 묶음 완료 시 `VERSION` 파일 갱신 + git tag
- 배포된 프로젝트 추적: `workstations/registry.md` + `<alias>.local.json`

### 4.6 커밋 규칙
- Conventional Commits 형식 준수
- 타입: `docs` (지침 내용 변경), `chore` (구조/배포 변경), `feat` (새 스킬/새 지침 파일 추가)
- 예시: `feat(skills): ai-platform-defconfig 스킬 추가`

### 4.7 일관성 유지
- 새 지침 파일 작성 시 기존 파일의 톤, 구조, 형식을 따른다
- 도구 디렉토리 추가 시 `README.md`를 반드시 포함한다
- `TOOL_REFERENCE.md`와 각 도구 `README.md`의 정보를 동기화 상태로 유지한다

---

*이 파일은 `ai-dev-toolkit` 저장소 루트에 위치하며, Claude Code가 이 저장소 작업 시 자동 참조합니다.*
