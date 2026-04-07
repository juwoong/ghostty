# Phase 1 Step 6

## 목표

기존 Ghostty 터미널 뷰를 유지한 채, 메인 윈도우를 3패널 레이아웃으로 바꾼다. 핵심은 `TerminalController`의 루트 호스팅 뷰만 교체하고 `TerminalViewContainer`, `TerminalView`, `SurfaceView` 체인은 그대로 살리는 것이다.

## 관련 파일

- [macos/Sources/Features/Terminal/TerminalController.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Terminal/TerminalController.swift)
- [macos/Sources/Features/Terminal/TerminalView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Terminal/TerminalView.swift)
- [macos/Sources/Features/Terminal/TerminalViewContainer.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Terminal/TerminalViewContainer.swift)
- [macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift)
- [macos/Sources/App/Views/Terminal/TabBarView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/Views/Terminal/TabBarView.swift)
- [macos/Sources/App/Views/RightPanel/RightPanelView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/Views/RightPanel/RightPanelView.swift)

## 구현 결정

- 루트 조립 뷰를 새로 만든다. 예시 이름은 `macos/Sources/App/Views/Main/Phase1TerminalIDEView.swift`다.
- `TerminalController.windowDidLoad()`는 더 이상 `TerminalView`를 직접 호스팅하지 않고, 새 루트 뷰 안에 기존 `TerminalView`를 가운데 패널로 넣는다.
- `AppState` 인스턴스는 윈도우 수명주기에 맞춰 `TerminalController`가 소유한다.
- `TerminalViewContainer`는 유지한다. 이 파일을 갈아엎지 않는다.

## 작업 항목

1. `macos/Sources/App/Views/Main/Phase1TerminalIDEView.swift` 같은 루트 조립 뷰를 만든다.
2. 루트 뷰에서 `HStack(spacing: 0)`으로 3패널을 조립한다.
3. 왼쪽에 `ProjectSidebarView().frame(width: 200)`를 둔다.
4. 가운데에 `VStack(spacing: 0)`를 두고, 상단에 `TabBarView().frame(height: 32)`, 하단에 기존 `TerminalView(ghostty:viewModel:delegate:)`를 둔다.
5. 오른쪽에 `RightPanelView().frame(width: 180)`를 둔다.
6. 패널 사이에는 `Divider()`를 둔다.
7. `TerminalController`에 `AppState` 보관 프로퍼티를 추가하고 루트 뷰로 전달한다.
8. `windowDidLoad()`에서 `TerminalViewContainer`의 rootView를 새 루트 뷰로 바꾼다.
9. `container.initialContentSize`를 그대로 두지 말고 보정한다. 최소한 `focusedSurface?.initialSize`에 좌우 패널 폭과 divider, 탭 바 높이를 반영해야 초기 창이 너무 작아지는 회귀를 줄일 수 있다.
10. `window.contentView = container` 구조는 유지한다.
11. 터미널 입력, PTY, 렌더링 경로를 건드리지 않도록 `TerminalView`, `TerminalSplitTreeView`, `Ghostty.SurfaceView` 자체 로직은 수정 최소화 원칙을 지킨다.

## 완료 산출물

- 루트 조립 뷰 1개
- `TerminalController` 변경 1개
- 3패널 레이아웃 적용

## 에이전트 검증 체크리스트

- [ ] `test -f macos/Sources/App/Views/Main/Phase1TerminalIDEView.swift`
통과 기준: 메인 조립용 SwiftUI 파일이 존재한다.

- [ ] `rg -n "HStack\\(spacing: 0\\)|ProjectSidebarView\\(\\)\\.frame\\(width: 200\\)|RightPanelView\\(\\)\\.frame\\(width: 180\\)|TabBarView\\(\\)\\.frame\\(height: 32\\)" macos/Sources/App/Views/Main/Phase1TerminalIDEView.swift`
통과 기준: 3패널 구조와 요구 치수가 코드에 드러난다.

- [ ] `rg -n "TerminalView\\(ghostty: ghostty, viewModel: self, delegate: self\\)|Phase1TerminalIDEView" macos/Sources/Features/Terminal/TerminalController.swift macos/Sources/App/Views/Main/Phase1TerminalIDEView.swift`
통과 기준: 기존 터미널 뷰가 가운데 패널로 재사용된다.

- [ ] `rg -n "AppState" macos/Sources/Features/Terminal/TerminalController.swift macos/Sources/App/Views/Main/Phase1TerminalIDEView.swift`
통과 기준: 윈도우 컨트롤러와 루트 뷰 사이에 상태 전달 경로가 있다.

- [ ] `rg -n "initialContentSize" macos/Sources/Features/Terminal/TerminalController.swift`
통과 기준: 초기 창 크기 보정이 검토되었고, 패널 폭/탭 바 높이를 고려한 로직이 들어 있다.

- [ ] `rg -n "window\\.contentView = container|TerminalViewContainer" macos/Sources/Features/Terminal/TerminalController.swift macos/Sources/Features/Terminal/TerminalViewContainer.swift`
통과 기준: 기존 container 래핑 구조가 유지된다.

- [ ] `xcodebuild -project macos/Ghostty.xcodeproj -scheme Ghostty -configuration Debug -derivedDataPath /tmp/ghostty-derived build`
통과 기준: Debug 빌드가 성공한다.

- [ ] GUI 접근이 가능하면 빌드된 앱을 실행해 새 창을 열고 가운데 터미널에 입력한다.
통과 기준: 왼쪽 프로젝트/세션 트리, 가운데 실제 터미널, 오른쪽 placeholder 패널이 모두 보이고 입력/출력이 정상 작동한다.

## 최종 완료 기준

- 앱이 3패널 레이아웃으로 뜬다.
- 왼쪽에 프로젝트/세션 트리가 보인다.
- 가운데 기존 Ghostty 터미널이 정상 작동한다.
- 오른쪽에 placeholder 패널이 보인다.
- `xcodebuild -project macos/Ghostty.xcodeproj -scheme Ghostty -configuration Debug -derivedDataPath /tmp/ghostty-derived build`가 통과한다.

## 리스크 메모

- 가장 큰 회귀 포인트는 `TerminalController.windowDidLoad()`와 `initialContentSize`다.
- 루트 뷰 교체 과정에서 `TerminalViewContainer`를 제거하거나 단순 `NSHostingView`로 바꾸면 창 스타일과 glass 관련 동작이 깨질 수 있다.
- 가운데 `TerminalView` 대신 다른 래퍼를 억지로 끼우면 포커스, split, surface 동작에 회귀가 날 가능성이 높다.
