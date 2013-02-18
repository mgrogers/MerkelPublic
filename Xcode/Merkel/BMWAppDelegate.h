//
//  BMWAppDelegate.h
//  Merkel
//
//  Created by Tim Shi on 2/9/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMWManager;

@interface BMWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) BMWManager *manager;

@end
