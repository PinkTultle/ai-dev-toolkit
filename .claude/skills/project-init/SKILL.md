---
name: project-init
description: 타겟 디렉토리에 AI 도구 설정 골격(CLAUDE.md, .claude/ 등)을 복제하여 초기 구성을 준비
argument-hint: <target-directory-path>
allowed-tools: Read, Bash, Glob, Grep, Write, Edit
---

# Project Init

타겟 디렉토리에 AI 도구 설정의 초기 골격을 복제한다.

## 인자

- `$0` — 타겟 디렉토리 경로 (필수)

타겟 경로가 제공되지 않으면 사용자에게 물어본다.

## 이 저장소 경로

```
REPO_DIR=${CLAUDE_SKILL_DIR}/../../..
```

## 복제 대상

이 저장소에서 타겟 디렉토리로 복제할 파일 목록:

| 소스 (이 저장소) | 타겟 | 설명 |
|-----------------|------|------|
| `claude/project_CLAUDE.md` | `<target>/CLAUDE.md` | 프로젝트 규칙 템플릿 |
| (향후 확장) | `<target>/.claude/skills/` | 프로젝트 레벨 스킬 |

## 실행 흐름

1. **경로 검증** — 타겟 디렉토리가 존재하는지, git 저장소인지 확인
2. **충돌 확인** — 타겟에 이미 `CLAUDE.md`나 `.claude/`가 있는지 확인
   - 있으면 → 덮어쓸지 병합할지 사용자에게 확인
   - 없으면 → 진행
3. **파일 복제** — 복제 대상을 타겟으로 복사
4. **결과 안내** — 복제된 파일 목록과 다음 단계(`/project-configure`) 안내

## 주의사항

- 타겟 디렉토리가 존재하지 않으면 자동으로 생성(`mkdir -p`)하고, 생성했음을 사용자에게 알린 뒤 진행
- 기존 파일을 덮어쓰기 전 반드시 확인
- 복제 후 타겟 디렉토리의 git에 자동 커밋하지 않음 — 사용자가 검토 후 커밋
- 복제된 파일은 placeholder 상태 — `/project-configure`로 구체화 필요함을 안내
