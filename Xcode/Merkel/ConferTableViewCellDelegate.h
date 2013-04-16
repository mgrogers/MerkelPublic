//
//  ConferTableViewCellDelegate.h
//  Merkel
//
//  Created by Wesley Leung on 4/16/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConferListItem.h"

@protocol ConferTableViewCellDelegate <NSObject>

// indicates that the given item has been deleted
- (void) cellItemDeleted:(ConferListItem*) cellItem;

@end
