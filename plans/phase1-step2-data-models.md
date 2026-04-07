# Phase 1 Step 2

## 목표

Phase 1 UI를 지탱할 최소 상태 모델을 `macos/Sources/App/Models/` 아래에 만든다. 이 단계에서는 실제 세션 동기화까지 하지 않고, 샘플 데이터와 선택 상태만 안정적으로 제공한다.

## 입력 문서

- [PLAN.md](/Users/juwoong/gudos/ghostty/PLAN.md)
- [task-phase1.md](/Users/juwoong/gudos/ghostty/task-phase1.md)

## 관련 파일

- [macos/Sources/App](/Users/juwoong/gudos/ghostty/macos/Sources/App)
- [macos/Ghostty.xcodeproj/project.pbxproj](/Users/juwoong/gudos/ghostty/macos/Ghostty.xcodeproj/project.pbxproj)

## 구현 결정

- `PLAN.md`의 파일 구조 가이드를 따라 `Project.swift`와 `Session.swift`를 분리한다.
- 상태 모델은 Phase 1 범위에 맞게 로컬 샘플 데이터로 시작한다.
- `AppState`는 세션 선택과 현재 프로젝트 계산 정도까지만 가진다.
- `AgentState`는 Phase 2 연결 전까지 placeholder 상태 열거형으로 둔다.

## 작업 항목

1. `macos/Sources/App/Models/` 디렉토리를 만든다.
2. `Session.swift`에 `AgentState`, `Session`을 정의한다.
3. `Project.swift`에 `Project`를 정의한다.
4. `AppState.swift`에 `AppState`, `activeSessionId`, `activeSession`, `activeProject`를 정의한다.
5. 샘플 데이터는 최소 2개 프로젝트, 3개 이상 세션으로 넣어 사이드바/탭 바를 동시에 검증 가능하게 만든다.
6. 초기 활성 세션이 샘플 데이터와 일관되도록 `activeSessionId`를 설정한다.
7. 모델 계층에는 UI 레이아웃 코드, AppKit 의존성, Ghostty surface 참조를 넣지 않는다.
8. 빌드가 `@Observable`을 수용하는지 확인한다. 만약 타깃 설정과 충돌하면 그때만 `ObservableObject` 대체를 검토한다.

## 완료 산출물

- `AppState.swift`
- `Project.swift`
- `Session.swift`

## 에이전트 검증 체크리스트

- [ ] `find macos/Sources/App/Models -maxdepth 1 -type f | sort`
통과 기준: `AppState.swift`, `Project.swift`, `Session.swift` 세 파일이 보인다.

- [ ] `rg -n "enum AgentState|struct Session|struct Project|class AppState|@Observable" macos/Sources/App/Models`
통과 기준: 핵심 타입이 모두 정의되어 있다.

- [ ] `rg -n "activeSessionId|activeSession|activeProject|sampleData" macos/Sources/App/Models`
통과 기준: 선택 상태와 샘플 데이터가 모두 존재한다.

- [ ] `rg -n "directoryPath|isExpanded|isActive|agentState" macos/Sources/App/Models`
통과 기준: Step 3, Step 4에서 필요한 필드가 빠지지 않았다.

- [ ] `rg -n "PBXFileSystemSynchronizedRootGroup|path = Sources;" macos/Ghostty.xcodeproj/project.pbxproj`
통과 기준: 별도 수동 파일 등록 없이도 새 모델 파일이 타깃에 포함될 수 있는 구조임을 재확인한다.

- [ ] `xcodebuild -project macos/Ghostty.xcodeproj -scheme Ghostty -configuration Debug -derivedDataPath /tmp/ghostty-derived build`
통과 기준: 모델 추가만으로 빌드가 깨지지 않는다.

## 리스크 메모

- `task-phase1.md` 예시처럼 `Project`를 `Session.swift`에 같이 넣으면 파일 구조가 `PLAN.md`와 어긋난다.
- `AppState`가 너무 많은 책임을 가지기 시작하면 Step 6 전에 다시 잘라야 한다.
