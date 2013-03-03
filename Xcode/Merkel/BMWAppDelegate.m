//
//  BMWAppDelegate.m
//  Merkel
//
//  Created by Tim Shi on 2/9/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAppDelegate.h"
#import "BMWManager.h"
#import "BMWViewController.h"

@interface BMWAppDelegate () <IDLogAppender>
@end

@implementation BMWAppDelegate

static NSString * const kMerkelParseAppId = @"ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
static NSString * const KMerkelParseClientKey = @"lH8IHu99HYIF0nMiSd3KIdXe6fs0rnih2UEbHVYq";
static NSString * const kMerkelFacebookAppId = @"258693340932079";
static NSString * const kMerkelTestFlightId = @"88aa09c0e7c7f6e45ac504c0b996d08d_MTg4MjE4MjAxMy0wMi0xNyAxNzo0ODoxMS43OTQzOTA";
static NSString * const kMerkelGoogleAnalyticsId = @"UA-38584812-1";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [[IDLogger defaultLogger] addAppender:self];
    
    self.manager = [[BMWManager alloc] init];
    
    [Parse setApplicationId:kMerkelParseAppId
                  clientKey:KMerkelParseClientKey];
    [PFFacebookUtils initializeWithApplicationId:kMerkelFacebookAppId];
    [TestFlight takeOff:kMerkelTestFlightId];
#ifndef RELEASE
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#pragma clang diagnostic pop
#endif
    [[GAI sharedInstance] trackerWithTrackingId:kMerkelGoogleAnalyticsId];
    return YES;
}

- (void)appendLoggerEvent:(IDLoggerEvent *)event
{
    NSLog(@"%@", event.message);
}

#pragma mark - URL Handling

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
