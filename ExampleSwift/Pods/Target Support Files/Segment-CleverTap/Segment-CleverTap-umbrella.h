#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SEGCleverTapIntegration.h"
#import "SEGCleverTapIntegrationFactory.h"
#import "CleverTap.h"
#import "CleverTapBuildInfo.h"
#import "CleverTapEventDetail.h"
#import "CleverTapInAppNotificationDelegate.h"
#import "CleverTapSyncDelegate.h"
#import "CleverTapTrackedViewController.h"
#import "CleverTapUTMDetail.h"

FOUNDATION_EXPORT double Segment_CleverTapVersionNumber;
FOUNDATION_EXPORT const unsigned char Segment_CleverTapVersionString[];

