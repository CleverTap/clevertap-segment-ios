Releasing
=========

 1. Update the version in `Segment-CleverTap.podspec` to a non-beta version.
 2. Update the `CHANGELOG.md` for the impending release.
 3. `git commit -am "Prepare for release X.Y.Z."` (where X.Y.Z is the new version)
 4. `git tag -a X.Y.Z -m "Version X.Y.Z"` (where X.Y.Z is the new version)
 5. `git push && git push --tags`
 6. Push the podspec to CleverTap's specs repo (see below).
 7. `pod trunk push Segment-CleverTap.podspec` (only while trunk is still writable, see below)

CocoaPods trunk sunset
----------------------

CocoaPods trunk becomes read-only on December 2, 2026. After that date no new versions can be
pushed to trunk, so every release is also published to CleverTap's own specs repo,
[CleverTap/podspecs](https://github.com/CleverTap/podspecs). Push there first, then to trunk.

One-time setup, to add a local clone of the specs repo:

```bash
pod repo add clevertap-podspecs https://github.com/CleverTap/podspecs.git
```

Each release, refresh the clone and push the podspec. `Segment-CleverTap.podspec` has a literal
version, so it can be pushed as is:

```bash
pod repo update clevertap-podspecs
pod repo push clevertap-podspecs Segment-CleverTap.podspec --allow-warnings --skip-tests
```

After December 2, 2026, skip step 7. There is no trunk push.
