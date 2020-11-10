
#import "SEGCleverTapIntegrationFactory.h"
#import "SEGCleverTapIntegration.h"

@implementation SEGCleverTapIntegrationFactory

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGCleverTapIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGCleverTapIntegration alloc] initWithSettings:settings];
}

- (NSString *)key
{
    return @"CleverTap";
}

@end
