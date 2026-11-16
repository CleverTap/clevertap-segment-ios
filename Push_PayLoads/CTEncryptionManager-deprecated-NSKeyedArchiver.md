# CleverTap SDK uses NSKeyedArchiver APIs deprecated since iOS 12

**Status:** upstream issue, not fixable in this repository
**Affects:** CleverTap-iOS-SDK 7.9.1
**Found:** 16 November 2026, building against the iOS 27 SDK with Xcode 27.0 (27A266a)

## What happens

Building any of the example apps against the iOS 27 SDK emits three deprecation
warnings from the CleverTap SDK's encryption layer:

```
CleverTapSDK/Encryption/CTEncryptionManager.m:216:37: warning: 'archivedDataWithRootObject:' is deprecated:
    first deprecated in iOS 12.0 - Use +archivedDataWithRootObject:requiringSecureCoding:error: instead
CleverTapSDK/Encryption/CTEncryptionManager.m:289:55: warning: 'unarchiveObjectWithData:' is deprecated:
    first deprecated in iOS 12.0 - Use +unarchivedObjectOfClass:fromData:error: instead
CleverTapSDK/Encryption/CTEncryptionManager.m:315:51: warning: 'unarchiveObjectWithData:' is deprecated:
    first deprecated in iOS 12.0 - Use +unarchivedObjectOfClass:fromData:error: instead
```

## Why it matters

`+archivedDataWithRootObject:` and `+unarchiveObjectWithData:` are the non
secure-coding variants. They were deprecated in iOS 12 in favour of the
`requiringSecureCoding:` / `unarchivedObjectOfClass:` forms, which validate the
class graph on decode. The deprecated pair will decode whatever classes the
archive names, so they are the weaker option for data that round-trips through
storage.

These are warnings today. They become build errors whenever Apple removes the
symbols, and that would break every app shipping the CleverTap SDK until a new
SDK release lands.

## What this repository can do

Nothing directly. `Pod/Classes/` does not call these APIs; the usage is entirely
inside `CleverTap-iOS-SDK`, which arrives as a dependency through both the
podspec and `Package.swift`. The fix belongs in
[clevertap-ios-sdk](https://github.com/CleverTap/clevertap-ios-sdk):

- `+archivedDataWithRootObject:` becomes `+archivedDataWithRootObject:requiringSecureCoding:error:`
- `+unarchiveObjectWithData:` becomes `+unarchivedObjectOfClass:fromData:error:`

Both replacements are available from iOS 11 and 12 respectively, well below the
iOS 15.0 floor that CleverTap 7.9.1 already declares, so adopting them costs no
platform support.

## Verifying

```sh
pod install --project-directory=Example
xcodebuild build \
  -workspace Example/Segment-CleverTap.xcworkspace \
  -scheme Segment-CleverTap_Example \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,OS=27.0,name=iPhone 17' 2>&1 | grep CTEncryptionManager
```
