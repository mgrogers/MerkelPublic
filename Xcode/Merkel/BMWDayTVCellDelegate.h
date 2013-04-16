//
//  ConferTableViewCellDelegate.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMWDayListItem.h"

@protocol BMWDayTVCellDelegate <NSObject>

// indicates that the given item has been deleted
- (void) cellItemDeleted:(BMWDayListItem*) cellItem;

@end
