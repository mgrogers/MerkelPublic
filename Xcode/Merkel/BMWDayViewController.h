//
//  ConferViewController.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMWSlidingCellDelegate.h"


@interface BMWDayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BMWSlidingCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
