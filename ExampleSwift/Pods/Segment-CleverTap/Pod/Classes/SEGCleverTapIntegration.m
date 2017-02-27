#import "SEGCleverTapIntegration.h"
#import <CleverTapSDK/CleverTap.h>
#import <Analytics/SEGAnalyticsUtils.h>
#import "SEGCleverTapIntegrationFactory.h"


@implementation SEGCleverTapIntegration

#pragma mark - Initialization

- (instancetype)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        self.settings = settings;
        
        NSString *accountID = [settings objectForKey:@"clevertap_account_id"];
        NSString *accountToken = [settings objectForKey:@"clevertap_account_token"];
        
        if (![accountID isKindOfClass:[NSString class]] || [accountID length] == 0 || ![accountToken isKindOfClass:[NSString class]] || [accountToken length] == 0) {
            return nil;
        }
        
        if ([NSThread isMainThread]) {
            [self launchWithAccountId:accountID andToken:accountToken];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self launchWithAccountId:accountID andToken:accountToken];
            });
        }
    }
    
    return self;
}

- (void)identify:(SEGIdentifyPayload *)payload {
    
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
    
    // values must be a primitive (String, Boolean, Long, Integer, Float, Double) or Date
    for (NSString *key in profile.allKeys) {
        id val = profile[key];
        if ([val isKindOfClass:[NSDictionary class]] || [val isKindOfClass:[NSArray class]]) {
            [profile removeObjectForKey:key];
        }
    }
    
    [self profilePush:profile];
}

- (void)track:(SEGTrackPayload *)payload {
    
    [self recordEvent:payload.event withProps:payload.properties];
}

-(void)alias:(SEGAliasPayload *)payload {
    
    if(!payload.theNewId || payload.theNewId.length <= 0) {
        return;
    }
    
    [self profilePush:@{@"Identity":payload.theNewId}];
}

- (void)registeredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self setPushToken:deviceToken];
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo {
    
    [self handleNotificationWithData:userInfo];
}

- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo {
    
    [self handleNotificationWithData:userInfo];
}

# pragma mark private

- (void)launchWithAccountId:(NSString *)accountID andToken:(NSString *)accountToken {
    [CleverTap changeCredentialsWithAccountID:accountID andToken:accountToken];
    [[CleverTap sharedInstance] notifyApplicationLaunchedWithOptions:nil];
}

- (void)profilePush:(NSDictionary *)profile {
    @try {
        [[CleverTap sharedInstance] profilePush:profile];
    }
    @catch (NSException *e) {
        [[CleverTap sharedInstance] recordErrorWithMessage:e.description andErrorCode:512];
    }
}

- (void)recordEvent:(NSString *)event withProps:(NSDictionary *)props {
    @try {
        [[CleverTap sharedInstance] recordEvent:event withProps:props];
    }
    @catch (NSException *e) {
        [[CleverTap sharedInstance] recordErrorWithMessage:e.description andErrorCode:512];
    }
}

- (void)setPushToken:(NSData *)deviceToken {
    [[CleverTap sharedInstance] setPushToken:deviceToken];
}

- (void)handleNotificationWithData:(NSDictionary *)userInfo {
    [[CleverTap sharedInstance] handleNotificationWithData:userInfo];
}


@end
