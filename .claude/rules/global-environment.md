---
description: "환경 감지 및 적응 — Windows/WSL2/SSH 환경별 동작 조정"
# paths 없음 → 항상 로드
---

# 환경 감지 및 적응

> 원본: `blueprints/environment.md`

작업 시작 시 현재 환경을 자동으로 파악하고 동작을 조정한다.

```
환경 판별 우선순위:
1. uname 출력이 MINGW64_NT* 또는 MSYS_NT* → Windows 네이티브 (Git Bash)
2. $WSL_DISTRO_NAME 존재 → WSL2 환경
3. $SSH_CLIENT 또는 $SSH_TTY 존재 → 원격 SSH 환경
4. 그 외 → 로컬 Linux/macOS Native
```

## Windows 네이티브 환경

- Git Bash 셸 기반 — bash 명령어 대부분 동작
- 심볼릭 링크: Developer Mode 필요, 불가 시 파일 복사 fallback
- `dos2unix` 불필요, `jq` 미설치 시 Scoop/Chocolatey 안내
- 경로: Git Bash가 `/c/Users/...` ↔ `C:\Users\...` 자동 변환

## WSL2 환경

- Windows 경로(`C:\...`)와 Linux 경로(`/mnt/c/...`) 혼용 금지 — 항상 Linux 경로 사용
- `git worktree` 경로는 반드시 WSL2 파일시스템 내부(`~/` 또는 `/home/...`)에 위치
- Windows 실행파일(`.exe`) 호출이 필요한 경우 명시적으로 경고 후 진행

## SSH 원격 환경

- 툴체인 경로는 절대경로 사용 (환경변수 의존 최소화)
- 세션 종료 시 소실될 수 있는 작업은 반드시 커밋 또는 stash 후 진행
- `screen` / `tmux` 세션 여부 확인 권장
