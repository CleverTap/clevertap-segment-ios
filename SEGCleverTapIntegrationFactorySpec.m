
@import Quick;
@import Nimble;
@import OCMock;
@import Analytics;
@import Segment_CleverTap;

QuickSpecBegin(SEGCleverTapIntegrationFactorySpec)

describe(@"a Segment CleverTap Integration Factory", ^{
    
    it(@"is initialized", ^{
        
        SEGCleverTapIntegrationFactory *instance = [SEGCleverTapIntegrationFactory instance];
        expect(instance).toNot(beNil());
    });
    
    context(@"conforms to SEGIntegrationFactory protocol", ^{
        
        __block SEGCleverTapIntegrationFactory *instance;
        beforeEach(^{
            instance = [SEGCleverTapIntegrationFactory instance];
        });
        
        afterEach(^{
            instance = nil;
        });
        
        it(@"returns a SEGCleverTapIntegration object", ^{
            
            NSDictionary *niceSettings = @{ @"clevertap_account_id": @"ABC",
                                            @"clevertap_account_token": @"001",
                                            @"region": @"Region" };
            
            id mockAnalytics = OCMClassMock([SEGAnalytics class]);
            id returnObject = [instance createWithSettings:niceSettings forAnalytics:mockAnalytics];
           
            expect(returnObject).to(beAKindOf([SEGCleverTapIntegration class]));
        });
        
        it(@"returns nil for empty Settings", ^{
            
            id mockAnalytics = OCMClassMock([SEGAnalytics class]);
            id returnObject = [instance createWithSettings:@{} forAnalytics:mockAnalytics];
        
            expect(returnObject).to(beNil());
        });
        
        it(@"returns CleverTap as key string", ^{
            
            id returnObject = [instance key];
            
            expect(returnObject).to(equal(@"CleverTap"));
        });
    });
});

QuickSpecEnd
