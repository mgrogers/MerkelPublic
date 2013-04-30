//
//  BMWDayDetailViewController.h
//  Merkel
//
//  Created by Wesley Leung on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMWDayTableViewController.h"
#import "TCConnectionDelegate.h"

@interface BMWDayDetailViewController : UIViewController <TCConnectionDelegate>

@property (nonatomic, strong) NSNumber *phoneNumber;
@property (nonatomic, strong) NSString *conferenceCode;
@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) EKEvent *event;
@end
