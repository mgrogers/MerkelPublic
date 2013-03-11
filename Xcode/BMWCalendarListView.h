//
//  BMWCalendarListView.h
//  Merkel
//
//  Created by Tim Shi on 3/2/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>
#import "BMWCalendarEventView.h"

@interface BMWCalendarListView : IDView <IDViewDelegate>

@property (nonatomic, strong) NSArray *events;

@end
