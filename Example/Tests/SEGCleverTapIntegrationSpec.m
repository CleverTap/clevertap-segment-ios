
@import Quick;
@import Nimble;
@import OCMock;
@import CleverTapSDK;
@import Segment_CleverTap;

@interface SEGCleverTapIntegration (Spec)
- (void)handleOrderCompleted:(SEGTrackPayload *)payload;
@end

QuickSpecBegin(SEGCleverTapIntegrationSpec)

describe(@"a Segment CleverTap integration class", ^{
    
    __block NSDictionary *niceSettings;
    beforeEach(^{
        niceSettings = @{ @"clevertap_account_id": @"ABC",
                          @"clevertap_account_token": @"001",
                          @"region": @"Region" };
    });
    
    afterEach(^{
        niceSettings = nil;
    });
    
    it(@"is initialized with settings", ^{
        
        SEGCleverTapIntegration *integration = [[SEGCleverTapIntegration alloc] initWithSettings:niceSettings];
        
        expect(integration.settings).to(equal(niceSettings));
    });
    
    it(@"returns nil for invalid settings values", ^{
        
        niceSettings = @{ @"key": @"value" };
        
        SEGCleverTapIntegration *integration = [[SEGCleverTapIntegration alloc] initWithSettings:niceSettings];
        
        expect(integration.settings).to(beNil());
    });
    
    it(@"is initialized from non-main threads", ^{
        
        __block SEGCleverTapIntegration *integration;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            integration = [[SEGCleverTapIntegration alloc] initWithSettings:niceSettings];
        });
        
        expect(integration.settings).toEventually(equal(niceSettings));
    });
});

