---
name: project-init
description: 타겟 디렉토리에 AI 도구 설정 골격(CLAUDE.md, .claude/ 등)을 복제하여 초기 구성을 준비
argument-hint: "[target-directory-path]"
allowed-tools: Read, Bash, Glob, Grep, Write, Edit
---

# Project Init

타겟 디렉토리에 AI 도구 설정의 초기 골격을 복제한다.

## 인자

- `$0` — 타겟 디렉토리 경로 (미지정 시 사용자에게 물어본다)

### 경로 해석 규칙
- 사용자가 입력한 경로는 **홈 디렉토리(`~`)를 기준**으로 해석한다
- 예: `my_project` → `~/my_project`, `test/foo` → `~/test/foo`
- 절대 경로(`/`로 시작)가 입력된 경우에만 그대로 사용

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
   - 있으면 → 덮어쓸지 병합할지 사용자에게 확인
   - 없으면 → 진행
4. **파일 복제** — 복제 대상을 타겟으로 복사
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
- 복제 후 타겟 디렉토리의 git에 자동 커밋하지 않음 — 사용자가 검토 후 커밋
- 복제된 파일은 placeholder 상태 — `/project-configure`로 구체화 필요함을 안내
