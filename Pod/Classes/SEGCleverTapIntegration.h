#import <Foundation/Foundation.h>
#import <Segment/SEGIntegration.h>

@interface SEGCleverTapIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;

- (instancetype)initWithSettings:(NSDictionary *)settings;

@end
