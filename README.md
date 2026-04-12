# adt — AI Development Toolkit

AI 코딩 어시스턴트의 **지침 라이브러리이자 Claude Code 플러그인**.

> **버전**: [`VERSION`](VERSION) | **변경 이력**: [`CHANGELOG.md`](CHANGELOG.md)

---

## 설치

```bash
claude plugin install PinkTultle/ai-dev-toolkit
```

Claude Code >= 2.1.78 필요.

---

## 무엇을 제공하는가?

| 구분 | 수량 | 역할 |
|------|------|------|
| **스킬** | 11개 | 워크스테이션 세팅, 프로젝트 초기화, 코드 리뷰, 문서 자동화 |
| **에이전트** | 12개 | 개발 파이프라인 (아이디어 → 설계 → 검토 → 구현 → 검증 → 테스트) |
| **템플릿** | 4개 | Plan, Design, Report, ADR 문서 |
| **Blueprints** | 6개 | 코딩 표준, Git 워크플로우, 설계 원칙 등 공유 지식 |

---

## 빠른 시작

### 1. 워크스테이션 환경 구성 (최초 1회)

```
/adt:ai-platform-defconfig
```

글로벌 규칙, deny 설정, MCP 등을 자동 구성한다.

### 2. 프로젝트에 적용

```
/adt:project-init ~/my-project
/adt:project-configure
```

### 3. 개발 중 활용

```
/adt:review                   # 코드 리뷰
/adt:doc-gen src/main.c       # 코드 설명 문서 생성
/adt:decision "API 인증 방식"  # ADR 생성
/adt:handoff                  # 세션 종료 시 인수인계
```

---

## 스킬

| 스킬 | 역할 | 실행 시점 |
|------|------|----------|
| `adt:ai-platform-defconfig` | 워크스테이션 환경 구성 (심볼릭 링크, 패키지, MCP) | 최초 1회 |
| `adt:project-init` | 타겟 디렉토리에 AI 설정 골격 복제 + 배포 추적 | 프로젝트 시작 시 |
| `adt:project-configure` | 대화형으로 기술 스택, 모듈 구조, 컨벤션 구체화 | init 직후 |
| `adt:project-update` | 라이브러리 최신 버전을 프로젝트에 적용 (커스텀 보존) | 플러그인 업데이트 후 |
| `adt:project-absorb` | 프로젝트에서 발전한 지침을 라이브러리로 흡수 | 프로젝트 지침 개선 후 |
| `adt:optimize-docs` | 지침 파일 줄 수 검사 및 200줄 이내 최적화 | 정기 유지보수 |
| `adt:handoff` | 세션 종료 시 HANDOFF.md 갱신 + 커밋 + 푸시 | 세션 종료 |
| `adt:sync-check` | blueprints ↔ rules 동기화 상태 점검 | 점검 필요 시 |
| `adt:doc-gen` | 소스 파일의 코드 설명 문서 자동 생성/갱신 | 코드 변경 후 |
| `adt:review` | 변경사항 코드 리뷰 (보안/성능/가독성) | 커밋 전 |
| `adt:decision` | ADR 생성/조회 (아키텍처 결정 기록) | 주요 결정 시 |

## 에이전트 파이프라인

Large 프리셋에서 서브에이전트 파이프라인으로 개발 단계를 자동화한다:

```
Ideation → Product Manager → Designer → Reviewer → Implementer → Verifier → Tester
   (sonnet)    (opus)          (opus)     (opus)      (opus)       (sonnet)   (sonnet)
```

보조 에이전트: Design Validator, Gap Detector, Code Analyzer, Report Generator, CTO Lead

---

## 워크플로우

```
┌─────────────────────────────────────────────────────┐
│                    최초 1회                           │
│  플러그인 설치 → /adt:ai-platform-defconfig           │
└────────────────────────┬────────────────────────────┘
                         v
┌─────────────────────────────────────────────────────┐
│                 프로젝트마다                          │
│  /adt:project-init → /adt:project-configure          │
└────────────────────────┬────────────────────────────┘
                         v
┌─────────────────────────────────────────────────────┐
│                   유지보수                            │
│  /adt:project-absorb ← 프로젝트에서 발전한 지침 흡수   │
│  /adt:project-update → 라이브러리 최신 버전 전파       │
│  /adt:optimize-docs  → 지침 파일 200줄 제한 유지       │
└─────────────────────────────────────────────────────┘
```

---

## 디렉토리 구조

```
ai-dev-toolkit/
├── .claude-plugin/        # 플러그인 매니페스트
├── skills/ (11)           # 스킬
├── agents/ (12)           # 에이전트 파이프라인
├── templates/ (4)         # 문서 템플릿
├── hooks/                 # 라이프사이클 훅
├── blueprints/            # 도구 무관 공유 지식 (Single Source of Truth)
├── claude/                # 배포용 템플릿 (CLAUDE.md, rules)
├── workstations/          # 워크스테이션 환경 추적
└── docs/                  # 사용 가이드
```

상세 구조: [`docs/project-structure.md`](docs/project-structure.md)

---

## 다른 플러그인과의 호환

`adt:` 네임스페이스로 격리되어 다른 플러그인(rkit 등)과 충돌 없이 독립 동작한다.

---

## 환경

| 항목 | 요구사항 |
|------|----------|
| Claude Code | >= 2.1.78 |
| OS | Linux / WSL2 / macOS / Windows (Git Bash) |
| Git | 2.20 이상 |
| 패키지 | `jq` (필수), `dos2unix` (WSL2만) |

---

## 라이선스

MIT
