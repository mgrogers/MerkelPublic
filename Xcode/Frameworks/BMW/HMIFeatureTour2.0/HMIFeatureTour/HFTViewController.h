//
//  HFTViewController.h
//  HMIFeatureTour
//
//  Created by Ernesto Ramos on 02.03.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFTBMWManager.h"

@interface HFTViewController : UIViewController <HFTConnectionDelegate>

- (void)connectedBMW: (NSNotification*) notification;
- (void)disconnectedBMW:(NSNotification *)notification;

@property (nonatomic, retain) IBOutlet UILabel* connectionLabel;

@end
