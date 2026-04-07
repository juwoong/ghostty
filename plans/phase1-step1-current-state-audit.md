# Phase 1 Step 1

## 목표

현재 Ghostty macOS 앱의 진입점과 터미널 렌더링 체인을 정확히 파악하고, 레이아웃 교체 시 건드려야 할 최소 지점을 확정한다.

## 입력 문서

- [PLAN.md](/Users/juwoong/gudos/ghostty/PLAN.md)
- [task-phase1.md](/Users/juwoong/gudos/ghostty/task-phase1.md)

## 실제로 확인해야 할 파일

- [macos/Sources/App/macOS/main.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/macOS/main.swift)
- [macos/Sources/App/macOS/AppDelegate.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/macOS/AppDelegate.swift)
- [macos/Sources/Features/Terminal/TerminalController.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Terminal/TerminalController.swift)
- [macos/Sources/Features/Terminal/TerminalView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Terminal/TerminalView.swift)
- [macos/Sources/Features/Terminal/TerminalViewContainer.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Terminal/TerminalViewContainer.swift)
- [macos/Sources/Features/Splits/TerminalSplitTreeView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Splits/TerminalSplitTreeView.swift)
- [macos/Sources/Ghostty/Surface View/SurfaceView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Ghostty/Surface%20View/SurfaceView.swift)
- [macos/Ghostty.xcodeproj/project.pbxproj](/Users/juwoong/gudos/ghostty/macos/Ghostty.xcodeproj/project.pbxproj)

## 작업 항목

1. `macos/Sources/` 트리를 훑고 SwiftUI/AppKit 경계가 어디인지 정리한다.
2. 앱 시작 경로를 `main.swift -> AppDelegate -> TerminalController.newWindow() -> TerminalController.windowDidLoad()` 순서로 요약한다.
3. 현재 터미널 표시 체인을 `TerminalViewContainer -> TerminalView -> TerminalSplitTreeView -> Ghostty.InspectableSurface/SurfaceView`로 정리한다.
4. 레이아웃 교체의 1차 수정 지점을 `TerminalController.windowDidLoad()`로 확정한다.
5. `TerminalViewContainer` 자체는 유지 대상으로 표시한다. 이 컨테이너는 glass effect, `intrinsicContentSize`, window content wrapping을 담당한다.
6. `macos/Ghostty.xcodeproj`가 `Sources`를 파일시스템 동기화 그룹으로 관리하는지 확인해 새 파일 추가 방식까지 메모한다.
7. 결과를 짧은 아키텍처 메모로 남긴다. 이후 스텝은 이 메모를 기준으로만 구현한다.

## 완료 산출물

- 진입점 요약 1개
- 터미널 뷰 체인 요약 1개
- 수정 대상 파일 리스트 1개
- 건드리면 안 되는 영역 리스트 1개

## 에이전트 검증 체크리스트

- [ ] `find macos/Sources -maxdepth 3 -type f -name '*.swift' | sort | sed -n '1,120p'`
통과 기준: `App/macOS`, `Features/Terminal`, `Ghostty/Surface View` 경로가 모두 보인다.

- [ ] `test -f macos/Ghostty.xcodeproj/project.pbxproj`
통과 기준: Xcode 프로젝트 파일이 존재한다.

- [ ] `sed -n '1,220p' macos/Sources/App/macOS/main.swift`
통과 기준: `NSApplicationMain` 호출과 `ghostty_init` 초기화 흐름을 확인한다.

- [ ] `rg -n "TerminalController\\.newWindow|showWindow\\(|windowDidLoad" macos/Sources/App/macOS/AppDelegate.swift macos/Sources/Features/Terminal/TerminalController.swift`
통과 기준: 새 메인 윈도우가 `TerminalController`를 통해 열리는 경로를 찾는다.

- [ ] `rg -n "TerminalViewContainer \\{|window\\.contentView = container|TerminalView\\(" macos/Sources/Features/Terminal/TerminalController.swift macos/Sources/Features/Terminal/TerminalViewContainer.swift`
통과 기준: SwiftUI 루트가 `TerminalViewContainer`에 담겨 `window.contentView`로 들어가는 것을 확인한다.

- [ ] `rg -n "TerminalSplitTreeView|InspectableSurface|SurfaceWrapper|makeOSView" macos/Sources/Features/Splits/TerminalSplitTreeView.swift 'macos/Sources/Ghostty/Surface View/SurfaceView.swift'`
통과 기준: 실제 터미널 surface가 SwiftUI 트리 안에서 어떻게 보이는지 추적 가능하다.

- [ ] `rg -n "PBXFileSystemSynchronizedRootGroup|path = Sources;" macos/Ghostty.xcodeproj/project.pbxproj`
통과 기준: `Sources`가 파일시스템 동기화 그룹으로 잡혀 있음을 확인한다.

## 리스크 메모

- Step 1 결과가 흐리면 Step 6에서 터미널 기능 회귀가 날 가능성이 높다.
- `TerminalViewContainer`와 `initialContentSize`의 역할을 빼먹으면 창 크기와 glass 효과가 무너질 수 있다.
