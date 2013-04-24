//
//  BMWAppDelegate.m
//  Merkel
//
//  Created by Tim Shi on 2/9/13.
//  Copyright (c) 2013 BossMobileWunderkinder. All rights reserved.
//

#import "BMWAppDelegate.h"

#import "BMWAppearances.h"
#import "BMWCalendarAccess.h"
#import "BMWPhone.h"
#import "BMWManager.h"
#import "BMWViewController.h"
#import <NewRelicAgent/NewRelicAgent.h>
#import <PKRevealController/PKRevealController.h>

@interface BMWAppDelegate () <IDLogAppender, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) PKRevealController *revealController;

@end

@implementation BMWAppDelegate

static NSString * const kMerkelParseAppId = @"ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
static NSString * const KMerkelParseClientKey = @"lH8IHu99HYIF0nMiSd3KIdXe6fs0rnih2UEbHVYq";
static NSString * const kMerkelFacebookAppId = @"258693340932079";
static NSString * const kMerkelTestFlightId = @"f36a8dc5-1f19-49ad-86e7-d2613ce46b03";
static NSString * const kMerkelGoogleAnalyticsId = @"UA-38584812-1";
static NSString * const kMerkelNewRelicId = @"AAe8898c710601196e5d8a89850374f1cdfb7f3b65";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.manager = [[BMWManager alloc] init];
    [Parse setApplicationId:kMerkelParseAppId
                  clientKey:KMerkelParseClientKey];
    [PFFacebookUtils initializeWithApplicationId:kMerkelFacebookAppId];
    [self startExternalServices];
    self.revealController = (PKRevealController *)self.window.rootViewController;
    UINavigationController *frontViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MainNav"];
    [self.revealController setFrontViewController:frontViewController];
    [BMWAppearances setupAppearance];
    [[BMWCalendarAccess sharedAccess] authorizeCompletion:^(BOOL granted, NSError *error) {
        if (granted) {
            [[BMWCalendarAccess sharedAccess] getTodaysEventsCompletion:^(NSArray *events, NSError *error) {
                NSLog(@"%@", [[events lastObject] allKeys]);
            }];
        }
    }];
    return YES;
}

// Delayed start of external services to speed up app launch.
- (void)startExternalServices {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IDLogger defaultLogger] addAppender:self];
        [TestFlight takeOff:kMerkelTestFlightId];
#ifndef RELEASE
        [GAI sharedInstance].debug = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#pragma clang diagnostic pop
#endif
        [[GAI sharedInstance] trackerWithTrackingId:kMerkelGoogleAnalyticsId];
        [NewRelicAgent startWithApplicationToken:kMerkelNewRelicId];
        [self startSignificantChangeUpdates];
        [BMWPhone sharedPhone];
    });
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

#pragma mark - Location Handling

- (void)startSignificantChangeUpdates{
    if (self.locationManager == nil &&
        [CLLocationManager locationServicesEnabled] &&
        [CLLocationManager significantLocationChangeMonitoringAvailable])
        self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    [NewRelicAgent setDeviceLocation:location];
}

#pragma mark - Application Status Handling
							
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
