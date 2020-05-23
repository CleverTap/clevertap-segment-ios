
@import Quick;
@import Nimble;
@import OCMock;
@import Segment_CleverTap;

@interface SEGCleverTapIntegration (UnitTests)
- (void)launchWithAccountId:(NSString *)accountID token:(NSString *)accountToken region:(NSString *)region;
//- (void)wowow;
- (void)identify:(SEGIdentifyPayload *)payload;
- (void)onUserLogin:(NSDictionary *)profile;
@end

QuickSpecBegin(SEGCleverTapIntegrationSpec)

describe(@"a Segment CleverTap integration class", ^{
   
    it(@"is initialized with settings", ^{

        NSDictionary *settingsDict = @{ @"clevertap_account_id": @"ABC",
                                        @"clevertap_account_token": @"001",
                                        @"region": @"Region" };

        SEGCleverTapIntegration *integration = [[SEGCleverTapIntegration alloc] initWithSettings:settingsDict];

        expect(integration.settings).to(equal(settingsDict));
    });

    it(@"returns nil for nil settings values", ^{

        NSDictionary *settingsDict = @{ @"key": @"value" };

        SEGCleverTapIntegration *integration = [[SEGCleverTapIntegration alloc] initWithSettings:settingsDict];

        expect(integration.settings).to(beNil());
    });

    it(@"initialized from non-main threads", ^{

        NSDictionary *settingsDict = @{ @"clevertap_account_id": @"ABC",
                                        @"clevertap_account_token": @"001",
                                        @"region": @"Region" };

        __block SEGCleverTapIntegration *integration;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            integration = [[SEGCleverTapIntegration alloc] initWithSettings:settingsDict];
        });

        expect(integration.settings).toEventually(equal(settingsDict));
    });
/*
    it(@"", ^{

        NSDictionary *settingsDict = @{ @"clevertap_account_id": @"ABC",
                                        @"clevertap_account_token": @"001",
                                        @"region": @"Region" };

        SEGCleverTapIntegration *integration = [[SEGCleverTapIntegration alloc] initWithSettings:settingsDict];

        id mock = OCMPartialMock(integration);

        OCMExpect([mock wowow]);

        [mock doSomething];

        OCMVerifyAll(mock);
    });
    
    
    it(@"", ^{
        
        NSDictionary *settingsDict = @{ @"clevertap_account_id": @"ABC",
                                        @"clevertap_account_token": @"001",
                                        @"region": @"Region" };

        SEGCleverTapIntegration *integration = [[SEGCleverTapIntegration alloc] initWithSettings:settingsDict];
        
        id mock = OCMPartialMock(integration);
        
        OCMExpect([mock onUserLogin:[OCMArg any]]);
        
        id mockPayload = OCMClassMock([SEGIdentifyPayload class]);
        
        [mock identify:mockPayload];
        
        OCMVerifyAll(mock);
    });
    */
});

describe(@"a Segment CleverTap integration", ^{
    
    context(@"on receiving identify: callback from SEGIntegration", ^{
        
        __block  SEGCleverTapIntegration *integration;
        beforeEach(^{
            NSDictionary *settingsDict = @{ @"clevertap_account_id": @"ABC",
                                            @"clevertap_account_token": @"001",
                                            @"region": @"Region" };

           integration = [[SEGCleverTapIntegration alloc] initWithSettings:settingsDict];
        });
        
        afterEach(^{
            integration = nil;
        });
        
        it(@"performs user login with  payload", ^{
            
            id mock = OCMPartialMock(integration);
            
            OCMExpect([mock onUserLogin:[OCMArg any]]);
            
            SEGIdentifyPayload *payload = [[SEGIdentifyPayload alloc] initWithUserId:@"userID"
                                                                         anonymousId:@"anonymousID"
                                                                              traits:@{ @"key": @"value" }
                                                                             context:@{ @"key": @"value" }
                                                                        integrations:@{ @"key": @"value" }];
            
            [mock identify:payload];
            
            OCMVerifyAll(mock);
        });
        
        it(@"does not performs user login if no traits in payload", ^{
            
            id mock = OCMPartialMock(integration);
            
            OCMReject([mock onUserLogin:[OCMArg any]]);
            
            id mockPayload = OCMClassMock([SEGIdentifyPayload class]);
            
            [mock identify:mockPayload];
            
            OCMVerifyAll(mock);
        });
    });
});

/**
describe(@"a Segment CleverTap class conforms to SEGIntegration protocol", ^{

    it(@"identifies user profile payload", ^{
        
//        id delegate = OCMProtocolMock(@protocol(SEGIntegration));
        
//        id mock = OCMClassMock([SEGCleverTapIntegration class]);
//        OCMExpect([mock identify:[OCMArg any]]);

        
        SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"qp2acCBE3Ph9v4EhOPpXeJtUXa2xepQz"];
        
        SEGCleverTapIntegrationFactory *instance = [SEGCleverTapIntegrationFactory instance];
        
        
        NSDictionary *settingsDict = @{ @"clevertap_account_id": @"ABC",
                                               @"clevertap_account_token": @"001",
                                               @"region": @"Region" };
        id analytics = OCMClassMock([SEGAnalytics class]);
        SEGCleverTapIntegration *object = [instance createWithSettings:settingsDict forAnalytics:analytics];
        id mock = OCMPartialMock(object);
        OCMExpect([mock identify:[OCMArg any]]);
        
        
        [config use:instance];
        [SEGAnalytics setupWithConfiguration:config];
        
        NSInteger integerAttribute = 200;
         float floatAttribute = 12.3f;
         int intAttribute = 18;
         short shortAttribute = (short)2;
        
        
         [[SEGAnalytics sharedAnalytics] identify:@"cleverTapSegementTestUseriOS"
                                           traits:@{ @"email": @"support@clevertap.com",
                                                     @"bool" : @(YES),
                                                     @"double" : @(3.14159),
                                                     @"stringInt": @"1",
                                                     @"intAttribute": @(intAttribute),
                                                     @"integerAttribute" : @(integerAttribute),
                                                     @"floatAttribute" : @(floatAttribute),
                                                     @"shortAttribute" : @(shortAttribute),
                                                     @"gender" : @"female",
                                                     @"name" : @"Segment CleverTap",
                                                     @"phone" : @"+15555555556",
                                                     @"testArr" : @[@"1", @"2", @"3"],
                                                     @"address" : @{@"city" : @"New York",
                                                                    @"country" : @"US"}}];
        
        
        OCMVerifyAll(mock);
        
//        OCMVerifyAllWithDelay(delegate, 10);
//
//        id mock = OCMPartialMock(integration);
//
//        OCMExpect([mock identify:[OCMArg any]]);
//
//        OCMStub([]);
        
//        id protocolMock = OCMProtocolMock(@protocol(SEGIntegration));

//        id mockPayload = OCMClassMock([SEGIdentifyPayload class]);

//        OCMExpect([integration identify:mockPayload]);

//        OCMStub([integration identify:mockPayload]);

//        OCMVerify([integration identify:mockPayload]);
    });
});
*/


QuickSpecEnd
