# 임베디드 빌드 환경

> 도구 무관 공유 지식 — 모든 AI 코딩 어시스턴트에 적용
> 임베디드 프로젝트 기준. 비-임베디드 프로젝트에서는 프로젝트별 규칙에서 오버라이드 가능.

---

## 1. 크로스 컴파일 기본 원칙

- 호스트/타겟 툴체인 명확히 구분
- `which arm-linux-gnueabihf-gcc` 등으로 툴체인 존재 먼저 확인
- Makefile 변수:
```makefile
CROSS_COMPILE ?= arm-linux-gnueabihf-
CC  = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
AR  = $(CROSS_COMPILE)ar
```

---

## 2. 빌드 산출물 관리

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

---

## 3. .gitignore 필수 항목 (C/C++ 임베디드)

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
