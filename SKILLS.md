# TerminalIDE Skill Map

이 저장소에서 완전자율주행으로 작업할 때 우선 사용하는 스킬들.

## Installed

- `swiftui-expert-skill`
- `macos-design-guidelines`
- `swift-concurrency`
- `swift-testing-expert`
- `xcode-build-orchestrator`
- `xcode-build-benchmark`
- `xcode-compilation-analyzer`
- `xcode-project-analyzer`
- `spm-build-analysis`
- `xcode-build-fixer`

설치 위치: `~/.codex/skills`

## When To Use

- `swiftui-expert-skill`
  - Phase 1 UI 레이아웃 작업
  - 3패널 구성, 탭 바, 사이드바, 상태 패널
- `macos-design-guidelines`
  - macOS 네이티브 UX 결정
  - 사이드바, 툴바, 포커스, 키보드 단축키, 알림
- `swift-concurrency`
  - Phase 2 상태 감지 파이프라인
  - hooks, OSC, 포트 감시, 비동기 스트림, task orchestration
- `swift-testing-expert`
  - 상태 감지 로직, 파서, 뷰모델 테스트
  - 회귀 테스트 추가 전 항상 고려
- `xcode-project-analyzer`
  - macOS 타깃 구조 파악
  - Ghostty Swift 계층과 App 계층 연결 지점 분석
- `xcode-build-orchestrator`
  - 여러 빌드/검증 루프를 순서 있게 돌릴 때
- `xcode-build-benchmark`
  - 빌드 시간 비교, 느린 변경 추적
- `xcode-compilation-analyzer`
  - 컴파일 병목, 느린 파일, 모듈 경계 문제 분석
- `spm-build-analysis`
  - Swift Package Manager 경로가 개입될 때
- `xcode-build-fixer`
  - Xcode 빌드 실패 복구

## Suggested Phase Mapping

- Phase 1
  - `swiftui-expert-skill`
  - `macos-design-guidelines`
  - `xcode-project-analyzer`
  - `xcode-build-fixer`
- Phase 2
  - `swift-concurrency`
  - `swift-testing-expert`
  - `xcode-build-orchestrator`
- Phase 3
  - `swift-testing-expert`
  - `xcode-compilation-analyzer`
  - `xcode-build-benchmark`
- Phase 4
  - 현재 설치 세트보다 배포 전용 스킬을 추가로 찾는 편이 맞음

## Working Rule

- UI를 바꾸기 전에 `swiftui-expert-skill`과 `macos-design-guidelines` 적용 여부를 먼저 확인한다.
- 비동기 상태 추적을 건드릴 때는 `swift-concurrency`를 먼저 본다.
- 빌드가 깨지면 임의 수정 전에 `xcode-build-fixer`와 `xcode-project-analyzer`를 먼저 쓴다.
- 완료 직전에는 `swift-testing-expert` 기준으로 검증 루프를 한 번 더 돈다.
