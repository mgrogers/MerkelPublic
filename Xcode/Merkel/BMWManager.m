//
//  BMWManager.m
//  TemplateName
//
//  Created by Paul Doersch on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BMWManager.h"
#import "BMWViewProvider.h"

NSString* BMWManagerConnectionStateChanged = @"BMWManagerConnectionStateChanged";

@interface BMWManager () <IDApplicationDataSource, IDApplicationDelegate>
@property(retain, nonatomic) IDApplication* application;
@property(retain, nonatomic) BMWViewProvider* viewProvider;

- (void)didConnectToBMW:(NSNotification*)notification;
- (void)didDisconnectFromBMW:(NSNotification*)notification;
- (void)connect;
- (void)disconnect;
- (void)postUpdate;
- (void)cleanUp;
@end

@implementation BMWManager
@synthesize application = _application;
@synthesize viewProvider = _viewProvider;

- (id)init
{
    self = [super init];
    if (self) {
        _viewProvider = [[BMWViewProvider alloc] init];
                        
        // Listen for IDExternalAccessoryMonitor notifications
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(didConnectToBMW:) name:IDVehicleDidConnectNotification object:nil];
        [nc addObserver:self selector:@selector(didDisconnectFromBMW:) name:IDVehicleDidDisconnectNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IDVehicleDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IDVehicleDidDisconnectNotification object:nil];
    [_viewProvider release];
    [_application release];
    [super dealloc];
}

- (BMWManagerStatus)status
{
	if (self.application)
	{
		if (self.application.isConnected)
        {
            return BMWManagerStatusConnected;
        }
        else if (!self.application.isConnected)
        {
            return BMWManagerStatusConnectionChanging;
        }
    }
    
    // else
    return BMWManagerStatusNotConnected;
}

- (void)setupApplication
{
    // Create and Configure the IDApplication
    self.application = [[[IDApplication alloc] initWithHmiProvider:_viewProvider] autorelease];
    [self.application setDataSource:self];
    [self.application setDelegate:self];
    
    
    self.application.entryIcon = [self.application.imageBundle imageWithName:@"bmwLogo" type:@"png"];
    self.application.type = IDApplicationTypeOnlineServices;
}

- (void)postUpdate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BMWManagerConnectionStateChanged object:nil];
}

#pragma mark - BMWManager Private Methods

/**
 * We were just plugged into a BMW,
 * and the underlying communication
 * layer is up and running for us.
 */
- (void)didConnectToBMW:(NSNotification*)notification
{    
    [self connect];
}

/**
 * We were just unplugged from a BMW,
 * and the underlying communication
 * layer has been completely torn
 * down.
 */
- (void)didDisconnectFromBMW:(NSNotification*)notification
{
    [self disconnect];
}


- (void)connect
{        
    [self setupApplication];
    [self.application startWithCompletionBlock:nil];
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    // Create and attach your View Controller hierarchy
    
    [self postUpdate];
}

- (void)disconnect
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    [self cleanUp];
    [self postUpdate];
}

- (void)cleanUp
{
    self.application = nil;
}


#pragma mark - IDApplicationDataSource @REQUIRED
////////////////////////////////////////////////
// IDApplicationDataSource
//

// required
/*! 
 @abstract Asks the data source to provide the NSData respresentation of the AppSwitcher model
 @discussion This method asks for the AppSwitcher model as a NSData object. This model
 contains the information that is shown in the AppSwitcher, e.g. a 50*50 px png-icon, the name
 translated to the 23 supported HMI languages for i18n purposes, the app's URL, ...
 @param application  An object representing the application requesting this information.
 @return NSData respresentation of the AppSwitcher model
 */
-(NSDictionary *)manifestForApplication:(IDApplication *)application
{
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"manifest" withExtension:@"plist"];
    return [NSDictionary dictionaryWithContentsOfURL:url];
}

#pragma mark - IDApplicationDelegate @REQUIRED
////////////////////////////////////////////////
// IDApplicationDelegate

/*!
 @method application:shouldRestoreHmiWithComponents:
 @abstract Delegate method to signal that an application should restore its main HMI state.
 @discussion Restoring the main HMI state is also known as LUM (Last User Mode). Be aware that LUM is not supported in all countries. If LUM is not supported this method will not be called. This method might get called before or after the application did start (@see applicationDidStart:).
 This method is also called if the iOS application was launched by the BMW App Switcher. In this case the components parameter is nil.
 @param application the application instance that did fail to start (@see IDApplication)
 @param components This parameter contains the ID of the HMI state that should be focused when performin LUM. In case of app switching components is nil. In this case the Application is expected to show it's main HMI state.
 */
- (void)applicationRestoreMainHmiState:(IDApplication *)application;
//- (void)application:(IDApplication *)application shouldRestoreHmiWithComponents:(NSArray *)components
{
    [self postUpdate];
}

// optional

/*!
 @method application:didConnectToVehicle:
 @abstract This delegate method will be called when the application is connected to the vehicle.
 @discussion Connected means that the a communication channel between the application and the vehicle is established. The CDS servcie (@see IDCdsService) and the HMI service (@see IDHmiService) (if required by the application) are registered with the remote HMI and ready to use. This is the right place to register for CDS values and HMI events. Be aware that the HMI service is only registered, the HMI itself has not been started yet. The AUDIO service (@see IDAudioService) has not yet been registered.
 @param application the application instance that did connect to the vehicle (@see IDApplication)
 @param vehicleInfo some information about the connected vehicle (@see IDVehicleInfo)
 */
- (void)application:(IDApplication *)application didConnectToVehicle:(IDVehicleInfo *)vehicleInfo
{
    [self postUpdate];
}

/*!
 @method applicationDidStart:
 @abstract This delegate method will be called when the application is started.
 @discussion The application has started. All services (CDS, HMI, AUDIO) are registered. The HMI service is up and running.
 @param application the application instance that did start (@see IDApplication)
 */
- (void)applicationDidStart:(IDApplication *)application
{
    [self postUpdate];
}

/*!
 @method application:didFailToStartWithError:
 @abstract Delegate method to signal an error during application startup.
 @discussion The startup process of the application did fail. The error parameter will give hints on what went wrong.
 @param application the application instance that did fail to start (@see IDApplication)
 @param error an error instance with some information on what went wrong
 */
// TODO: Finish documentation on what an develper should/can do in case of an error?
- (void)application:(IDApplication *)application didFailToStartWithError:(NSError *)error
{
    [self cleanUp];
    [self postUpdate];
}

/*!
 @method applicationDidStop:
 @abstract Delegate method to signal that the application did stop.
 @discussion The application has been stopped. All services have been shut down (CDS, HMI, AUDIO). There is no need to deregister from CDS values or unsubscribe from HMI events.
 @param application the application instance that did stop (@see IDApplication)
 */
- (void)applicationDidStop:(IDApplication *)application
{
    [self cleanUp];
    [self postUpdate];
}

@end
