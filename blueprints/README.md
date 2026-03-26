# Blueprints — 공유 지식 레이어

도구에 무관하게 공통으로 적용되는 규칙과 지식의 **Single Source of Truth**.

## 파일 목록

| 파일 | 역할 |
|------|------|
| `base-directives.md` | AI 공통 기본 지침 (응답 언어, 커뮤니케이션) |
| `environment.md` | 환경 감지 및 적응 (WSL2, SSH) |
| `design-principles.md` | 설계 우선 원칙 (계획서, 대안 제안, 문서 산출) |
| `coding-standards.md` | C/C++ 임베디드 코딩 표준 |
| `git-workflow.md` | Git 브랜치/커밋/워크트리 규칙 |
| `build-environment.md` | 크로스 컴파일, 빌드 산출물 구조 |

## 사용 방식

### 도구별 지침에서 참조
- `claude/global_CLAUDE.md`는 1~3절 내용을 인라인 포함
- 4절(기술 표준)은 경로 참조 방식으로 사용

### 스킬에서 참조
- `/project-configure` 스킬이 프로젝트 기술 스택에 맞는 blueprint를 선택하여 적용
- `/ai-platform-defconfig`는 `environment.md`의 환경 감지 기준을 활용

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

## 수정 규칙

이 디렉토리의 파일은 **모든 도구의 지침에 영향**을 준다.
- 수정 후 `claude/global_CLAUDE.md`에 동기화 필요 (1~3절 인라인 포함분)
- 향후 다른 도구 지침이 추가되면 해당 도구에도 동기화
