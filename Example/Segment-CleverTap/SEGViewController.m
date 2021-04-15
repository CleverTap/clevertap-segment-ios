
#import "SEGViewController.h"
#import "SEGAnalytics.h"
#import <CleverTapSDK/CleverTap.h>
#import <CleverTapSDK/CleverTap+Inbox.h>

@interface SEGViewController () <CleverTapInboxViewControllerDelegate>

@end

@implementation SEGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeAppInbox];
    [self registerAppInbox];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initializeAppInbox {
    [[CleverTap sharedInstance] initializeInboxWithCallback:^(BOOL success) {
        int messageCount = (int)[[CleverTap sharedInstance] getInboxMessageCount];
        int unreadCount = (int)[[CleverTap sharedInstance] getInboxMessageUnreadCount];
        NSLog(@"Inbox Message: %d/%d", messageCount, unreadCount);
    }];
}

- (void)registerAppInbox {
    [[CleverTap sharedInstance] registerInboxUpdatedBlock:^{
        int messageCount = (int)[[CleverTap sharedInstance] getInboxMessageCount];
        int unreadCount = (int)[[CleverTap sharedInstance] getInboxMessageUnreadCount];
        NSLog(@"Inbox Message updated: %d/%d", messageCount, unreadCount);
    }];
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
                               properties:@{ @"eventproperty": @"eventPropertyValue",
                                             @"testPlan": @"Pro",
                                             @"testEvArr": @[@1,@2,@3]}];
    
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

- (IBAction)showAppInbox:(id)sender {
    CleverTapInboxStyleConfig *style = [[CleverTapInboxStyleConfig alloc] init];
    style.navigationTintColor = [UIColor blackColor];
    CleverTapInboxViewController *inboxController = [[CleverTap sharedInstance] newInboxViewControllerWithConfig:style andDelegate:self];
    if (inboxController) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:inboxController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)messageDidSelect:(CleverTapInboxMessage *)message atIndex:(int)index withButtonIndex:(int)buttonIndex {
    // This method is called when an inbox message is clicked(tapped or call to action)
}

@end
