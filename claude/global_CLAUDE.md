# Claude Code 글로벌 규칙 매뉴얼
> 모든 환경(WSL2, SSH 원격 서버)에서 일괄 적용되는 규칙입니다.
> 위치: `~/.claude/CLAUDE.md`

---

## 1. 환경 감지 및 적응

환경별 동작 규칙은 `~/My_AI_manual/_shared/environment.md`를 참조한다.

---

## 2. 응답 언어 및 커뮤니케이션

응답 언어, 커뮤니케이션, 작업 기록 규칙은 `~/My_AI_manual/_shared/base-directives.md`를 참조한다.

---

## 3. 설계 우선 원칙

설계 계획서, 대안 제안, 구현 문서, 기술 부채 규칙은 `~/My_AI_manual/_shared/design-principles.md`를 참조한다.

---

## 4. 기술 표준 참조

C/C++ 코딩 표준, Git 워크플로우, 빌드 환경 등의 기술 지식은 이 파일에 포함하지 않는다.
해당 프로젝트의 기술 스택에 맞는 지침은 `~/My_AI_manual/_shared/` 디렉토리를 참조한다.

| 주제 | 참조 파일 |
|------|-----------|
| AI 공통 기본 지침 | `_shared/base-directives.md` |
| 환경 감지 및 적응 | `_shared/environment.md` |
| 설계 우선 원칙 | `_shared/design-principles.md` |
| C/C++ 코딩 표준 | `_shared/coding-standards.md` |
| Git 워크플로우 | `_shared/git-workflow.md` |
| 임베디드 빌드 환경 | `_shared/build-environment.md` |

---

## 5. 코드 리뷰 및 산출물 기준

Claude Code가 코드를 제안하거나 수정할 때 항상 충족해야 할 기준:

- [ ] 컴파일 경고 0개 (`-Wall -Wextra` 기준)
- [ ] 새로운 TODO/FIXME는 이유와 함께 기록
- [ ] 함수 길이 50줄 이하 (초과 시 분리 제안)
- [ ] 전역 변수 신규 추가 시 정당성 설명
- [ ] 인터럽트 핸들러에 블로킹 코드 없음
- [ ] 구현 문서 산출 (주요 기능 변경 시)

---

*이 파일은 `~/.claude/CLAUDE.md`에 위치하며, 모든 프로젝트에 전역 적용됩니다.*
*프로젝트별 세부 규칙은 각 프로젝트 루트의 `CLAUDE.md`에서 오버라이드합니다.*
