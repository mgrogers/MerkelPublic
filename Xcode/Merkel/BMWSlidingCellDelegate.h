//
//  ConferTableViewCellDelegate.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BMWSlidingCellDelegate <NSObject>


- (void) handleLeftSwipe:(UITableViewCell*) cellItem;
- (void) handleRightSwipe:(UITableViewCell*) cellItem;

@end
