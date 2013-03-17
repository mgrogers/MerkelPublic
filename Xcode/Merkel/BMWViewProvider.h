//
//  BMWViewProvider.h
//  TemplateName
//
//  Created by Philip Johnston on 4/6/12.
//  Copyright (c) 2012 BMW. All rights reserved.
//

// Used by HMI to set up all views. Any views to be displayed on the head unit
// must be created here and added to the views array.

#import <Foundation/Foundation.h>
#import <BMWAppKit/BMWAppKit.h>
#import "BMWCalendarListView.h"
#import "BMWCalendarEventView.h"
#import "BMWHomeView.h"
#import "BMWLinkedInView.h"
#import "BMWAttendeeListViewDetail.h"
#import "BMWEmailView.h"

@interface BMWViewProvider : NSObject <IDHmiProvider>
@property(nonatomic, strong) IDMultimediaInfo* multimediaInfo;
@property(nonatomic, strong) IDStatusBar* statusBar;

@property (nonatomic, retain) BMWCalendarListView *calendarListView;
@property (nonatomic, strong) BMWCalendarEventView *calendarEventView;
@property (nonatomic, retain) BMWHomeView *homeView;
@property (nonatomic, retain) BMWAttendeeListViewDetail *attendeeListView;
@property (nonatomic, retain) BMWLinkedInView *profileView;
@property (nonatomic, retain) BMWEmailView *emailView;

@end
