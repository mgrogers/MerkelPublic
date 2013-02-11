//
//  HFTViewController.m
//  HMIFeatureTour
//
//  Created by Ernesto Ramos on 02.03.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//
#import "HFTViewController.h"
#import <BMWAppKit/BMWAppKit.h>

@interface HFTViewController ()

@property (retain) HFTBMWManager *manager;

@end

@implementation HFTViewController
@synthesize connectionLabel = _connectionLabel;
@synthesize manager = _manager;

#pragma mark - Object Lifecycle

- (void)dealloc
{
    self.connectionLabel = nil;
    self.manager = nil;
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Register the Connect and Disconnect ID notifications to the NotificationCenter.
    // When the phone is connected/disconnected to/from the vehicle, those notifications
    // are triggered. The callbacks are implemented in ´connectBMW´and ´disconnectBMW´
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectedBMW:)
                                                 name:IDVehicleDidConnectNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectedBMW:)
                                                 name:IDVehicleDidDisconnectNotification
                                               object:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - View Callbacks

- (void)connectedBMW:(NSNotification *)notification
{
    // When phone is connected (or start button in simulator pressed), BMWManager is
    // Started. The status of the connection (managed in the BMWManager class) will
    // be updated by the BMWManager object via calling the callback function
    // implemented in the protocol GSConnectionCallback
    if (self.manager==nil)
    {
        self.manager = [[[HFTBMWManager alloc] init] autorelease];
        self.manager.delegate = self;
    }
    [self.manager startBMWApp];
}

- (void)disconnectedBMW:(NSNotification *)notification
{
    [self.manager stopBMWApp];
}


#pragma mark - Helper Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Protocol Methods

//The method is called by the delegate that implements the protocol (GSBMWManager)
// According to connection status reported, labels in the AppView are updated
- (void) connectionStatusChanged:(HFTConnectionState)status
{
    switch (status)
    {
        case HFTConnectionStateConnected:
            self.connectionLabel.text = @"Status: Connected";
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            break;
        case HFTConnectionStateConnecting:
            self.connectionLabel.text = @"Status: Connecting";
            break;
        case HFTConnectionStateDisconnecting:
            self.connectionLabel.text = @"Status: Disconnecting";
            break;
        case HFTConnectionStateDisconnected:
            self.connectionLabel.text = @"Status: Disconnected";
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            break;
        default:
            break;
    }
}

@end
