# Git 워크플로우

> 도구 무관 공유 지식 — 모든 AI 코딩 어시스턴트에 적용

---

## 1. 브랜치 전략

```
main          → 배포/릴리즈 (직접 push 금지)
develop       → 통합 브랜치
feature/xxx   → 기능 개발
fix/xxx       → 버그 수정
refactor/xxx  → 리팩토링
docs/xxx      → 문서
chore/xxx     → 빌드/툴링
```

---

## 2. 커밋 메시지 컨벤션 (Conventional Commits)

```
<type>(<scope>): <subject>

[body - 선택사항]
왜 이 변경이 필요한가? (what/why, not how)

[footer - 선택사항]
Refs: #이슈번호
BREAKING CHANGE: 설명
```
**타입**: `feat` `fix` `refactor` `docs` `chore` `test` `perf` `ci`

예시:
```
feat(motor): 속도 피드백 제어 루프 추가

PI 제어기 기반으로 모터 속도 안정화 구현.
하드코딩된 Kp/Ki 값은 추후 EEPROM 설정으로 이전 예정.

TODO: EEPROM 기반 파라미터 런타임 조정 기능
Refs: #42
```

---

## 3. Git Worktree 활용 (핵심)

병렬 작업을 위한 worktree 사용 — 브랜치 전환 없이 여러 작업 동시 진행:
```bash
# worktree 생성
git worktree add ../project-feature feature/new-feature

# worktree 목록 확인
git worktree list

# worktree 제거 (브랜치 병합 후)
git worktree remove ../project-feature
git branch -d feature/new-feature
```
> WSL2: worktree 경로는 반드시 `/home/` 하위 — `/mnt/c/` 경로 사용 시 성능 저하 및 심볼릭 링크 문제 발생

---

## 4. Git Hooks 자동화

`.git/hooks/` 또는 프로젝트 루트 `hooks/` 디렉토리에서 관리:

**pre-commit** (커밋 전 자동 검사):
```bash
#!/bin/sh
# 1. CRLF 라인 엔딩 감지
if git diff --cached --check | grep -q 'CRLF'; then
    echo "CRLF 라인 엔딩 감지. dos2unix 실행 후 재시도"
    exit 1
fi
# 2. 디버그 코드 감지
if git diff --cached | grep -qE '^\+.*(printf\s*\(|DEBUG_PRINT)'; then
    echo "디버그 출력 코드 감지. 의도적이면 --no-verify 사용"
    exit 1
fi
```

**commit-msg** (커밋 메시지 형식 검사):
```bash
#!/bin/sh
MSG=$(cat "$1")
PATTERN='^(feat|fix|refactor|docs|chore|test|perf|ci)(\(.+\))?: .{1,72}'
if ! echo "$MSG" | grep -qE "$PATTERN"; then
    echo "커밋 메시지 형식 오류"
    echo "   형식: <type>(<scope>): <subject>"
    exit 1
fi
```

---

## 5. 자동화 스크립트 패턴

자동화 스크립트는 다음 구조를 따른다:
```bash
#!/bin/bash
set -euo pipefail  # 에러 즉시 종료, 미정의 변수 에러, 파이프 에러 전파

# 사용법 출력
usage() {
    echo "Usage: $0 <arg1> [arg2]"
    exit 1
}

# 환경 체크
check_env() {
    command -v git >/dev/null 2>&1 || { echo "git이 필요합니다"; exit 1; }
}

main() {
    check_env
    # 로직
}

main "$@"
```
