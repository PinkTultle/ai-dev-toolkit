# Blueprints — 공유 지식 레이어

도구에 무관하게 공통으로 적용되는 규칙과 지식의 **Single Source of Truth**.

## 파일 목록

| 파일 | 역할 |
|------|------|
| `base-directives.md` | AI 공통 기본 지침 (응답 언어, 커뮤니케이션) |
| `environment.md` | 환경 감지 및 적응 (WSL2, SSH, worktree 위치) |
| `design-principles.md` | 설계 우선 원칙 (계획서, 대안 제안, 문서 산출) |
| `agent-runtime.md` | 서브에이전트·스킬 정의 필드, 백그라운드 실행 모델, 모델/effort 선택 |
| `memory-and-context.md` | 지침 계층(CLAUDE.md, rules, 스킬), auto memory 운용 |
| `hooks.md` | 훅 이벤트·입출력 계약·작성 규칙 |
| `coding-standards.md` | C/C++ 임베디드 코딩 표준 |
| `git-workflow.md` | Git 브랜치/커밋/워크트리 규칙 |
| `build-environment.md` | 크로스 컴파일, 빌드 산출물 구조 |

> `agent-runtime.md` · `memory-and-context.md` · `hooks.md`는 **플랫폼 계층** 지식이다.
> 도구 런타임 동작에 의존하므로, 각 파일 상단에 검증한 Claude Code 버전을 명시하고
> 런타임 업그레이드 시 함께 갱신한다.

## 사용 방식

### 도구별 지침에서 참조
- `.claude/rules/` 파일은 blueprints를 Claude Code 형식(`paths` frontmatter)으로 변환한 파생물
- `claude/global_CLAUDE.md`는 rules 인덱스 + 기술 표준 참조 테이블

### 스킬에서 참조
- `/adt:project-configure` 스킬이 프로젝트 기술 스택에 맞는 blueprint를 선택하여 rules + `docs/stack/`에 적용
- `/adt:ai-platform-defconfig`는 `environment.md`의 환경 감지 기준을 활용 + 글로벌 rules 배포

## 새 blueprint 추가

특정 AI 도구에 종속되지 않는 **범용 기술 지식**은 blueprint에 바로 작성한다.

**blueprint에 작성하는 것:**
- 언어/프레임워크별 코딩 표준 (예: Python, Rust, React)
- 아키텍처 패턴 (예: 클린 아키텍처, 이벤트 드리븐)
- 테스트 전략, CI/CD, API 설계 규칙 등 도메인 공통 지식
- 프로젝트 횡단적으로 적용 가능한 기술 지침

**blueprint에 작성하지 않는 것:**
- 특정 프로젝트의 고유 설정/규칙 → 프로젝트 `CLAUDE.md`
- 프로젝트에서 발견한 로컬 패턴 → `docs/stack/`

**절차:**
1. `blueprints/<주제>.md` 작성 (200줄 이내, 기존 파일 톤/구조 준수)
2. 이 `README.md` 파일 목록에 추가
3. `global_CLAUDE.md` 4절 참조 테이블에 추가
4. 사용자에게 추가 의도와 내용을 설명하고 승인받은 후 커밋

### 외부 플러그인·프로젝트에서 지식 가져오기

다른 플러그인이나 프로젝트에 있는 지식(도메인 스킬, 체크리스트 등)을 옮길 때의 규칙:

1. **실제 작업에서 그 지식이 필요했던 경우에만** 가져온다. 쓸 것 같다는 이유로 미리 옮기지 않는다
2. 출처(플러그인명·버전·파일)를 blueprint 머리말에 적고, 특정 프로젝트에 종속된 내용을 뺀 뒤,
   **사용자와 합의한 내용만** 옮긴다
3. 도메인 지식은 프로젝트 rules 템플릿(`.claude/rules/project-*.md`)으로 두고 **반드시 `paths` 스코프를 건다**.
   항상 로드되는 글로벌 규칙에 넣지 않는다 — 무관한 프로젝트에도 계속 주입된다

## 수정 규칙

이 디렉토리의 파일은 **모든 도구의 지침에 영향**을 준다.
- 수정 후 `.claude/rules/` 파생 파일에 동기화 필요 (글로벌 rules 4개 + 프로젝트 rules 3개)
- `global_CLAUDE.md`는 인덱스만 포함하므로 별도 동기화 불필요
- 향후 다른 도구 지침이 추가되면 해당 도구에도 동기화
