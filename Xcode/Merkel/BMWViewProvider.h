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

@interface BMWViewProvider : NSObject <IDHmiProvider>
@property(nonatomic, strong) IDMultimediaInfo* multimediaInfo;
@property(nonatomic, strong) IDStatusBar* statusBar;


@property (nonatomic, strong) BMWTemplateView *templateView;
@property (nonatomic, strong) BMWCalendarListView *calendarListView;
@property (nonatomic, strong) BMWCalendarEventView *calendarEventView;
@property (nonatomic, strong) BMWHomeView *homeView;


@end
