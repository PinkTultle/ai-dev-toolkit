---
name: project-init
description: 타겟 디렉토리에 AI 도구 설정 골격(CLAUDE.md, .claude/ 등)을 복제하여 초기 구성을 준비
argument-hint: "[target-directory-path]"
allowed-tools: Read, Bash, Glob, Grep, Write, Edit
---

# Project Init

타겟 디렉토리에 AI 도구 설정의 초기 골격을 복제한다.
기존 프로젝트에 AI 설정을 처음 추가하거나, 이미 설정된 프로젝트의 템플릿을 최신으로 갱신할 때 사용한다.

## 인자

- `$0` — 타겟 디렉토리 경로 (미지정 시 아래 프로젝트 탐색 후 사용자에게 물어본다)

### 경로 미지정 시 프로젝트 탐색
인자 없이 실행된 경우 프로젝트 디렉토리를 탐색하여 목록을 제시한다:
1. `~/` 하위 1~2단계 폴더를 탐색 (git 여부 무관, `~/side_project/` 등 프로젝트 디렉토리 우선)
2. 이 저장소(`My_AI_manual`) 자신은 제외
3. 발견된 프로젝트를 번호 목록으로 제시
4. 사용자가 번호를 선택하거나 직접 경로를 입력

### 경로 해석 규칙
- 사용자가 입력한 경로는 **홈 디렉토리(`~`)를 기준**으로 해석한다
- 예: `my_project` → `~/my_project`, `test/foo` → `~/test/foo`
- 절대 경로(`/`로 시작)가 입력된 경우에만 그대로 사용
- 입력된 경로가 존재하지 않으면 `~/` 하위에서 유사한 이름의 디렉토리를 탐색하여 제안 (`~/side_project/` 포함)
  - 예: `my_app` 입력 → `~/side_project/my-app/` 발견 시 "혹시 이 경로인가요?" 확인

## 이 저장소 경로

```
REPO_DIR=${CLAUDE_SKILL_DIR}/../../..
```

## 복제 대상

이 저장소에서 타겟 디렉토리로 복제할 파일 목록:

| 소스 (이 저장소) | 타겟 | 설명 |
|-----------------|------|------|
| `claude/project_CLAUDE.md` | `<target>/CLAUDE.md` | 프로젝트 규칙 템플릿 |
| `.claude/skills/project-configure/SKILL.md` | `<target>/.claude/skills/project-configure/SKILL.md` | 프로젝트 구성 스킬 |

## 실행 흐름

1. **경로 검증** — 타겟 디렉토리가 존재하는지, git 저장소인지 확인
2. **경로 확인** — 해석된 절대 경로를 사용자에게 보여주고 맞는지 확인받은 후 진행
3. **충돌 확인** — 타겟에 이미 `CLAUDE.md`나 `.claude/`가 있는지 확인
   - **없으면** → 신규 추가 (Case 1). 그대로 진행
   - **있으면** → 갱신 (Case 2). 아래 절차를 따른다:
     a. 기존 `CLAUDE.md`를 읽어 현재 템플릿과 비교
     b. 사용자가 추가/수정한 커스텀 섹션을 식별
     c. 선택지 제시:
        - **템플릿만 갱신** — 템플릿 골격을 최신으로 교체하되, 커스텀 섹션은 보존 (추천)
        - **덮어쓰기** — 기존 파일을 백업(`CLAUDE.md.bak`) 후 새 템플릿으로 교체
        - **스킵** — 해당 파일 건너뛰기
     d. `project-configure` 스킬 파일도 동일하게 비교/갱신
4. **파일 복제/갱신** — Case 1이면 복사, Case 2이면 선택한 방식으로 적용
5. **REPO_DIR 치환** — 복제된 `project-configure/SKILL.md` 내 `REPO_DIR`을 이 저장소의 절대 경로로 치환
   ```
   # 치환 전 (원본)
   REPO_DIR=${CLAUDE_SKILL_DIR}/../../..

   # 치환 후 (복제본)
   REPO_DIR=/absolute/path/to/my_ai_manual
   ```
6. **결과 안내** — 복제된 파일 목록과 다음 단계(`/project-configure`) 안내

## 주의사항

- 타겟 디렉토리가 존재하지 않으면 자동으로 생성(`mkdir -p`)하고, 생성했음을 사용자에게 알린 뒤 진행
- 기존 파일을 덮어쓰기 전 반드시 확인
- 갱신(Case 2) 시 덮어쓰기를 선택하면 기존 파일을 `.bak`으로 백업한다
- 갱신 시 사용자가 `/project-configure`로 채운 커스텀 내용이 유실되지 않도록 주의
- 복제 후 타겟 디렉토리의 git에 자동 커밋하지 않음 — 사용자가 검토 후 커밋
- 신규 추가(Case 1)된 파일은 placeholder 상태 — `/project-configure`로 구체화 필요함을 안내
