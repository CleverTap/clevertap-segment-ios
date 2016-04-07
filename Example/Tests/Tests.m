
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import "SEGCleverTapIntegration.h"
#import <CleverTapSDK/CleverTap.h>
#import <OCMock/OCMock.h>
#import <Analytics/SEGIntegration.h>
#import "SEGAnalyticsUtils.h"

static NSString *CleverTapAccountID = @"6Z6-786-644Z";
static NSString *CleverTapAccountToken = @"6ba-616";

SpecBegin(InitialSpecs)

describe(@"SEGCleverTapIntegration", ^{
    describe(@"initWithSettings", ^{
        it(@"initializes CleverTap if accountID and account Token are set", ^{
            NSDictionary *settings =  @{@"CleverTapAccountID":CleverTapAccountID, @"CleverTapToken":CleverTapAccountToken};
            id cleverTapMock = OCMClassMock([CleverTap class]);
            OCMExpect([cleverTapMock changeCredentialsWithAccountID:CleverTapAccountID andToken:CleverTapAccountToken]);
            OCMExpect([[cleverTapMock sharedInstance] notifyApplicationLaunchedWithOptions:nil]);
            SEGCleverTapIntegration *cleverTapIntegration = [[SEGCleverTapIntegration alloc] initWithSettings:settings];
            OCMVerifyAllWithDelay(cleverTapMock, 2);
        });
    });
    
    describe(@"identify", ^{
        it(@"calls appropriate CleverTap method with valid values", ^{
            NSDictionary *settings =  @{@"CleverTapAccountID":CleverTapAccountID, @"CleverTapToken":CleverTapAccountToken};
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:10];
            [comps setMonth:10];
            [comps setYear:2000];
            NSDate *testDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
            id cleverTapMock = OCMClassMock([CleverTap class]);
            OCMExpect([cleverTapMock changeCredentialsWithAccountID:CleverTapAccountID andToken:CleverTapAccountToken]);
            OCMExpect([[cleverTapMock sharedInstance] notifyApplicationLaunchedWithOptions:nil]);
            
            NSDictionary *profile = @{
                                      @"Identity": @"testUser",
                                      @"DOB": testDate,
                                      @"Name": @"testName",
                                      @"Phone":@"5555555555",
                                      @"Gender" : @"F",
                                      @"birthday" : iso8601FormattedString(testDate),
                                      @"email" : @"support@clevertap.com",
                                      @"name" : @"testName",
                                      @"gender" : @"female",
                                      @"phone" : @"5555555555"
                                      };
            OCMExpect([[cleverTapMock sharedInstance] profilePush:profile]);
            
            SEGCleverTapIntegration *cleverTapIntegration = [[SEGCleverTapIntegration alloc] initWithSettings:settings];
            
            NSDictionary *traits = @{
                                     @"address" : @{ @"city" : @"foo", @"country" : @"usa" },
                                     @"birthday" : iso8601FormattedString(testDate),
                                     @"email" : @"support@clevertap.com",
                                     @"name" : @"testName",
                                     @"gender" : @"female",
                                     @"phone" : @"5555555555"
                                     };
            
            SEGIdentifyPayload *identifyPayload = [[SEGIdentifyPayload alloc] initWithUserId:@"testUser" anonymousId:nil traits:traits context:nil integrations:nil];
            
            [cleverTapIntegration identify:identifyPayload];
            
            OCMVerifyAllWithDelay(cleverTapMock, 2);
        });
        
    });
    
    describe(@"track", ^{
        it(@"records an event", ^{
            NSDictionary *settings =  @{@"CleverTapAccountID":CleverTapAccountID, @"CleverTapToken":CleverTapAccountToken};
            id cleverTapMock = OCMClassMock([CleverTap class]);
            OCMExpect([cleverTapMock changeCredentialsWithAccountID:CleverTapAccountID andToken:CleverTapAccountToken]);
            OCMExpect([[cleverTapMock sharedInstance] notifyApplicationLaunchedWithOptions:nil]);
            NSDictionary *propertiesDictionary = @{ @"value" : @1, @"extra" : @"extraValue"};
            OCMExpect([[cleverTapMock sharedInstance] recordEvent:@"testEvent" withProps:propertiesDictionary]);
            
            SEGCleverTapIntegration *cleverTapIntegration = [[SEGCleverTapIntegration alloc] initWithSettings:settings];
            NSDictionary *properties = @{
                                         @"value" : @1,
                                         @"extra" : @"extraValue"
                                         };
            
            SEGTrackPayload *trackPayload = [[SEGTrackPayload alloc] initWithEvent:@"testEvent"
                                                                        properties:properties
                                                                           context:nil
                                                                      integrations:nil];
            [cleverTapIntegration track:trackPayload];
            OCMVerifyAllWithDelay(cleverTapMock, 2);
        });
        
    });
    
    describe(@"registeredForRemoteNotificationsWithDeviceToken", ^{
        it(@"initializes calls [[CleverTap sharedInstance] setPushToken]", ^{
            NSDictionary *settings =  @{@"CleverTapAccountID":CleverTapAccountID, @"CleverTapToken":CleverTapAccountToken};
            NSData *registerData = [[NSData alloc] init];
            id cleverTapMock = OCMClassMock([CleverTap class]);
            OCMExpect([cleverTapMock changeCredentialsWithAccountID:CleverTapAccountID andToken:CleverTapAccountToken]);
            OCMExpect([[cleverTapMock sharedInstance] notifyApplicationLaunchedWithOptions:nil]);
            OCMExpect([[cleverTapMock sharedInstance] setPushToken:[OCMArg any]]);
            SEGCleverTapIntegration *cleverTapIntegration = [[SEGCleverTapIntegration alloc] initWithSettings:settings];
            [cleverTapIntegration registeredForRemoteNotificationsWithDeviceToken:registerData];
            OCMVerifyAllWithDelay(cleverTapMock, 2);
        });
    });
    
    
    describe(@"receivedRemoteNotification", ^{
        it(@"initializes calls [[CleverTap sharedInstance] handleNotificationWithData:]", ^{
            NSDictionary *settings =  @{@"CleverTapAccountID":CleverTapAccountID, @"CleverTapToken":CleverTapAccountToken};
            NSDictionary *userInfo = @{@"test":@"userInfo"};
            id cleverTapMock = OCMClassMock([CleverTap class]);
            OCMExpect([cleverTapMock changeCredentialsWithAccountID:CleverTapAccountID andToken:CleverTapAccountToken]);
            OCMExpect([[cleverTapMock sharedInstance] notifyApplicationLaunchedWithOptions:nil]);
            OCMExpect([[cleverTapMock sharedInstance] handleNotificationWithData:userInfo]);
            SEGCleverTapIntegration *cleverTapIntegration = [[SEGCleverTapIntegration alloc] initWithSettings:settings];
            [cleverTapIntegration receivedRemoteNotification:userInfo];
            OCMVerifyAllWithDelay(cleverTapMock, 2);
        });
        
    });
    
});

SpecEnd
