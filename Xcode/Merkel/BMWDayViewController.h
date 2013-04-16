//
//  ConferViewController.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BMWDayTVCellDelegate.h"


@interface ConferViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BMWDayTVCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
