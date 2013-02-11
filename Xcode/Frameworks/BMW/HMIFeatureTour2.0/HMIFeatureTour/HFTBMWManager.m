//
//  HFTBMWManager.m
//  HMIFeatureTour
//
//  Created by Ernesto Ramos on 02.03.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "HFTBMWManager.h"
#import "HFTHmiProvider.h"

@interface HFTBMWManager ()

@property (retain) IDApplication *application;
@property (retain) HFTBMWManager *viewControllerManager;

@end

@implementation HFTBMWManager

@synthesize application= _application;
@synthesize viewControllerManager = _viewControllerManager;
@synthesize delegate = _delegate;

#pragma mark - Object Lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupManager];
    }
    return self;
}

- (void)dealloc
{
    [self.delegate connectionStatusChanged:HFTConnectionStateDisconnected];
    _delegate = nil;
    [_application release], _application = nil;
    
    [super dealloc];
}


#pragma mark - Object Methods

- (void)setupManager
{
    [_delegate connectionStatusChanged:HFTConnectionStateDisconnected];
    
    // View provider initializes all HMI Views    
    _application = [[IDApplication alloc] initWithHmiProvider:[[[HFTHmiProvider alloc] init] autorelease]];
    _application.delegate = self;
    _application.dataSource = self;
    _application.type = IDApplicationTypeOnlineServices;
    _application.entryIcon = [_application.imageBundle imageWithName:@"iconDevice" type:@"png"];
}

- (void)startBMWApp
{
    if ([self.application isConnected])
    {
        #if TARGET_IPHONE_SIMULATOR
            [self.application stopWithCompletionBlock:nil];
            //Status: disconnecting
            [self.delegate connectionStatusChanged:HFTConnectionStateDisconnecting];
        #else
            [self.delegate connectionStatusChanged:HFTConnectionStateDisconnected];
        #endif
    }
    [self.application startWithCompletionBlock:nil];
    //We are connecting
    [self.delegate connectionStatusChanged:HFTConnectionStateConnecting];
}

- (void)stopBMWApp
{
    if ([self.application isConnected])
    {
        #if TARGET_IPHONE_SIMULATOR
            //Status: disconnecting
            [self.delegate connectionStatusChanged:HFTConnectionStateDisconnecting];
        #else
            //Status: disconnected
            [self.delegate connectionStatusChanged:HFTConnectionStateDisconnected];
        #endif
        [self.application stopWithCompletionBlock:nil];
    }
}

#pragma mark - HFTHmiResultsDelegate

- (void)didSelectResult:(NSString *)result
{
    // Information to be managed by _testSpellerViewController object.
//    [self.resultsViewController displayNewSelectedValue:result];
}

#pragma mark - IDApplicationDelegate methods

- (void)applicationRestoreMainHmiState:(IDApplication *)application
{
    //do nothing
}

- (void)application:(IDApplication *)application didConnectToVehicle:(IDVehicleInfo *)vehicleInfo
{
    //We are connected
    [self.delegate connectionStatusChanged:HFTConnectionStateConnected];
}

- (void)application:(IDApplication *)application didFailToStartWithError:(NSError *)error
{
    //We are disconnected
    [self.delegate connectionStatusChanged:HFTConnectionStateDisconnected];
}

- (void)applicationDidStart:(IDApplication *)application
{
    //We are connected
    //We MUST set AudioDlegate in ´applicationDidStart´, not before
    HFTHmiProvider *provider = self.application.hmiProvider;
    self.application.audioService.delegate = provider.allFeaturesView;
}

- (void)applicationDidStop:(IDApplication *)application
{
    //We are disconnected
    [self.delegate connectionStatusChanged:HFTConnectionStateDisconnected];
}

#pragma mark - IDApplicationDatasource methods
- (NSDictionary *)manifestForApplication:(IDApplication*)application
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"HmiFeatureTour" withExtension:@"plist"];
    return [NSDictionary dictionaryWithContentsOfURL:url];
}

- (NSArray *)textDatabasesForApplication:(IDApplication *)application
{
    switch ([[[IDVehicleMonitor sharedMonitor] vehicleInfo] brand]) {
        case IDVehicleBrandBMW:
            return [NSArray arrayWithObjects:
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HmiFeatureTour_common_Texts" withExtension:@"zip"]],
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HmiFeatureTour_bmw_Texts" withExtension:@"zip"]],
                    nil];
            break;
        case IDVehicleBrandMINI:
            return [NSArray arrayWithObjects:
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HmiFeatureTour_common_Texts" withExtension:@"zip"]],
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HmiFeatureTour_mini_Texts" withExtension:@"zip"]],
                    nil];
            break;
        default:
            return [NSArray arrayWithObjects:
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HmiFeatureTour_common_Texts" withExtension:@"zip"]],
                    nil];
            break;
    }
}

@end
