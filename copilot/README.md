# GitHub Copilot 지침

> 아직 지침 파일이 작성되지 않은 placeholder 디렉토리입니다.

## 설정 형식

- **저장소 전체**: `<project>/.github/copilot-instructions.md`
- **경로별 지침**: `<project>/.github/instructions/*.instructions.md`

## 경로별 지침 파일 형식 예시

```markdown
---
applyTo: "src/drivers/**"
---

# 드라이버 레이어 규칙

규칙 내용...
```

## 배포 위치

| 소스 | 배포 위치 |
|------|-----------|
| `copilot-instructions.md` | `<project>/.github/copilot-instructions.md` |
| `instructions/*.instructions.md` | `<project>/.github/instructions/` |

## TODO

- [ ] 저장소 전체 지침 작성
- [ ] 드라이버/HAL/APP 레이어별 지침 작성
