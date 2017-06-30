#import "SEGViewController.h"
#import "SEGAnalytics.h"
#import <CleverTapSDK/CleverTap.h>

@interface SEGViewController ()

@end

@implementation SEGViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)screenButtonPress:(id)sender {
    [[SEGAnalytics sharedAnalytics] screen:@"TestScreen"];
}

- (IBAction)identifyButtonPress:(id)sender {
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
                                              @"phone" : @"1234567890",
                                              @"address" : @{@"city" : @"New York",
                                                             @"country" : @"US"}}];
}

- (IBAction)trackButtonPress:(id)sender {
  [[SEGAnalytics sharedAnalytics] track:@"cleverTapSegmentTrackEvent"
                             properties:@{ @"eventproperty": @"eventPropertyValue"}];
}


- (IBAction)aliasButtonPress:(id)sender {
    [[SEGAnalytics sharedAnalytics] alias:@"654321"];
}

@end
