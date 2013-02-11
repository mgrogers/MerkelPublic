//
//  HFTAppDelegate.h
//  HMIFeatureTour
//
//  Created by Ernesto Ramos on 02.03.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BMWAppKit/BMWAppKit.h>

@interface HFTAppDelegate : UIResponder <UIApplicationDelegate, IDLogAppender>

@property (retain, nonatomic) UIWindow *window;

@end
