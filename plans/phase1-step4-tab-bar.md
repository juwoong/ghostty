# Phase 1 Step 4

## 목표

가운데 패널 상단에 세션 탭 바를 추가한다. 이 탭 바는 macOS 네이티브 윈도우 탭과는 별개인 앱 내부 세션 표시 레이어다.

## 관련 파일

- [macos/Sources/App/Models/AppState.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/Models/AppState.swift)
- [macos/Sources/App/Views/Terminal](/Users/juwoong/gudos/ghostty/macos/Sources/App/Views/Terminal)
- [macos/Sources/Features/Terminal/TerminalView.swift](/Users/juwoong/gudos/ghostty/macos/Sources/Features/Terminal/TerminalView.swift)

## 작업 항목

1. `macos/Sources/App/Views/Terminal/TabBarView.swift`를 만든다.
2. 현재 활성 프로젝트의 세션 목록만 탭으로 노출한다.
3. 활성 세션 탭은 배경, 보더, 텍스트 중 최소 한 가지 이상으로 명확히 표시한다.
4. 우측 끝에 `+` 버튼 placeholder를 둔다.
5. 바 전체는 어두운 톤을 유지한다. 기준은 `#1f1f1f`에 가까운 색감으로 잡고 과한 대비를 피한다.
6. 높이 고정 책임은 Step 6 조립부에서 `.frame(height: 32)`로 건다.
7. 네이티브 `NSTabGroup` 동작과 충돌하지 않도록 AppKit window tab API는 건드리지 않는다.

## 완료 산출물

- `TabBarView.swift`

## 에이전트 검증 체크리스트

- [ ] `test -f macos/Sources/App/Views/Terminal/TabBarView.swift`
통과 기준: 파일이 존재한다.

- [ ] `rg -n "struct TabBarView|ForEach\\(|activeProject|sessions" macos/Sources/App/Views/Terminal/TabBarView.swift`
통과 기준: 활성 프로젝트 기반 탭 목록 로직이 들어 있다.

- [ ] `rg -n "activeSessionId|isActive|selected|Button" macos/Sources/App/Views/Terminal/TabBarView.swift`
통과 기준: 활성 탭 하이라이트와 탭 선택 경로가 있다.

- [ ] `rg -n "\"\\+\"|plus|new session" macos/Sources/App/Views/Terminal/TabBarView.swift`
통과 기준: 새 세션 placeholder 버튼이 있다.

- [ ] `rg -n "Color|background|1f1f1f" macos/Sources/App/Views/Terminal/TabBarView.swift`
통과 기준: 바 배경 톤에 대한 구현 또는 상수 정의가 있다.

- [ ] `xcodebuild -project macos/Ghostty.xcodeproj -scheme Ghostty -configuration Debug -derivedDataPath /tmp/ghostty-derived build`
통과 기준: 탭 바 추가만으로 빌드가 유지된다.

## 리스크 메모

- 윈도우 탭과 앱 내부 세션 탭을 혼동해서 AppKit 탭 API를 건드리면 기존 Ghostty tab/window 동작에 회귀가 날 수 있다.
- Step 4에서 실제 새 세션 생성까지 욕심내면 범위가 커진다. Phase 1은 placeholder까지만 유지한다.
