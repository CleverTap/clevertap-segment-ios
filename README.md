<p align="center">
  <img src="https://github.com/CleverTap/clevertap-ios-sdk/blob/master/docs/images/clevertap-logo.png" width = "50%"/>
</p>

# CleverTap iOS Segment SDK

[![Version](https://img.shields.io/cocoapods/v/Segment-CleverTap.svg?style=flat)](http://cocoapods.org/pods/Segment-CleverTap)
[![License](https://img.shields.io/cocoapods/l/Segment-CleverTap.svg?style=flat)](http://cocoapods.org/pods/Segment-CleverTap)
[![codebeat badge](https://codebeat.co/badges/033620de-eab7-48f5-8f30-226c354e20b0)](https://codebeat.co/projects/github-com-clevertap-clevertap-segment-ios-master)

CleverTap integration for analytics-ios.

## Installation

Analytics is available through [CocoaPods](http://cocoapods.org). To install CleverTap Segment integration, simply add the following line to your Podfile:

```ruby
pod "Segment-CleverTap"
```

## Usage

1. After adding the dependency, import the integration:

 ```objc
 #import "SEGCleverTapIntegrationFactory.h"
 ```
 
2. Finally, declare CleverTap's integration in your app delegate instance:

  ```objc
  SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"YOUR_WRITE_KEY_HERE"];
  [config use:[SEGCleverTapIntegrationFactory instance]];
  [SEGAnalytics setupWithConfiguration:config];
  ```
## For more

- Checkout our [Example Usage](https://github.com/CleverTap/clevertap-segment-ios/tree/master/Example) that integrates CleverTap via Segment.
- Checkout our [CleverTap Segment Integration docs](https://github.com/CleverTap/clevertap-segment-integration-docs "CleverTap Segment Technical Documentation").

## License

```
WWWWWW||WWWWWW
 W W W||W W W
      ||
    ( OO )__________
     /  |           \
    /o o|    MIT     \
    \___/||_||__||_|| *
         || ||  || ||
        _||_|| _||_||
       (__|__|(__|__|

The MIT License (MIT)

Copyright (c) 2014 Segment, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
