# 공유 지식 레이어

도구에 무관하게 공통으로 적용되는 규칙과 지식을 관리하는 디렉토리.

## 현재 상태

`claude/global_CLAUDE.md`에서 순차적으로 분리 중이다.

| 주제 | 파일명 | 상태 |
|------|--------|------|
| C/C++ 코딩 표준 | `coding-standards.md` | ✅ 분리 완료 |
| Git 워크플로우 | `git-workflow.md` | ✅ 분리 완료 |
| 임베디드 빌드 환경 | `build-environment.md` | ✅ 분리 완료 |
| 설계 원칙 | `design-principles.md` | 미분리 (global_CLAUDE.md 3절) |
| 환경 설정 (WSL2/SSH) | `environment.md` | 미분리 (global_CLAUDE.md 1절) |
| AI 공통 기본 지침 | `base-directives.md` | 미작성 |

## 사용 방식

각 도구의 지침 파일에서 이 디렉토리의 내용을 참조하거나,
도구별 형식에 맞게 변환하여 사용한다.
