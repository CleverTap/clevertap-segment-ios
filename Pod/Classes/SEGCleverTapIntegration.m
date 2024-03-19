
#import "SEGCleverTapIntegration.h"

#if defined(__has_include) && __has_include(<CleverTap-iOS-SDK/CleverTap.h>)
#import <CleverTap-iOS-SDK/CleverTap.h>
#elif SWIFT_PACKAGE
#import "CleverTap.h"
#else
#import <CleverTapSDK/CleverTap.h>
#endif

#if defined(__has_include) && __has_include(<Analytics/SEGAnalyticsUtils.h>)
#import <Analytics/SEGAnalyticsUtils.h>
#elif defined(__has_include) && __has_include(<Segment/SEGAnalyticsUtils.h>)
#import <Segment/SEGAnalyticsUtils.h>
#else
#import "SEGAnalyticsUtils.h"
#endif

#import "SEGCleverTapIntegrationFactory.h"

const int libVersion = 10300;
NSString * const libName = @"Segment-iOS";

@implementation SEGCleverTapIntegration


#pragma mark - Initialization

- (instancetype)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        self.settings = settings;
        
        NSString *accountID = [settings objectForKey:@"clevertap_account_id"];
        NSString *accountToken = [settings objectForKey:@"clevertap_account_token"];
        NSString *region = [settings objectForKey:@"region"];
        region = [region stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if (![accountID isKindOfClass:[NSString class]] || [accountID length] == 0 || ![accountToken isKindOfClass:[NSString class]] || [accountToken length] == 0) {
            return nil;
        }
        
        if ([NSThread isMainThread]) {
            [self launchWithAccountId:accountID token:accountToken region: region];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self launchWithAccountId:accountID token:accountToken region: region];
            });
        }
    }
    
    return self;
}

- (void)identify:(SEGIdentifyPayload *)payload
{
    NSDictionary *traits = payload.traits;
    
    if([traits count] <= 0) {
        return ;
    }
    
    NSMutableDictionary *profile = [NSMutableDictionary dictionaryWithDictionary:traits];
    
    if (payload.userId && payload.userId.length > 0) {
        profile[@"Identity"] = payload.userId;
    }
    
    NSString *email = profile[@"email"];
    if (email) {
        profile[@"Email"] = email;
    }
    
    NSString *name = profile[@"name"];
    if (name) {
        profile[@"Name"] = name;
    }
    
    id phone = profile[@"phone"];
    if (phone) {
        NSString * _phoneString = [NSString stringWithFormat:@"%@", phone];
        profile[@"phone"] = _phoneString;
        profile[@"Phone"] = _phoneString;
    }
    
    // Gender is M or F
    if ([payload.traits[@"gender"] isKindOfClass:[NSString class]]) {
        NSString *gender = payload.traits[@"gender"];
        if ([gender.lowercaseString isEqualToString:@"m"] || [gender.lowercaseString isEqualToString:@"male"]) {
            profile[@"Gender"] = @"M";
        } else if ([gender.lowercaseString isEqualToString:@"f"] || [gender.lowercaseString isEqualToString:@"female"]) {
            profile[@"Gender"] = @"F";
        }
    }
    
    if ([payload.traits[@"birthday"] isKindOfClass:[NSString class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        profile[@"DOB"] = [dateFormatter dateFromString:payload.traits[@"birthday"]];
    }
    
    else if ([payload.traits[@"birthday"] isKindOfClass:[NSDate class]]) {
        profile[@"DOB"] = payload.traits[@"birthday"];
    }
    
    // values must be a primitive (String, Boolean, Long, Integer, Float, Double) or String Array or Date
    for (NSString *key in profile.allKeys) {
        id val = profile[key];
        if ([val isKindOfClass:[NSDictionary class]]) {
            [profile removeObjectForKey:key];
        }
    }
    
    [self onUserLogin:profile];
}

- (void)screen:(SEGScreenPayload *)payload
{
    NSString *screenName = payload.name;
    
    if (!screenName) {
        return;
    }
    
    [[CleverTap sharedInstance] recordScreenView:screenName];
}

- (void)track:(SEGTrackPayload *)payload
{
    if ([payload.event isEqualToString:@"Order Completed"]) {
        return [self handleOrderCompleted:payload];
    }
    
    [self recordEvent:payload.event withProps:payload.properties];
}

- (void)alias:(SEGAliasPayload *)payload
{
    if(!payload.theNewId || payload.theNewId.length <= 0) {
        return;
    }
    
    [self profilePush:@{@"Identity":payload.theNewId}];
}

- (void)registeredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self setPushToken:deviceToken];
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo
{
    [self handleNotificationWithData:userInfo];
}

- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
{
    [self handleNotificationWithData:userInfo];
}


# pragma mark - Private

- (void)launchWithAccountId:(NSString *)accountID token:(NSString *)accountToken region:(NSString *)region
{
    [CleverTap setCredentialsWithAccountID:accountID token:accountToken region:region];
    [[CleverTap sharedInstance] setLibrary:libName];
    [[CleverTap sharedInstance] setCustomSdkVersion:libName version:libVersion];
    [[CleverTap sharedInstance] notifyApplicationLaunchedWithOptions:nil];
}

- (void)profilePush:(NSDictionary *)profile
{
    @try {
        [[CleverTap sharedInstance] profilePush:profile];
    }
    @catch (NSException *e) {
        [[CleverTap sharedInstance] recordErrorWithMessage:e.description andErrorCode:512];
    }
}

- (void)onUserLogin:(NSDictionary *)profile
{
    @try {
        [[CleverTap sharedInstance] onUserLogin:profile];
    }
    @catch (NSException *e) {
        [[CleverTap sharedInstance] recordErrorWithMessage:e.description andErrorCode:512];
    }
}

- (void)recordEvent:(NSString *)event withProps:(NSDictionary *)props
{
    @try {
        [[CleverTap sharedInstance] recordEvent:event withProps:props];
    }
    @catch (NSException *e) {
        [[CleverTap sharedInstance] recordErrorWithMessage:e.description andErrorCode:512];
    }
}

- (void)setPushToken:(NSData *)deviceToken
{
    [[CleverTap sharedInstance] setPushToken:deviceToken];
}

- (void)handleNotificationWithData:(NSDictionary *)userInfo
{
    [[CleverTap sharedInstance] handleNotificationWithData:userInfo];
}

- (void)handleOrderCompleted:(SEGTrackPayload *)payload
{
    if (![payload.event isEqualToString:@"Order Completed"]) {
        return;
    }
    NSMutableDictionary *details = [NSMutableDictionary new];
    NSArray *items = [NSArray new];
    
    NSDictionary *segmentProps = payload.properties;
    for (NSString *key in segmentProps.allKeys) {
        id value = segmentProps[key];
        if ([key isEqualToString:@"products"]) {
            if (value != nil && [value isKindOfClass:[NSArray class]]) {
                NSArray *_value = (NSArray*) value;
                if ([_value count] > 0) {
                    items = (NSArray *)value;
                }
            }
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([key isEqualToString:@"order_id"]) {
            details[@"Charged ID"] = value;
            details[key] = value;
        } else if ([key isEqualToString:@"total"]) {
            details[@"Amount"] = value;
            details[key] = value;
        } else {
            details[key] = value;
        }
    }
    
    [[CleverTap sharedInstance] recordChargedEventWithDetails:details andItems:items];
}

@end
