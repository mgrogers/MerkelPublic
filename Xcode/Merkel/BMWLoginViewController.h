//
//  BMWLoginViewController.h
//  Merkel
//
//  Created by Tim Shi on 5/8/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "GAITrackedViewController.h"

@class BMWLoginViewController;

@protocol BMWLoginDelegate

- (void)loginVCDidLogin:(BMWLoginViewController *)loginVC;

@end

@interface BMWLoginViewController : GAITrackedViewController

@property (nonatomic, weak) id <BMWLoginDelegate> loginDelegate;

@end
