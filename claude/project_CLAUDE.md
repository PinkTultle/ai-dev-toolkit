# {{PROJECT_NAME}} — Claude Code 프로젝트 규칙
> 위치: `<프로젝트 루트>/CLAUDE.md`
> 글로벌 규칙(`~/.claude/CLAUDE.md`)을 상속하며, 이 파일에서 오버라이드/추가합니다.
>
> 이 파일은 `/project-init`으로 복제된 템플릿입니다.
> `{{...}}` placeholder는 `/project-configure` 또는 수동으로 채우세요.

---

## 프로젝트 개요

```
프로젝트명  : {{PROJECT_NAME}}
설명        : {{PROJECT_DESCRIPTION}}
주요 언어   : {{LANGUAGE}}
```

<!-- 임베디드 프로젝트인 경우 아래 주석을 해제하고 채우세요 -->
<!-- ```
타겟 보드   : {{TARGET_BOARD}}
툴체인      : {{TOOLCHAIN}}
OS/RTOS     : {{OS_RTOS}}
빌드 시스템 : {{BUILD_SYSTEM}}
``` -->

---

## 1. 프로젝트 디렉토리 구조

```
{{PROJECT_NAME}}/
├── CLAUDE.md              ← 이 파일
├── {{DIRECTORY_STRUCTURE}}
```

> `/project-configure` 실행 시 실제 디렉토리 구조를 분석하여 자동 채움

---

## 2. 환경별 설정

<!-- 프로젝트 환경에 맞게 수정하세요 -->

### WSL2
```bash
# {{WSL2_SPECIFIC_SETTINGS}}
```

### SSH
```bash
# {{SSH_SPECIFIC_SETTINGS}}
```

---

## 3. 아키텍처 규칙

<!-- 프로젝트의 레이어/모듈 구조에 맞게 작성하세요 -->
<!-- 예시: 임베디드 레이어 아키텍처, MVC, Clean Architecture 등 -->

```
{{ARCHITECTURE_DIAGRAM}}
```

---

## 4. 프로젝트별 코드 규칙

### 4.1 네이밍 컨벤션
<!-- 모듈 접두사, 함수명 규칙 등 -->

### 4.2 프로젝트 고유 규칙
<!-- 이 프로젝트에만 적용되는 특수 규칙 -->

---

## 5. 빌드/실행 명령어

```bash
# {{BUILD_COMMANDS}}
```

---

## 6. Git 워크플로우

### 브랜치 구조
```
{{BRANCH_STRATEGY}}
```

---

## 7. 구현 문서 산출 위치

```
docs/impl/
├── YYYYMMDD_기능명.md     # 구현 완료 후 자동 산출
└── README.md              # 문서 인덱스
```

문서 형식은 글로벌 규칙 **3.3절** 형식을 따릅니다.

---

## 8. 알려진 이슈 및 해결책

| 환경 | 증상 | 해결책 |
|------|------|--------|
| | | |

---

*글로벌 규칙과 충돌 시 이 파일의 규칙이 우선합니다.*
