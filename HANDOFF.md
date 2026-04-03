# 인수인계 기록

> 이 파일은 세션/워크스테이션 간 작업 연속성을 위한 인수인계 문서입니다.
> 새 세션에서 이 저장소 작업을 시작할 때 **이 파일을 먼저 읽으세요.**
> 작업 완료 시 이 파일을 갱신하고 커밋합니다.

---

## 마지막 작업 요약

**날짜**: 2026-04-03
**작업 내용**: `.claude/rules/` 디렉토리 도입 — blueprints 기반 세부 규칙 파일 분리
**버전**: v0.2.0 (버전 갱신 미실행 — 다음 릴리즈 시 v0.3.0 예정)
**브랜치**: `main` (PR #3 squash merge 완료, `feat/claude-rules` 삭제됨)

### 이번 세션 완료 작업

#### .claude/rules/ 도입 (PR #3)
- [x] `.claude/rules/` 디렉토리 신설 — 7개 rule 파일 + README
  - 글로벌 rules 4개: environment, communication, workflow, code-review
  - 프로젝트 rules 템플릿 3개: coding-standards, git-workflow, build-environment
  - `paths` frontmatter로 C/C++ 파일, 빌드 파일에서만 조건부 로드
- [x] `global_CLAUDE.md` 경량화 (143줄 → 41줄) — 인덱스 + 참조 테이블만 잔존
- [x] 스킬 3개 갱신
  - `ai-platform-defconfig` — rules 심볼릭 링크 배포 추가
  - `project-configure` — rules 배포 섹션 + 역할 분리 추가
  - `project-update` — rules 변경 감지 추가
- [x] `.gitignore` 개선 — `.claude/*` 전체 무시 → 로컬 전용만 명시적 제외
- [x] 문서 7개 갱신 (TOOL_REFERENCE, README, usage-guide 등)

#### 환경 설정
- [x] `gh auth login` — GitHub CLI 인증 (WSL2 브라우저 인증)
- [x] `~/.bashrc`에 `GH_TOKEN` 환경변수 추가 (keyring 불안정 대비)

### 현재 상태

- **버전**: v0.2.0 (다음 릴리즈 시 v0.3.0 — rules 도입은 Minor 변경)
- **브랜치**: `main`만 존재
- **스킬**: 6개 (변경 없음, 내용만 갱신)
- **워크스테이션**: 3개 (변경 없음)
- **배포 프로젝트**: 3개 (변경 없음)
  - NDT-BPE_pork (pink-turtle, v0.1.0)
  - aralm_program (pink-turtle, v0.1.0)
  - gitlab-slack-webhook (pink-turtle-rt, v0.2.0)
- **Ruleset**: `pull_request` + `required_linear_history` + `non_fast_forward` (3개)

### 주의사항

- `~/.claude/rules/`에 심볼릭 링크가 아직 생성되지 않음 — `/ai-platform-defconfig` 재실행 필요
- `GH_TOKEN`의 `gho_` 토큰은 OAuth 디바이스 플로우 토큰으로 만료될 수 있음
  - 만료 시 GitHub Settings > Tokens에서 PAT(`ghp_`) 발급 후 `~/.bashrc` 교체

### 다음 작업 후보

1. **defconfig 재실행** — `~/.claude/rules/` 심볼릭 링크 생성 (rules 실배포)
2. **버전 릴리즈** — v0.3.0 (rules 도입, CHANGELOG 갱신, git tag)
3. **기존 프로젝트 업데이트** — NDT-BPE_pork, aralm_program에 v0.3.0 적용 (`/project-update`)
4. **두 프로젝트에서 `/project-configure` 실행** — rules 복제 + placeholder 구체화
5. **gitlab-slack-webhook 개발** — dev 브랜치에서 기능 개발/테스트
6. **실사용 피드백 수집** — rules 구조가 실제 작업에서 잘 동작하는지 검증
7. **다른 도구 지침 작성** — `cursor/`, `copilot/`, `windsurf/` (보류 중)

### 현재 저장소 구조

```
ai-dev-toolkit/
├── .claude/
│   ├── rules/                          ← 신규: 세부 규칙 파일
│   │   ├── global-environment.md       #   환경 감지 (항상 로드)
│   │   ├── global-communication.md     #   응답 언어 (항상 로드)
│   │   ├── global-workflow.md          #   워크플로우 (항상 로드)
│   │   ├── global-code-review.md       #   코드 리뷰 (C/C++ 파일만)
│   │   ├── project-coding-standards.md #   C/C++ 표준 템플릿
│   │   ├── project-git-workflow.md     #   Git 규칙 템플릿
│   │   ├── project-build-environment.md#   빌드 환경 템플릿
│   │   └── README.md
│   └── skills/ (6개, 내용 갱신됨)
├── blueprints/
├── claude/
│   ├── global_CLAUDE.md                ← 경량화: 인덱스만 (41줄)
│   ├── project_CLAUDE.md
│   └── README.md
├── docs/
├── workstations/
├── .gitattributes
├── .gitignore                          ← 개선: 로컬 전용만 제외
├── VERSION                             ← 0.2.0
├── CHANGELOG.md
├── CLAUDE.md
├── HANDOFF.md
├── README.md
└── TOOL_REFERENCE.md
```

---

## 워크스테이션 환경 메모

> 상세 환경 정보는 `workstations/<alias>.json` 참조.

| 별칭 | 환경 | 상태 파일 | defconfig 최종 실행일 |
|------|------|----------|---------------------|
| pink-turtle | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle.json` | 2026-04-03 |
| pink-turtle-rt | WSL2 (Ubuntu-20.04) | `workstations/pink-turtle-rt.json` | 2026-03-24 |
| pink-turtle-win | MINGW64 (Git Bash, Win11) | `workstations/pink-turtle-win.json` | 2026-03-26 |
