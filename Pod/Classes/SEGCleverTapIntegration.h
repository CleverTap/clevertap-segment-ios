#import <Foundation/Foundation.h>
#if __has_include(<Segment/SEGIntegration.h>)
#import <Segment/SEGIntegration.h>
#elif __has_include(<Analytics/SEGIntegration.h>)
#import <Analytics/SEGIntegration.h>
#endif

@interface SEGCleverTapIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;

- (instancetype)initWithSettings:(NSDictionary *)settings;

@end
