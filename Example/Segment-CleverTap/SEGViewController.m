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
                                              @"phone" : @"+15555555556",
                                              @"testArr" : @[@"1", @"2", @"3"],
                                              @"address" : @{@"city" : @"New York",
                                                             @"country" : @"US"}}];
}

- (IBAction)trackButtonPress:(id)sender {
  [[SEGAnalytics sharedAnalytics] track:@"cleverTapSegmentTrackEvent"
                             properties:@{ @"eventproperty": @"eventPropertyValue", @"testDate":[NSDate dateWithTimeIntervalSince1970:1501237800], @"testEvArr": @[@1,@2,@3]}];
    
    [[SEGAnalytics sharedAnalytics] track:@"Order Completed"
                               properties:@{
                                            @"checkout_id": @"fksdjfsdjfisjf9sdfjsd9f",
                                            @"order_id": @"50314b8e9bcf000000000000",
                                            @"affiliation": @"Google Store",
                                            @"total": @(30),
                                            @"revenue": @(25),
                                            @"currency": @"USD",
                                            @"products":@[
                                                    @{
                                                        @"product_id": @"507f1f77bcf86cd799439011",
                                                        @"sku": @"45790-32",
                                                        @"name": @"Monopoly: 3rd Edition",
                                                        @"price": @(19),
                                                        @"quantity": @(1),
                                                        @"category": @"Games",
                                                        },
                                                    @{
                                                        @"product_id": @"505bd76785ebb509fc183733",
                                                        @"sku": @"46493-32",
                                                        @"name": @"Uno Card Game",
                                                        @"price": @(3),
                                                        @"quantity": @(2),
                                                        @"category": @"Games",
                                                        },
                                             ],
                                            
                                            }];
    
}


- (IBAction)aliasButtonPress:(id)sender {
    [[SEGAnalytics sharedAnalytics] alias:@"654321"];
}

@end
