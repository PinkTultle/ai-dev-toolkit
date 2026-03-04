# Cursor 지침

> 아직 지침 파일이 작성되지 않은 placeholder 디렉토리입니다.

## 설정 형식

- **권장**: `<project>/.cursor/rules/*.mdc` (다중 파일, 주제별 분리)
- **레거시**: `<project>/.cursorrules` (단일 파일)

## MDC 파일 형식 예시

```markdown
---
description: 이 규칙의 설명
globs: ["src/**/*.c", "include/**/*.h"]
alwaysApply: false
---

# 규칙 제목

규칙 내용...
```

## 배포 위치

| 소스 | 배포 위치 |
|------|-----------|
| `*.mdc` | `<project>/.cursor/rules/` |

## TODO

- [ ] 임베디드 C/C++ 코딩 규칙 MDC 파일 작성
- [ ] Git 워크플로우 규칙 작성
