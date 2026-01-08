# Changelog



All notable changes to this project will be documented in this file.

## [1.2.6] - 2026-01-08
### Changed
- Fixed drag gesture handling in Swift Playgrounds (macOS and iPadOS) by using high-priority gesture recognition.
- Ensured FlywheelControl is fully interactive when explored via Swift Playgrounds without Xcode.

### Notes
- No API surface changes.
- No changes to control physics, rendering, or inertia behavior.
- Existing Xcode-based apps continue to behave identically.

## [1.2.5] - 2026-01-08
### Changed
- Fixed Swift Playgrounds (macOS) demo behavior by ensuring bundled ruler artwork renders correctly
- Clarified and corrected Playground demo constraints (non-zero min/max/span) so values update as expected

### Notes
- No API surface changes beyond documentation and demo correctness
- No runtime behavior or control physics changes

## [1.2.4] - 2026-01-08
### Added
- Bundled reference ruler artwork as a SwiftPM resource
- Zero-setup exploration in Swift Playgrounds on iPad and macOS

### Changed
- Demo code now loads bundled track image via public FlywheelControlResources accessor (Playgrounds-safe)
- Documentation updated to reflect self-contained SDK exploration

### Notes
- Introduces a small public API addition (FlywheelControlResources) for SDK resource access
- No runtime behavior or control physics changes

## [1.2.2] - 2026-01-08
### Added
- Official support for exploring FlywheelControl in **Swift Playgrounds on iPad** (no Xcode required).
- Documentation and examples positioning Swift Playgrounds as a DX “front door” for SDK exploration.

### Changed
- Lowered Swift Package tools version to **5.10** to ensure compatibility with Swift Playgrounds on iPad.
- Updated README and website documentation to include iPad Playground setup instructions.

## [1.1.0] - 2025-07-13
### Added
- Custom ruler skin support using `RulerSkin` and Assets.xcassets.
- Configurable clamp limits with `minValue` and `maxValue` (must be > 0).
- Improved performance tuning and smoother gesture handling.
- Updated README with usage examples and updated version notes.

## [1.0.0] - 2025-05-17
### Added
- Initial release of `FlywheelControl` Swift Package.
- Flywheel-style radial control with inertial scrolling.
- Haptic feedback with CoreHaptics.
- SwiftUI support with touch and Apple Pencil input.
- Decoupled design using closure-based `onDelta` handler.
- ZoomValueManager example for model integration.
- SwiftUI Preview and unit test support.
