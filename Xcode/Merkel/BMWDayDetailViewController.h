//
//  BMWDayDetailViewController.h
//  Merkel
//
//  Created by Wesley Leung on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <EventKit/EventKit.h>
#import "QBFlatButton.h"

@interface BMWDayDetailViewController : UIViewController

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *conferenceCode;
@property (nonatomic, copy) NSString *eventTitle;
@property (nonatomic, strong) EKEvent *event;
@property (weak, nonatomic) IBOutlet QBFlatButton *joinCallButton;
@property (weak, nonatomic) IBOutlet QBFlatButton *lateButton;

@property (weak, nonatomic) IBOutlet UIButton *joinCallButton;
@property (weak, nonatomic) IBOutlet UIButton *lateButton;

- (IBAction)lateButtonPressed:(id)sender;
- (void)startCall;
- (void)sendInviteMessageAnimated:(BOOL)animated;

@end
