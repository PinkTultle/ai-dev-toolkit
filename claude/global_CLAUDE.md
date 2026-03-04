# Claude Code 글로벌 규칙 매뉴얼
> 모든 환경(WSL2, SSH 원격 서버)에서 일괄 적용되는 규칙입니다.
> 위치: `~/.claude/CLAUDE.md`

---

## 1. 환경 감지 및 적응

Claude Code는 작업 시작 시 현재 환경을 자동으로 파악하고, 아래 기준에 맞게 동작을 조정합니다.

```
환경 판별 우선순위:
1. $WSL_DISTRO_NAME 존재 → WSL2 환경
2. $SSH_CLIENT 또는 $SSH_TTY 존재 → 원격 SSH 환경
3. 그 외 → 로컬 Linux Native
```

### WSL2 환경 주의사항
- Windows 경로(`C:\...`)와 Linux 경로(`/mnt/c/...`) 혼용 금지 — 항상 Linux 경로 사용
- `git worktree` 경로는 반드시 WSL2 파일시스템 내부(`~/` 또는 `/home/...`)에 위치
- Windows 실행파일(`.exe`) 호출이 필요한 경우 명시적으로 경고 후 진행

### SSH 원격 환경 주의사항
- 툴체인 경로는 절대경로 사용 (환경변수 의존 최소화)
- 세션 종료 시 소실될 수 있는 작업은 반드시 커밋 또는 stash 후 진행
- `screen` / `tmux` 세션 여부 확인 권장

---

## 2. 응답 언어 및 커뮤니케이션

- **응답 언어**: 한국어 (코드, 명령어, 기술 용어는 영어 그대로)
- 질문은 1회에 1개만 (여러 선택지가 필요하면 번호 목록으로 제시)
- 확인 없이 파괴적 작업(삭제, 덮어쓰기, force push 등) 절대 불가

---

## 3. 설계 우선 원칙 (바이브 코딩 + 지식 학습)

모든 코드 작성 전, 아래 순서를 따릅니다.

### 3.1 설계 의도 먼저 설명
구현 전에 반드시 다음을 설명합니다:
```
[설계 의도]
- 목적: 무엇을 해결하려는가
- 접근 방식: 왜 이 방법을 선택했는가
- 트레이드오프: 이 방식의 장단점
- 대안: 다른 방법이 있다면 함께 제시
```

### 3.2 능동적 대안 제안
현재 요청보다 더 나은 방법이 있을 경우:
```
💡 [대안 제안]
요청하신 방법 외에 [대안] 방식도 고려해보세요.
이유: ...
단, 요청하신 방법으로 먼저 진행할 수도 있습니다. 어떻게 할까요?
```

### 3.3 구현 문서 자동 산출
기능 구현 완료 후 다음 형식의 문서를 산출합니다:
```markdown
## [기능명] 구현 요약

### 변경 파일
- `path/to/file.c` : 변경 내용 한 줄 설명

### 핵심 로직
설계 의도와 주요 알고리즘 설명 (3~7줄)

### 사용 방법
코드 예시 또는 호출 방법

### 알려진 한계 / 향후 개선점
- [ ] TODO 항목
```

### 3.4 기술 부채 명시
임시 방편이나 개선이 필요한 코드에는 반드시 표시:
```c
// TODO(이유): 설명 — 추후 [더 나은 방법]으로 개선 필요
// FIXME(긴급도): 설명 — 현재 [문제점] 발생 가능
// HACK: 설명 — [조건]에서만 동작하는 임시 코드
```

---

## 4. C/C++ 임베디드 코드 스타일

### 4.1 기본 컨벤션
- 인덴트: 4 spaces (탭 금지)
- 줄 길이: 100자 이하 권장, 120자 하드 제한
- 인코딩: UTF-8, LF 줄바꿈 (CRLF 절대 금지 — WSL2 특히 주의)

### 4.2 네이밍 규칙
```c
// 전처리기 매크로: ALL_CAPS_SNAKE
#define MAX_BUFFER_SIZE  256

// 타입/구조체: PascalCase (typedef 포함)
typedef struct MotorStatus { ... } MotorStatus_t;

// 함수: lower_snake_case, 모듈_동사_목적어 형식
uint8_t motor_get_speed(MotorHandle_t *handle);

// 전역 변수: g_ 접두사
static uint32_t g_tick_count = 0;

// 로컬 변수: lower_snake_case
uint8_t read_val = 0;

// 상수/열거형: k_ 접두사 또는 ALL_CAPS
const uint32_t kTimeoutMs = 1000;
```

