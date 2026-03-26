# 환경 감지 및 적응

> 도구 무관 공유 지식 — 모든 AI 코딩 어시스턴트에 적용
> `/ai-platform-defconfig` 스킬은 이 문서의 환경 판별 기준을 사용하여 워크스테이션을 구성한다.

---

## 1. 환경 판별

작업 시작 시 현재 환경을 자동으로 파악하고, 아래 기준에 맞게 동작을 조정한다.

```
환경 판별 우선순위:
1. uname 출력이 MINGW64_NT* 또는 MSYS_NT* → Windows 네이티브 (Git Bash)
2. $WSL_DISTRO_NAME 존재 → WSL2 환경
3. $SSH_CLIENT 또는 $SSH_TTY 존재 → 원격 SSH 환경
4. 그 외 → 로컬 Linux/macOS Native
```

**Git Bash 미감지 시** (Windows에서 `uname` 실패 또는 PowerShell/cmd 환경):
> ⚠ Git Bash가 감지되지 않았습니다.
> Git for Windows를 설치해 주세요: https://git-scm.com/download/win
> 설치 후 Claude Code를 재시작하면 Git Bash가 기본 셸로 설정됩니다.

---

## 2. WSL2 환경 주의사항

- Windows 경로(`C:\...`)와 Linux 경로(`/mnt/c/...`) 혼용 금지 — 항상 Linux 경로 사용
- `git worktree` 경로는 반드시 WSL2 파일시스템 내부(`~/` 또는 `/home/...`)에 위치
- Windows 실행파일(`.exe`) 호출이 필요한 경우 명시적으로 경고 후 진행

---

## 3. Windows 네이티브 환경 주의사항

- Claude Code Desktop은 Git for Windows의 **Git Bash**를 셸로 사용 — bash 명령어 대부분 동작
- 심볼릭 링크: Windows Developer Mode 활성화 필요, 불가 시 **파일 복사로 fallback**
  - 복사 fallback 시 원본 변경이 자동 반영되지 않음 — 수동 동기화 필요
- `dos2unix` 불필요 (네이티브 Windows는 CRLF가 기본이나, Git이 `core.autocrlf`로 관리)
- `jq` 미설치 시: Scoop(`scoop install jq`) 또는 Chocolatey(`choco install jq`) 안내
- 경로: Git Bash가 `/c/Users/...` ↔ `C:\Users\...` 자동 변환

---

## 4. SSH 원격 환경 주의사항

- 툴체인 경로는 절대경로 사용 (환경변수 의존 최소화)
- 세션 종료 시 소실될 수 있는 작업은 반드시 커밋 또는 stash 후 진행
- `screen` / `tmux` 세션 여부 확인 권장
