# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

The CleverTap destination plugin for Segment's `analytics-ios` (Segment's 4.x Objective-C SDK). It is a thin adapter: Segment calls into it with payload objects, and it translates them into CleverTap SDK calls. The entire shipping product is four files in `Pod/Classes/`. Everything else is example apps, tests, and packaging.

Distributed two ways, both pointing at the same `Pod/` directory:
- CocoaPods via `Segment-CleverTap.podspec` (depends on pods `Analytics` and `CleverTap-iOS-SDK`)
- SwiftPM via `Package.swift` (depends on `segmentio/analytics-ios` and `CleverTap/clevertap-ios-sdk`, target path `Pod`, flat public headers)

## Build and test

Pods are gitignored for `Example/` and `ExampleSwift/`, so install before building:

```sh
make install                      # pod install --project-directory=Example
```

The unit tests live in `Example/Tests/` and run through the example workspace. The test bundle is app-hosted by `Segment-CleverTap_Example`, so a host app that fails to launch fails the whole suite.

```sh
make test                         # Segment-CleverTap_Example on iPhone 17, iOS 27.0
make build
```

Override `SCHEME` or `DESTINATION` to target something else, or invoke `xcodebuild` directly:

```sh
xcodebuild test \
  -workspace Example/Segment-CleverTap.xcworkspace \
  -scheme Segment-CleverTap_Tests \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,OS=27.0,name=iPhone 17'
```

Run a single spec with `-only-testing:` plus the Quick spec class, e.g. `-only-testing:Segment-CleverTap_Tests/SEGCleverTapIntegrationSpec`.

Tests use Quick + Nimble + OCMock (declared only in the `Segment-CleverTap_Tests` target in `Example/Podfile`). Specs reach into private methods by redeclaring them in a category at the top of the spec file - that pattern is intentional, follow it rather than widening the public header.

CI is Bitrise (`bitrise.yml`), not GitHub Actions: the `primary` workflow runs on every PR and does `cocoapods-install` → `xcode-analyze` → `xcode-test` against `Example/Segment-CleverTap.xcworkspace`.

## Architecture

`SEGCleverTapIntegrationFactory` is a singleton registered with Segment via `[config use:[SEGCleverTapIntegrationFactory instance]]`. Its `key` is `"CleverTap"`, which is how Segment matches the destination settings fetched from the Segment dashboard. It hands those settings to `SEGCleverTapIntegration`.

`SEGCleverTapIntegration` implements `SEGIntegration`. Two things about its construction matter:

- It returns `nil` from `initWithSettings:` when `clevertap_account_id` or `clevertap_account_token` are missing or empty. Segment treats a nil integration as "destination not enabled", so this is the disable path.
- `CleverTap setCredentialsWithAccountID:token:region:` plus `notifyApplicationLaunchedWithOptions:` must run on the main thread, so init does a `dispatch_sync` to main when it is not already there.

The payload mapping is where the real logic is. Segment's generic event vocabulary gets translated to CleverTap's specific one:

- `identify:` → `onUserLogin:`. Segment's lowercase traits are duplicated into CleverTap's capitalized reserved keys (`Identity`, `Email`, `Name`, `Phone`, `Gender`, `DOB`). Gender is normalized to `M`/`F`; `birthday` is parsed from ISO 8601 (`yyyy-MM-dd'T'HH:mm:ssZZZZZ`) or passed through if already an `NSDate`. Nested dictionaries are stripped because CleverTap profile values must be primitives, string arrays, or dates.
- `track:` → `recordEvent:withProps:`, except the event named exactly `"Order Completed"`, which is special-cased into `recordChargedEventWithDetails:andItems:`. There, `products` becomes the items array, `order_id` is mirrored to `Charged ID`, `total` is mirrored to `Amount`, and any other non-scalar property is dropped.
- `alias:` → `profilePush:` with the new id as `Identity`.
- `screen:`, push token registration, and remote notification callbacks forward directly.

All CleverTap calls are wrapped in `@try/@catch` that reports failures back through `recordErrorWithMessage:andErrorCode:512` rather than crashing the host app.

## Conditional imports

Every file importing Segment or CleverTap headers uses an `__has_include` ladder, because the module name differs by distribution channel: CocoaPods gives `<Analytics/...>` and `<CleverTap-iOS-SDK/CleverTap.h>`, SwiftPM gives `<Segment/...>` and (under `SWIFT_PACKAGE`) a flat `"CleverTap.h"`. Preserve these ladders when adding imports - dropping one silently breaks one of the two installation paths, and only one of them is exercised by the test suite.

## Version bumps

The SDK version is recorded in three places that must stay in sync:
- `s.version` in `Segment-CleverTap.podspec`
- `const int libVersion` in `Pod/Classes/SEGCleverTapIntegration.m` (encoded form: 1.4.0 → `10400`), reported to CleverTap via `setCustomSdkVersion:version:`
- a new entry in `CHANGELOG.md`, which by convention names the exact CleverTap SDK version supported

When bumping the underlying CleverTap SDK, update both the `s.dependency 'CleverTap-iOS-SDK'` floor in the podspec and the `from:` version in `Package.swift`, then re-run `pod install` in `Example/` and `ExampleSwift/` so the committed `ExampleSwift/Podfile.lock` reflects it.

Release steps are in `RELEASING.md` (tag, push, `pod trunk push`).

## Example apps

- `Example/` - Objective-C host app plus the test target; this is the one CI builds.
- `ExampleSwift/` - Swift app via CocoaPods; its `Podfile.lock` is committed and is the best record of the resolved dependency versions.
- `ExampleSwiftPM/` - Swift app consuming the package through SwiftPM; use it to verify the `SWIFT_PACKAGE` import path still compiles.
