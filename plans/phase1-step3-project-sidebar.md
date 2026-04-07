# Phase 1 Step 3

## 목표

왼쪽 200pt 사이드바에 프로젝트 트리와 세션 리스트를 표시하는 SwiftUI 뷰를 만든다. 이 단계는 상태 표시와 선택 경험을 만드는 것이 핵심이며, 실제 터미널 세션 생성은 아직 연결하지 않는다.

## 관련 파일

- [macos/Sources/App/Models/AppState.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/Models/AppState.swift)
- [macos/Sources/App/Models/Project.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/Models/Project.swift)
- [macos/Sources/App/Models/Session.swift](/Users/juwoong/gudos/ghostty/macos/Sources/App/Models/Session.swift)
- [macos/Sources/App/Views/Sidebar](/Users/juwoong/gudos/ghostty/macos/Sources/App/Views/Sidebar)

## 작업 항목

1. `macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift`를 만든다.
2. 상단에 `Projects` 섹션 타이틀을 둔다.
3. `projects`를 순회하며 프로젝트 행과 펼침/접힘 토글을 구현한다.
4. 펼쳐진 프로젝트 아래에 세션 행을 렌더링한다.
5. 활성 세션은 배경 또는 텍스트 스타일로 명확히 하이라이트한다.
6. 세션 앞에 상태 dot를 둔다.
7. 상태 색상은 최소 `idle=gray`, `thinking=blue`, `waitingInput=yellow`, `error=red`를 지원한다. `toolRunning`은 별도 강조색을 추가해도 되지만 Phase 1에서는 필수는 아니다.
8. 하단에 `+` 버튼 placeholder를 둔다. 동작은 비워 두되 추후 확장 가능하게 만든다.
9. 너비 고정 책임은 조립 레이어인 Step 6에서 걸고, 사이드바 자체는 재사용 가능한 뷰로 유지한다.

## 완료 산출물

- `ProjectSidebarView.swift`

## 에이전트 검증 체크리스트

- [ ] `test -f macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift`
통과 기준: 파일이 존재한다.

- [ ] `rg -n "struct ProjectSidebarView|Projects|ForEach\\(|isExpanded|sessions" macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift`
통과 기준: 프로젝트/세션 트리 렌더링이 구현되어 있다.

- [ ] `rg -n "agentState|waitingInput|thinking|error|Color" macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift`
통과 기준: 상태 dot 매핑이 코드에 포함되어 있다.

- [ ] `rg -n "activeSessionId|isActive|onTapGesture|Button" macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift`
통과 기준: 활성 세션 선택 또는 하이라이트를 결정하는 코드가 있다.

- [ ] `rg -n "\"\\+\"|plus" macos/Sources/App/Views/Sidebar/ProjectSidebarView.swift`
통과 기준: 하단 placeholder 추가 버튼이 있다.

- [ ] `xcodebuild -project macos/Ghostty.xcodeproj -scheme Ghostty -configuration Debug -derivedDataPath /tmp/ghostty-derived build`
통과 기준: 사이드바 추가만으로 빌드가 유지된다.

## 리스크 메모

- 폭을 뷰 내부와 상위 조립부 양쪽에서 모두 고정하면 추후 레이아웃 조정 시 충돌이 난다.
- 활성 세션 스타일만 있고 선택 액션이 없으면 탭 바와 상태가 엇갈릴 수 있다.
