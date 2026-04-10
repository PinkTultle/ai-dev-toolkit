# {{PROJECT_NAME}} — Claude Code 프로젝트 규칙
> 기반: ai-dev-toolkit v{{BASE_VERSION}}.0
>
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

<!-- 텍스트 플로우 다이어그램으로 주요 데이터 흐름을 기술하세요 -->
<!-- 예시:
```
입력 (HTTP POST /api)
  → Controller (요청 검증)
    → Service (비즈니스 로직)
      → Repository (DB 접근)
        → 응답 반환
```
-->

```
{{ARCHITECTURE_DIAGRAM}}
```

<!-- 핵심 아키텍처 결정을 규칙으로 명시하세요 -->
<!-- 예: "외부 의존성 금지 — 표준 라이브러리만 사용" -->
<!-- 예: "설정 파일 기반 — 환경변수 대신 config.json 사용" -->

---

## 4. 프로젝트별 코드 규칙

### 4.1 네이밍 컨벤션
<!-- 모듈 접두사, 함수명 규칙 등 -->

### 4.2 설정/시크릿 파일 규칙
<!-- 시크릿이 포함된 설정 파일의 보호 규칙을 명시하세요 -->
<!-- 예: "config.json에 실제 토큰 포함 — 절대 커밋 금지" -->
<!-- 예: "새 설정 항목 추가 시 config.example.json도 함께 갱신" -->

### 4.3 프로젝트 고유 규칙
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

## 7. 산출물 및 지침 디렉토리

```
docs/
├── artifacts/           ← 작업 단위 산출물 (번호.작업명.md)
│   ├── ideation/        ← 아이디어 구체화
│   ├── design/          ← 설계 계획서
│   ├── review/          ← 설계 검토 기록
│   ├── summary/         ← 구현 요약
│   └── test-report/     ← 테스트 결과
├── stack/               ← 기술 스택별 지침 (언어/프레임워크명.md)
└── source/              ← 코드 설명 문서 (소스 트리 미러링)
    └── {{SOURCE_TREE}}  ← 코드 디렉토리와 동일 구조
```

- `artifacts/` 파일명: `<번호>.<작업명>.md` — 상세 규칙은 글로벌 규칙 **3.2절** 참조
- `stack/` : blueprints를 프로젝트에 맞게 마이그레이션한 기술 지침 + 로컬 패턴
  - `/project-configure` 대화 과정에서 관련 blueprint를 프로젝트 맥락에 맞춰 생성
  - 각 파일 헤더에 원본 blueprint 출처와 마이그레이션 내역 기록
  - 프로젝트에서 발견한 로컬 패턴도 여기에 누적
  - 예: `coding-standards.md`, `git-workflow.md`, `react.md`
- `source/` : 코드 파일(모듈)과 1:1 대응하는 설명 문서
  - 코드 구현·수정 시 대응 문서를 함께 생성/갱신
  - 파일명: 소스 확장자를 `.md`로 변경 (예: `uart.c` → `uart.md`)
  - 내용: 모듈 목적, 주요 함수/클래스 역할, 의존 관계, 주의사항

---

## 8. 알려진 이슈 및 해결책

<!-- 환경별 트러블슈팅을 테이블로 기록하세요 — AI가 동일 증상 발생 시 참조 -->

| 환경 | 증상 | 해결책 |
|------|------|--------|
| <!-- WSL2 --> | <!-- 예: API 타임아웃 --> | <!-- 예: VPN 연결 확인 --> |

---

*글로벌 규칙과 충돌 시 이 파일의 규칙이 우선합니다.*
