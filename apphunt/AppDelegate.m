//
//  AppDelegate.m
//  apphunt
//
//  Created by Solene Maitre on 14/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

#import "AppDelegate.h"
#import "Colors.h"
#import <Crashlytics/Crashlytics.h>
#import <HockeySDK/HockeySDK.h>


static NSString *kLastCloseTimeKey = @"LastCloseTimeKey";
static CGFloat const kMinSleepTimeBeforeForceReload = 3*60; // 3 minutes

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
    
    [Crashlytics startWithAPIKey:@"e8909b9382f146b9274a628a93617bd33058b93a"];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"568bde932f12ef2794036cec54c4b2cc"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.mainTableViewController = [[MainTableViewController alloc]initWithNibName:@"MainTableViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainTableViewController];
    self.window.rootViewController = self.mainTableViewController;
    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSDate *now = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:now forKey:kLastCloseTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([self isOpenAfterLongSleep]) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.mainTableViewController = [[MainTableViewController alloc]initWithNibName:@"MainTableViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainTableViewController];
        self.window.rootViewController = self.mainTableViewController;
        [self.window addSubview:self.navigationController.view];
        [self.window makeKeyAndVisible];
        //NSLog(@"IsOpenAfterLongSleep");
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)isOpenAfterLongSleep{
    NSDate *now = [NSDate date];
    NSDate *lastCloseTime = [[NSUserDefaults standardUserDefaults] objectForKey:kLastCloseTimeKey];
    return lastCloseTime != nil && ([now timeIntervalSinceDate:lastCloseTime] > kMinSleepTimeBeforeForceReload);

}

@end
