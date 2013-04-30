//
//  BMWAttendeeTableViewController.h
//  Merkel
//
//  Created by Wesley Leung on 4/28/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMWAttendeeTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (void)setEventAttendees:(NSArray *)attendees;

@end
