#import <Foundation/Foundation.h>
#if __has_include(<Segment/SEGIntegration.h>)
#import <Segment/SEGIntegrationFactory.h>
#elif __has_include(<Analytics/SEGIntegration.h>)
#import <Analytics/SEGIntegrationFactory.h>
#endif

@interface SEGCleverTapIntegrationFactory : NSObject <SEGIntegrationFactory>

+ (instancetype)instance;

@end
