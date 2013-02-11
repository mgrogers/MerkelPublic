//
//  HFTBMWManager.h
//  HMIFeatureTour
//
//  Created by Ernesto Ramos on 02.03.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMWAppKit/BMWAppKit.h>
#import "HFTResultsViewController.h"

enum HFTConnectionState {
    HFTConnectionStateDisconnected = 0,
    HFTConnectionStateConnecting,
    HFTConnectionStateDisconnecting,
    HFTConnectionStateConnected
} typedef HFTConnectionState;

@protocol HFTConnectionDelegate <NSObject>

- (void) connectionStatusChanged:(HFTConnectionState)status;

@end

@interface HFTBMWManager : NSObject <IDApplicationDataSource, IDApplicationDelegate, HFTHmiResultDelegate>

- (void)setupManager;
- (void)startBMWApp;
- (void)stopBMWApp;

@property (assign, nonatomic) id<HFTConnectionDelegate> delegate;

@end
