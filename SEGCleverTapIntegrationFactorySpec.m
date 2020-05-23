
@import Quick;
@import Nimble;
@import OCMock;
@import Segment_CleverTap;

QuickSpecBegin(SEGCleverTapIntegrationFactorySpec)

describe(@"a Segment CleverTap Integration Factory", ^{
    
    it(@"is initialized", ^{
        
        SEGCleverTapIntegrationFactory *instance = [SEGCleverTapIntegrationFactory instance];
        expect(instance).toNot(beNil());
    });
});

QuickSpecEnd
