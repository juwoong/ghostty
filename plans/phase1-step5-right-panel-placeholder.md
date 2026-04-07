# Phase 1 Step 5

## 목표

오른쪽 180pt 패널에 `Token Usage`와 `사용중 ports` placeholder를 배치한다. Phase 1에서는 레이아웃 존재감과 섹션 분리만 확보하고, 실제 데이터 연결은 하지 않는다.

## 관련 파일

- [macos/Sources/App/Views/RightPanel](/Users/juwoong/gudos/ghostty/macos/Sources/App/Views/RightPanel)
- [PLAN.md](/Users/juwoong/gudos/ghostty/PLAN.md)

## 작업 항목

1. `macos/Sources/App/Views/RightPanel/RightPanelView.swift`를 만든다.
2. 상단 섹션 제목 `Token Usage`를 둔다.
3. 하단 섹션 제목 `사용중 ports`를 둔다.
4. 각 섹션에 placeholder 설명 문구를 1~2줄 정도 넣어 빈 화면처럼 보이지 않게 한다.
5. 시각적으로는 중앙 터미널보다 한 단계 가벼운 정보 패널처럼 보여야 한다.
6. 폭 고정은 Step 6 조립부에서 건다.

## 완료 산출물

- `RightPanelView.swift`

## 에이전트 검증 체크리스트

- [ ] `test -f macos/Sources/App/Views/RightPanel/RightPanelView.swift`
통과 기준: 파일이 존재한다.

- [ ] `rg -n "struct RightPanelView|Token Usage|사용중 ports" macos/Sources/App/Views/RightPanel/RightPanelView.swift`
통과 기준: 두 섹션 제목이 모두 들어 있다.

- [ ] `rg -n "placeholder|Phase 2|coming soon|TODO" macos/Sources/App/Views/RightPanel/RightPanelView.swift`
통과 기준: 비어 있는 패널이 아니라 placeholder 의도가 드러난다.

- [ ] `xcodebuild -project macos/Ghostty.xcodeproj -scheme Ghostty -configuration Debug -derivedDataPath /tmp/ghostty-derived build`
통과 기준: 오른쪽 패널 파일 추가만으로 빌드가 유지된다.

## 리스크 메모

- 여기서 실데이터 연결을 시작하면 Phase 2 범위가 섞인다.
- 섹션 구분이 약하면 전체 UI가 한 덩어리처럼 보여 3패널 목적이 흐려진다.