describe(@"a Segment CleverTap integration which conforms to SEGIntegration protocol", ^{
    
    __block SEGCleverTapIntegration *integration;
    beforeEach(^{
        NSDictionary *niceSettings = @{ @"clevertap_account_id": @"ABC",
                                        @"clevertap_account_token": @"001",
                                        @"region": @"Region" };
        
        integration = [[SEGCleverTapIntegration alloc] initWithSettings:niceSettings];
    });
    
    afterEach(^{
        integration = nil;
    });
    
    context(@"when a user is identified", ^{
        
        it(@"performs user login", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap onUserLogin:[OCMArg any]]);
            
            NSDictionary *niceTraits = @{   @"address": @{ @"city": @"Mumbai", @"country": @"India" },
                                            @"anonymousId": @"C790B642-DC43-4345-AA40-82D6074BEF94",
                                            @"bool": @(YES),
                                            @"double": @"3.14159",
                                            @"email": @"support@clevertap.com",
                                            @"floatAttribute": @"12.3",
                                            @"intAttributes": @18,
                                            @"integerAttribute": @200,
                                            @"name": @"Segment CleverTap",
                                            @"phone": @"+91981234567",
                                            @"shortAttribute": @2,
                                            @"stringInt": @1,
                                            @"birthday": [NSDate date],
                                            @"testArr": @[ @1, @2, @3 ]
            };
            
            SEGIdentifyPayload *nicePayload = [[SEGIdentifyPayload alloc] initWithUserId:@"userID"
                                                                             anonymousId:@"C790B642-DC43-4345-AA40-82D6074BEF94"
                                                                                  traits:niceTraits
                                                                                 context:@{ @"key": @"value" }
                                                                            integrations:@{ @"key": @"value" }];
            
            [mockIntegration identify:nicePayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"performs user login for Females", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap onUserLogin:[OCMArg any]]);
            
            NSDictionary *niceTraits = @{   @"address": @{ @"city": @"Mumbai", @"country": @"India" },
                                            @"anonymousId": @"C790B642-DC43-4345-AA40-82D6074BEF94",
                                            @"bool": @(YES),
                                            @"double": @"3.14159",
                                            @"email": @"support@clevertap.com",
                                            @"floatAttribute": @"12.3",
                                            @"gender": @"female",
                                            @"intAttributes": @18,
                                            @"integerAttribute": @200,
                                            @"name": @"Segment CleverTap",
                                            @"phone": @"+91981234567",
                                            @"shortAttribute": @2,
                                            @"stringInt": @1,
                                            @"birthday": @"01-Mar-1990",
                                            @"testArr": @[ @1, @2, @3 ]
            };
            
            SEGIdentifyPayload *nicePayload = [[SEGIdentifyPayload alloc] initWithUserId:@"userID"
                                                                             anonymousId:@"C790B642-DC43-4345-AA40-82D6074BEF94"
                                                                                  traits:niceTraits
                                                                                 context:@{ @"key": @"value" }
                                                                            integrations:@{ @"key": @"value" }];
            
            [mockIntegration identify:nicePayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"performs user login for Males", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap onUserLogin:[OCMArg any]]);
            
            NSDictionary *niceTraits = @{   @"address": @{ @"city": @"Mumbai", @"country": @"India" },
                                            @"anonymousId": @"C790B642-DC43-4345-AA40-82D6074BEF94",
                                            @"bool": @(YES),
                                            @"double": @"3.14159",
                                            @"email": @"support@clevertap.com",
                                            @"floatAttribute": @"12.3",
                                            @"gender": @"male",
                                            @"intAttributes": @18,
                                            @"integerAttribute": @200,
                                            @"name": @"Segment CleverTap",
                                            @"phone": @"+91981234567",
                                            @"shortAttribute": @2,
                                            @"stringInt": @1,
                                            @"birthday": @"01-Mar-1990",
                                            @"testArr": @[ @1, @2, @3 ]
            };
            
            SEGIdentifyPayload *nicePayload = [[SEGIdentifyPayload alloc] initWithUserId:@"userID"
                                                                             anonymousId:@"C790B642-DC43-4345-AA40-82D6074BEF94"
                                                                                  traits:niceTraits
                                                                                 context:@{ @"key": @"value" }
                                                                            integrations:@{ @"key": @"value" }];
            
            [mockIntegration identify:nicePayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        
        it(@"does not performs user login if no traits object in payload", ^{
            
            id mock = OCMPartialMock(integration);
            
            OCMReject([mock onUserLogin:[OCMArg any]]);
            
            id mockPayload = OCMClassMock([SEGIdentifyPayload class]);
            
            [mock identify:mockPayload];
            
            OCMVerifyAll(mock);
        });
    });
    
    context(@"when an event is tracked", ^{
        
        it(@"should fire recordEvent on CleverTap SDK", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap recordEvent:[OCMArg any] withProps:[OCMArg any]]);
            
            id mockPayload = OCMClassMock([SEGTrackPayload class]);
            [mockIntegration track:mockPayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"should fire Charged event for 'Order Completed' events", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap recordChargedEventWithDetails:[OCMArg any] andItems:[OCMArg any]]);
            
            NSDictionary *payloadProperties =  @{
                @"affiliation": @"Google Store",
                @"checkout_id": @"fksdjfsdjfisjf9sdfjsd9f",
                @"currency": @"USD",
                @"order_id": @"50314b8e9bcf000000000000",
                @"products": @[
                        @{
                            @"category": @"Games",
                            @"name": @"Monopoly: 3rd Edition",
                            @"price": @19,
                            @"product_id": @"507f1f77bcf86cd799439011",
                            @"quantity": @1,
                            @"sku": @"45790-32"
                        },
                        @{
                            @"category": @"Games",
                            @"name": @"Uno Card Game",
                            @"price": @3,
                            @"product_id": @"505bd76785ebb509fc183733",
                            @"quantity": @2,
                            @"sku": @"46493-32"
                        }
                ],
                @"revenue": @25,
                @"total": @30,
                @"someKey": @{ @"key": @"value" }
            };
            
            SEGTrackPayload *nicePayload = [[SEGTrackPayload alloc] initWithEvent:@"Order Completed"
                                                                       properties:payloadProperties
                                                                          context:@{ @"key": @"value" }
                                                                     integrations:@{ @"key": @"value" }];
            
            [mockIntegration track:nicePayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"should ONLY fire Charged event for 'Order Completed' event", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMReject([mockCleverTap recordChargedEventWithDetails:[OCMArg any] andItems:[OCMArg any]]);
            
            id mockPayload = OCMClassMock([SEGTrackPayload class]);
            [mockIntegration handleOrderCompleted:mockPayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
    });
    
    context(@"when user identities are merged to fire an alias", ^{
        
        it(@"should fire profilePush on CleverTap SDK", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap profilePush:[OCMArg any]]);
            
            SEGAliasPayload *nicePayload = [[SEGAliasPayload alloc] initWithNewId:@"507f191e81"
                                                                          context:@{ @"key": @"value" }
                                                                     integrations:@{ @"key": @"value" }];
            [mockIntegration alias:nicePayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"for an empty newID, should not fire profilePush", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMReject([mockCleverTap profilePush:[OCMArg any]]);
            
            id mockPayload = OCMClassMock([SEGAliasPayload class]);
            [mockIntegration alias:mockPayload];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
    });
    
    context(@"when callbacks for push notifications invoked", ^{
        
        it(@"should register device Token", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap setPushToken:[OCMArg any]]);
            
            [mockIntegration registeredForRemoteNotificationsWithDeviceToken:[NSData data]];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"should handle push notification data", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap handleNotificationWithData:[OCMArg any]]);
            
            [mockIntegration receivedRemoteNotification:[OCMArg any]];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
        
        it(@"should handle action identifier in push notification", ^{
            
            id mockIntegration = OCMPartialMock(integration);
            id mockCleverTap = OCMPartialMock([CleverTap sharedInstance]);
            
            OCMExpect([mockCleverTap handleNotificationWithData:[OCMArg any]]);
            
            [mockIntegration handleActionWithIdentifier:[OCMArg any] forRemoteNotification:[OCMArg any]];
            
            OCMVerifyAll(mockIntegration);
            OCMVerifyAll(mockCleverTap);
        });
    });
});

QuickSpecEnd
