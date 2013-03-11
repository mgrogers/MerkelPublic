//
//  BMWViewProvider.h
//  TemplateName
//
//  Created by Philip Johnston on 4/6/12.
//  Copyright (c) 2012 BMW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMWAppKit/BMWAppKit.h>
#import "BMWTemplateView.h"
#import "BMWCalendarListView.h"
#import "BMWCalendarEventView.h"
#import "BMWHomeView.h"
#import "BMWLinkedInView.h"
#import "BMWAttendeeListViewDetail.h"

@interface BMWViewProvider : NSObject <IDHmiProvider>
@property(nonatomic, strong) IDMultimediaInfo* multimediaInfo;
@property(nonatomic, strong) IDStatusBar* statusBar;

@property (nonatomic, retain) BMWTemplateView *templateView;
@property (nonatomic, retain) BMWCalendarListView *calendarListView;
@property (nonatomic, strong) BMWCalendarEventView *calendarEventView;
@property (nonatomic, retain) BMWHomeView *homeView;
@property (nonatomic, retain) BMWAttendeeListViewDetail *attendeeListView;
@property (nonatomic, retain) BMWLinkedInView *profileView;

@end
