# [프로젝트명] — Claude Code 프로젝트 규칙
> 위치: `<프로젝트 루트>/CLAUDE.md`
> 글로벌 규칙(`~/.claude/CLAUDE.md`)을 상속하며, 이 파일에서 오버라이드/추가합니다.

---

## 프로젝트 개요

```
프로젝트명  : [예: ROOTECH PowerMeter Firmware]
타겟 보드   : [예: i.MX28 / BeagleBone Black / STM32F4xx]
툴체인      : [예: arm-linux-gnueabihf-gcc 9.3.0]
OS/RTOS     : [예: Linux 5.x / Bare-metal / FreeRTOS]
빌드 시스템 : [예: Make / CMake]
주요 언어   : C99 / C++14
```

---

## 1. 프로젝트 디렉토리 구조

```
project-root/
├── CLAUDE.md              ← 이 파일
├── src/
│   ├── drivers/           # 하드웨어 드라이버 레이어
│   ├── hal/               # Hardware Abstraction Layer
│   ├── app/               # 애플리케이션 로직
│   └── utils/             # 공통 유틸리티
├── include/
│   ├── drivers/
│   ├── hal/
│   └── app/
├── tests/                 # 유닛 테스트 (PC 네이티브 빌드)
├── docs/                  # 구현 문서 산출 위치
│   └── impl/              # Claude Code 자동 산출 문서
├── scripts/               # 빌드/배포/Git 자동화
│   ├── hooks/             # Git hooks (심볼릭 링크로 .git/hooks/ 연결)
│   └── build.sh
├── build/                 # 빌드 산출물 (gitignore)
└── Makefile / CMakeLists.txt
```

---

## 2. 환경별 설정 오버라이드

### WSL2에서 이 프로젝트 작업 시
```bash
# 툴체인 경로 (WSL2 내 설치 위치)
export CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-

# worktree는 WSL2 파일시스템에만 생성
# ✅ ~/projects/project-feature
# ❌ /mnt/c/projects/project-feature
```

### SSH 원격 서버에서 이 프로젝트 작업 시
```bash
# 툴체인 경로 (서버 설치 위치 — 절대경로)
export CROSS_COMPILE=/opt/toolchain/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

# 빌드 전 환경 확인
scripts/check_env.sh
```

---

## 3. 레이어 아키텍처 규칙

이 프로젝트는 계층화된 아키텍처를 사용합니다. **Claude Code는 레이어 경계를 절대 침범하지 않습니다.**

```
[ APP Layer ]      app/         → 비즈니스 로직, HAL만 호출 가능
     ↓ (only)
[ HAL Layer ]      hal/         → 하드웨어 추상화, drivers/ 호출 가능
     ↓ (only)
[ Driver Layer ]   drivers/     → 레지스터 직접 접근, 이식성 없음
```

- **APP → drivers/ 직접 호출 금지** (HAL 경유 필수)
- 레이어 위반이 필요한 경우 → 반드시 사전에 이유 설명 후 승인 요청

---

## 4. 프로젝트별 코드 규칙 오버라이드

### 4.1 모듈 접두사 네이밍
각 모듈은 고유 접두사를 사용합니다:
```c
// 예시: 모터 드라이버 모듈
motor_init()
motor_set_speed()
motor_get_status()

// 예시: 전력 측정 모듈
pmeter_read_voltage()
pmeter_calibrate()
```

> 새 모듈 추가 시 이 섹션에 접두사 등록 필수

### 4.2 인터럽트 핸들러 명명
```c
// 형식: <모듈>_<소스>_IRQHandler
void UART1_RX_IRQHandler(void);
void TIM2_OVF_IRQHandler(void);
```

### 4.3 하드웨어 의존 상수
레지스터 주소, 하드웨어 타이밍 상수는 반드시 `include/drivers/hw_config.h`에 집중:
```c
// ✅ 올바른 방식
#include "hw_config.h"
WRITE_REG(UART_BASE + UART_CR_OFFSET, val);

// ❌ 금지: 소스 파일 내 하드코딩
WRITE_REG(0x40011000 + 0x0C, val);
```

---

## 5. 빌드 명령어

Claude Code가 참조하는 표준 빌드 명령어:

```bash
# 디버그 빌드
make DEBUG=1

# 릴리즈 빌드
make RELEASE=1

# 크로스 컴파일
make CROSS_COMPILE=arm-linux-gnueabihf-

# 클린
make clean

# 네이티브 유닛 테스트 빌드/실행
make test

# 환경 확인
scripts/check_env.sh
```

---

## 6. Git 워크플로우 — 프로젝트 확장

### 6.1 이 프로젝트의 브랜치 구조
```
main          → 검증된 릴리즈 (태그 필수)
develop       → 통합 (CI 통과 필수)
feature/xxx   → 기능 개발 (worktree 활용)
fix/xxx       → 버그 수정
hw/xxx        → 하드웨어 의존 변경
```

### 6.2 Git Hooks 설치
프로젝트 클론 후 한 번만 실행:
```bash
scripts/install_hooks.sh
# 또는 수동으로:
ln -sf ../../scripts/hooks/pre-commit .git/hooks/pre-commit
ln -sf ../../scripts/hooks/commit-msg .git/hooks/commit-msg
```

### 6.3 Worktree 기반 병렬 작업 패턴
```bash
# 신규 기능 worktree 생성
git worktree add ../$(basename $PWD)-feature feature/new-feature

# 핫픽스 worktree (main 기반)
git worktree add ../$(basename $PWD)-hotfix -b fix/critical-bug main

# 작업 완료 후 정리
git worktree remove ../$(basename $PWD)-feature
git branch -d feature/new-feature
```

### 6.4 릴리즈 태깅 규칙
```bash
# Semantic Versioning: v<major>.<minor>.<patch>
git tag -a v1.2.0 -m "feat: 전력 품질 분석 기능 추가"
git push origin v1.2.0
```

---

## 7. 구현 문서 산출 위치

Claude Code가 자동 산출하는 구현 문서는 `docs/impl/` 에 저장합니다:
```
docs/impl/
├── YYYYMMDD_기능명.md     # 구현 완료 후 자동 산출
└── README.md              # 문서 인덱스
```

문서 형식은 글로벌 규칙 **3.3절** 형식을 따릅니다.

---

## 8. 알려진 환경 이슈 및 해결책

> 이 프로젝트에서 발견된 환경별 이슈를 누적 기록합니다.

| 환경 | 증상 | 해결책 |
|------|------|--------|
| WSL2 | make 실행 시 `\r` 문자 오류 | `dos2unix Makefile` 실행 |
| SSH  | 툴체인 미인식 | `source /etc/profile.d/toolchain.sh` |
| (추가) | | |

---

*프로젝트별 추가 규칙은 이 파일에 섹션을 추가하여 관리합니다.*
*글로벌 규칙과 충돌 시 이 파일의 규칙이 우선합니다.*
