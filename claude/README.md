# Claude Code 지침

## 파일 목록

| 파일 | 배포 위치 | 설명 |
|------|-----------|------|
| `global_CLAUDE.md` | `~/.claude/CLAUDE.md` | 모든 프로젝트에 적용되는 글로벌 규칙 |
| `project_CLAUDE.md` | `<project-root>/CLAUDE.md` | 프로젝트별 규칙 템플릿 (`{{...}}` placeholder) |

## 배포 방법

### 스킬을 통한 배포 (권장)

**글로벌 규칙:**
```
/ai-platform-defconfig
→ 심볼릭 링크 자동 생성: global_CLAUDE.md → ~/.claude/CLAUDE.md
```

**프로젝트 규칙:**
```
/project-init <target-path>
→ project_CLAUDE.md를 타겟에 복제

/project-configure
→ placeholder를 대화형으로 채움
```

### 수동 배포
```bash
# 글로벌 규칙 (심볼릭 링크)
ln -sf $(realpath global_CLAUDE.md) ~/.claude/CLAUDE.md

# 프로젝트 규칙 (복사)
cp project_CLAUDE.md <project-root>/CLAUDE.md
```

## 우선순위

프로젝트 `CLAUDE.md`가 글로벌 `CLAUDE.md`를 상속하며, 충돌 시 프로젝트 규칙이 우선한다.
