# Claude Code 지침

## 파일 목록

| 파일/디렉토리 | 배포 위치 | 설명 |
|--------------|-----------|------|
| `global_CLAUDE.md` | `~/.claude/CLAUDE.md` | 글로벌 규칙 인덱스 (rules 참조 테이블) |
| `project_CLAUDE.md` | `<project>/CLAUDE.md` | 프로젝트 규칙 템플릿 (`{{...}}` placeholder) |
| `../.claude/rules/global-*.md` | `~/.claude/rules/` | 글로벌 세부 규칙 (자동 로드) |
| `../.claude/rules/project-*.md` | `<project>/.claude/rules/` | 프로젝트 세부 규칙 템플릿 (선택 복제) |

## 구조

`CLAUDE.md`는 최상위 인덱스 역할, 세부 규칙은 `rules/` 파일로 분산.
Claude Code가 `rules/` 파일을 자동 로드하므로 중복 인라인 불필요.

상세 파일 목록과 배포 방법: [`../.claude/rules/README.md`](../.claude/rules/README.md)

## 배포 방법

### 스킬을 통한 배포 (권장)

**글로벌 규칙 + rules:**
```
/ai-platform-defconfig
→ 심볼릭 링크 자동 생성:
  · global_CLAUDE.md → ~/.claude/CLAUDE.md
  · .claude/rules/global-*.md → ~/.claude/rules/*.md (접두사 제거)
```

**프로젝트 규칙:**
```
/project-init <target-path>
→ project_CLAUDE.md를 타겟에 복제

/project-configure
→ placeholder 채움 + 기술 스택에 맞는 rules 선택 복제
```

### 수동 배포
```bash
# 글로벌 규칙 (심볼릭 링크)
ln -sf $(realpath global_CLAUDE.md) ~/.claude/CLAUDE.md

# 글로벌 rules (심볼릭 링크, 접두사 제거)
mkdir -p ~/.claude/rules
for f in .claude/rules/global-*.md; do
  ln -sf $(realpath "$f") ~/.claude/rules/${f#.claude/rules/global-}
done

# 프로젝트 규칙 (복사)
cp project_CLAUDE.md <project-root>/CLAUDE.md
```

## rules 파일의 paths 조건

rules 파일은 YAML frontmatter의 `paths`로 조건부 로드 가능:
- `paths` 없음: 모든 컨텍스트에서 로드
- `paths: ["**/*.c"]`: 해당 파일 작업 시에만 로드 → 컨텍스트 절약

## 우선순위

프로젝트 `CLAUDE.md` > 프로젝트 `.claude/rules/` > 글로벌 `~/.claude/rules/` > 글로벌 `CLAUDE.md`
