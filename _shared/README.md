# 공유 지식 레이어

도구에 무관하게 공통으로 적용되는 규칙과 지식을 관리하는 디렉토리.

## 현재 상태

아직 공유 파일이 분리되지 않았다.
현재는 `claude/global_CLAUDE.md`가 사실상 공유 지식의 원본 역할을 한다.

## 향후 추출 예정 항목

`claude/global_CLAUDE.md`에서 도구 공통 내용을 분리할 수 있다:

| 주제 | 예상 파일명 | 출처 (현재) |
|------|------------|-------------|
| C/C++ 코딩 표준 | `coding-standards.md` | global_CLAUDE.md 섹션 4 |
| Git 워크플로우 | `git-workflow.md` | global_CLAUDE.md 섹션 5 |
| 임베디드 빌드 환경 | `build-environment.md` | global_CLAUDE.md 섹션 6 |
| 설계 원칙 | `design-principles.md` | global_CLAUDE.md 섹션 3 |
| 환경 설정 (WSL2/SSH) | `environment.md` | global_CLAUDE.md 섹션 1 |

## 사용 방식

각 도구의 지침 파일에서 이 디렉토리의 내용을 참조하거나,
도구별 형식에 맞게 변환하여 사용한다.
