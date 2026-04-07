# Phase 1 Plan Set

이 폴더는 `PLAN.md`와 `task-phase1.md`를 실행 가능한 작업 단위로 쪼갠 문서 모음이다.

생성된 문서:
- `phase1-step1-current-state-audit.md`
- `phase1-step2-data-models.md`
- `phase1-step3-project-sidebar.md`
- `phase1-step4-tab-bar.md`
- `phase1-step5-right-panel-placeholder.md`
- `phase1-step6-main-layout-integration.md`

공통 원칙:
- Zig 코어 `src/`는 수정하지 않는다.
- 기존 터미널 루트는 `TerminalController.windowDidLoad()`에서 `TerminalViewContainer { TerminalView(...) }`로 장착된다.
- Phase 1의 핵심은 "3패널 셸 추가"이지 "기존 터미널 교체"가 아니다.
- `TerminalView(...)`, `TerminalSplitTreeView`, `Ghostty.SurfaceView` 경로는 유지되어야 한다.

공통 검증 원칙:
- 정적 검증은 `rg`, `find`, `sed`로 끝낼 수 있어야 한다.
- 빌드 검증은 아래 명령을 기본으로 사용한다.

```bash
xcodebuild -project macos/Ghostty.xcodeproj \
  -scheme Ghostty \
  -configuration Debug \
  -derivedDataPath /tmp/ghostty-derived \
  build
```

메모:
- 이 환경에서는 기본 DerivedData 경로가 권한 문제를 일으킬 수 있으므로 `/tmp/ghostty-derived`를 사용한다.
- 런타임 검증은 macOS에서 직접 앱을 띄워 터미널 입력, 출력, 포커스, split 동작이 유지되는지 확인하는 것을 뜻한다.
