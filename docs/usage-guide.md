# 사용 가이드

이 문서는 My AI Manual의 스킬별 상세 사용법과 시나리오를 설명한다.
기본 개요는 [README.md](../README.md)를 참조한다.

---

## 목차

1. [전체 워크플로우](#전체-워크플로우)
2. [워크스테이션 세팅](#1-워크스테이션-세팅--ai-platform-defconfig)
3. [프로젝트 초기화](#2-프로젝트-초기화--project-init)
4. [프로젝트 설정 구체화](#3-프로젝트-설정-구체화--project-configure)
5. [프로젝트 업데이트](#4-프로젝트-업데이트--project-update)
6. [지침 흡수](#5-지침-흡수--project-absorb)
7. [문서 최적화](#6-문서-최적화--optimize-docs)
8. [FAQ](#faq)

---

## 전체 워크플로우

```
[최초 1회]
  워크스테이션에 저장소 클론
       │
       ▼
  /ai-platform-defconfig
  · 심볼릭 링크 설정 (~/.claude/CLAUDE.md → 이 저장소)
  · 필수 패키지 확인
  · MCP 서버 설정
       │
[프로젝트마다]
       │
       ▼
  /project-init ~/my-project
  · CLAUDE.md, .claude/skills/ 골격 복제
  · 배포 추적 기록
       │
       ▼
  /project-configure
  · 대화형 1문 1답으로 기술 스택, 컨벤션 구체화
  · placeholder를 실제 값으로 채움
       │
[유지보수 — 필요 시]
       │
       ├─→ /project-absorb   (프로젝트 → 라이브러리)
       ├─→ /project-update    (라이브러리 → 프로젝트)
       └─→ /optimize-docs     (지침 파일 줄 수 관리)
```

---

## 1. 워크스테이션 세팅 — `/ai-platform-defconfig`

**언제**: 새 워크스테이션에서 처음 세팅할 때 (1회)

**실행**:
```
/ai-platform-defconfig
```

**수행 내용**:
1. 환경 자동 감지 (OS, WSL2/SSH/Native)
2. 워크스테이션 별칭 설정 (예: `pink-turtle`)
3. 필수 패키지 확인 (`git`, `jq`, `dos2unix`)
4. 심볼릭 링크 생성: `~/.claude/CLAUDE.md` → `claude/global_CLAUDE.md`
5. MCP 서버 및 Claude Code 설정 확인
6. 상태 파일 생성: `workstations/<alias>.json`

**결과물**:
| 파일 | 설명 |
|------|------|
| `workstations/<alias>.json` | 공개 환경 상태 (커밋됨) |
| `workstations/<alias>.local.json` | 로컬 전용: hostname, 경로 등 (gitignore) |

**수동 대체**:
```bash
ln -sf $(pwd)/claude/global_CLAUDE.md ~/.claude/CLAUDE.md
```

---

## 2. 프로젝트 초기화 — `/project-init`

**언제**: 새 프로젝트에 AI 지침을 적용할 때

**실행**:
```
/project-init ~/my-project
```
경로를 생략하면 대화형으로 선택한다.

**수행 내용**:
1. 타겟 디렉토리 검증
2. 기존 파일 충돌 확인 (신규 vs. 갱신 판단)
3. 템플릿 파일 복제:
   - `CLAUDE.md` (프로젝트 규칙 — placeholder 포함)
   - `.claude/skills/project-configure/SKILL.md`
4. 라이브러리 버전을 CLAUDE.md 헤더에 기록
5. 배포 추적 갱신 (`workstations/registry.md`)

**결과물**:
```
my-project/
├── CLAUDE.md                              ← 프로젝트 규칙 (placeholder 상태)
└── .claude/skills/project-configure/
    └── SKILL.md                           ← 구체화 스킬
```

> **참고**: init만으로는 placeholder(`{{기술_스택}}` 등)가 남아있다.
> 반드시 `/project-configure`로 구체화해야 한다.

---

## 3. 프로젝트 설정 구체화 — `/project-configure`

**언제**: `/project-init` 직후, 또는 프로젝트 설정을 재구성할 때

**실행** (타겟 프로젝트 디렉토리에서):
```
/project-configure
```

**진행 방식**: 1문 1답 대화형
```
AI: 이 프로젝트의 주요 언어와 프레임워크는?
사용자: C, FreeRTOS

AI: 모듈/디렉토리 구조를 설명해주세요.
사용자: src/app, src/drivers, src/middleware

AI: Git 브랜치 전략은?
사용자: GitFlow
...
```

**수행 내용**:
1. 현재 프로젝트 코드 자동 분석 (언어, 구조 감지)
2. 대화형으로 기술 스택, 모듈 구조, 컨벤션 수집
3. 기술 스택 확정 시 관련 blueprint를 읽고, 대화를 통해 프로젝트에 맞게 마이그레이션
4. 구성 플랜 작성 → 사용자 검토
5. 승인 후 placeholder를 실제 값으로 치환 + `docs/stack/`에 마이그레이션된 지침 생성

**blueprint 마이그레이션**: 대화 과정에서 자연스럽게 진행된다.
blueprint의 각 항목을 프로젝트 맥락에 비추어 질문하고, 답변을 반영하여 프로젝트 버전을 생성한다.
결과물은 `docs/stack/`에 저장되며, 원본 blueprint와 변경 내역을 헤더에 기록한다.

**수집 항목 예시**:
- 언어/프레임워크, 빌드 시스템
- 디렉토리 구조, 모듈 역할
- 코딩 컨벤션, 네이밍 규칙
- Git 워크플로우, CI/CD
- 테스트 전략

---

## 4. 프로젝트 업데이트 — `/project-update`

**언제**: 라이브러리에 새 버전이 릴리스된 후, 기존 프로젝트에 적용할 때

**실행**:
```
/project-update ~/my-project
```
경로를 생략하면 배포된 프로젝트 목록에서 선택한다.

**수행 내용**:
1. 프로젝트 기반 버전과 라이브러리 최신 버전 비교
2. 변경사항을 항목별로 분류
3. 각 항목에 대해 자동 병합 / 수동 검토 / 스킵 선택
4. 프로젝트의 커스텀 수정(Local) 보존
5. 버전 갱신 (앞 3자리 → 최신, Local → 0 리셋)

**시나리오**:
```
라이브러리 v0.1.0 → v0.2.0 릴리스
프로젝트 현재 버전: v0.1.0.3 (Local 수정 3회)
       ↓ /project-update
프로젝트 갱신 버전: v0.2.0.0 (커스텀 보존, Local 리셋)
```

---

## 5. 지침 흡수 — `/project-absorb`

**언제**: 프로젝트에서 개선한 지침이 다른 프로젝트에도 유용할 때

**실행**:
```
/project-absorb ~/my-project
```
경로를 생략하면 Local 버전 > 0인 프로젝트만 표시한다.

**수행 내용**:
1. 기반 버전 시점 템플릿과 현재 프로젝트 지침 비교
2. 변경사항을 항목 단위로 분류
3. 항목별로 채택/미채택 결정 (대화형)
4. 채택된 항목을 `blueprints/` 또는 템플릿에 반영

**시나리오**:
```
프로젝트에서 "ISR 내 동적 메모리 할당 금지" 규칙 추가
       ↓ /project-absorb
blueprints/coding-standards.md에 해당 규칙 반영
       ↓ 라이브러리 Minor 버전 증가
       ↓ /project-update (다른 프로젝트에 전파)
```

---

## 6. 문서 최적화 — `/optimize-docs`

**언제**: 지침 파일이 200줄을 초과했을 때, 또는 정기 점검 시

**실행**:
```
/optimize-docs
```

**수행 내용**:
1. 대상 파일 줄 수 스캔 (SKILL.md, blueprints/, CLAUDE.md 등)
2. 200줄 초과 파일 강조 표시
3. 최적화 방안 제시 (중복 제거, 표현 압축, 섹션 분리)
4. 사용자 확인 후 편집 실행

> 의미 보존이 우선 — 줄 수를 맞추기 위해 핵심 내용을 삭제하지 않는다.

---

## FAQ

### Q: Claude Code 외 다른 도구(Cursor, Copilot 등)에서도 사용할 수 있나?

현재 스킬은 Claude Code 전용이다. 다른 도구의 지침 파일은 `blueprints/`를 기반으로 수동 변환하여 사용한다.
각 도구의 배포 방법은 [`TOOL_REFERENCE.md`](../TOOL_REFERENCE.md)를 참조한다.

### Q: 기존 프로젝트에 이미 CLAUDE.md가 있으면?

`/project-init`이 기존 파일을 감지하여 신규 추가/갱신을 판단한다.
기존 커스텀 내용은 보존된다.

### Q: 여러 워크스테이션에서 동시에 사용할 수 있나?

가능하다. 각 워크스테이션에서 클론 후 `/ai-platform-defconfig`를 실행하면 된다.
워크스테이션별 상태는 `workstations/<alias>.json`으로 독립 관리된다.

### Q: blueprints를 직접 수정해도 되나?

가능하지만, blueprints 변경은 모든 도구의 지침에 영향을 줄 수 있다.
프로젝트 고유 규칙은 프로젝트 `CLAUDE.md`에서 오버라이드하는 것을 권장한다.

### Q: 버전이 뒤처진 프로젝트를 한꺼번에 업데이트할 수 있나?

현재는 프로젝트별로 `/project-update`를 개별 실행한다.
`workstations/registry.md`에서 전체 버전 현황을 확인할 수 있다.