### 4.3 헤더 가드
```c
#ifndef MODULE_NAME_H_
#define MODULE_NAME_H_

#ifdef __cplusplus
extern "C" {
#endif

/* 내용 */

#ifdef __cplusplus
}
#endif

#endif /* MODULE_NAME_H_ */
```

### 4.4 안전한 코딩 (임베디드 필수)
- `malloc` / `free` 동적 메모리 할당: 힙이 제한된 환경에서는 사용 금지, 사용 시 반드시 경고
- 포인터 역참조 전 NULL 체크 필수
- 정수 오버플로우 주의 — 명시적 캐스팅 사용
- 인터럽트 핸들러 내: `volatile` 변수, 최소한의 코드만
- 재진입 불가 함수는 헤더에 `/* NOT REENTRANT */` 명시

### 4.5 에러 처리 패턴
```c
// 반환값 기반 에러 처리 (예외 없는 C 환경)
typedef enum {
    ERR_OK    = 0,
    ERR_PARAM = -1,
    ERR_TIMEOUT = -2,
} ErrorCode_t;

ErrorCode_t do_something(uint8_t *buf, size_t len) {
    if (buf == NULL || len == 0) return ERR_PARAM;
    /* ... */
    return ERR_OK;
}
```

---

## 5. Git 워크플로우 — 자동화 및 확장

### 5.1 브랜치 전략
```
main          → 배포/릴리즈 (직접 push 금지)
develop       → 통합 브랜치
feature/xxx   → 기능 개발
fix/xxx       → 버그 수정
refactor/xxx  → 리팩토링
docs/xxx      → 문서
chore/xxx     → 빌드/툴링
```

### 5.2 커밋 메시지 컨벤션 (Conventional Commits)
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

### 5.3 Git Worktree 활용 (핵심)
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
> ⚠️ WSL2: worktree 경로는 반드시 `/home/` 하위 — `/mnt/c/` 경로 사용 시 성능 저하 및 심볼릭 링크 문제 발생

### 5.4 Git Hooks 자동화
`.git/hooks/` 또는 프로젝트 루트 `hooks/` 디렉토리에서 관리:

**pre-commit** (커밋 전 자동 검사):
```bash
#!/bin/sh
# 1. CRLF 라인 엔딩 감지
if git diff --cached --check | grep -q 'CRLF'; then
    echo "❌ CRLF 라인 엔딩 감지. dos2unix 실행 후 재시도"
    exit 1
fi
# 2. 디버그 코드 감지
if git diff --cached | grep -qE '^\+.*(printf\s*\(|DEBUG_PRINT)'; then
    echo "⚠️  디버그 출력 코드 감지. 의도적이면 --no-verify 사용"
    exit 1
fi
```

**commit-msg** (커밋 메시지 형식 검사):
```bash
#!/bin/sh
MSG=$(cat "$1")
PATTERN='^(feat|fix|refactor|docs|chore|test|perf|ci)(\(.+\))?: .{1,72}'
if ! echo "$MSG" | grep -qE "$PATTERN"; then
    echo "❌ 커밋 메시지 형식 오류"
    echo "   형식: <type>(<scope>): <subject>"
    exit 1
fi
```

### 5.5 자동화 스크립트 패턴
Claude Code가 생성하는 자동화 스크립트는 다음 구조를 따릅니다:
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

---

## 6. 임베디드 빌드 환경

### 6.1 크로스 컴파일 기본 원칙
- 호스트/타겟 툴체인 명확히 구분
- `which arm-linux-gnueabihf-gcc` 등으로 툴체인 존재 먼저 확인
- Makefile 변수:
```makefile
CROSS_COMPILE ?= arm-linux-gnueabihf-
CC  = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
AR  = $(CROSS_COMPILE)ar
```

### 6.2 빌드 산출물 관리
```
project/
├── src/          # 소스
├── include/      # 헤더
├── build/        # 빌드 산출물 (git 제외)
│   ├── debug/
│   └── release/
├── docs/         # 구현 문서 (자동 산출)
└── scripts/      # 자동화 스크립트
```

### 6.3 .gitignore 필수 항목 (C/C++ 임베디드)
```gitignore
# 빌드 산출물
build/
*.o
*.a
*.so
*.elf
*.bin
*.hex
*.map

# IDE
.vscode/settings.json
*.launch
*.cproject

# 디버그
*.log
core
```

---

## 7. 코드 리뷰 및 산출물 기준

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
