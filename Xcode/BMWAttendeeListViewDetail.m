//
//  BMWAttendeeListViewDetail.m
//  Merkel
//
//  Created by Wesley Leung on 3/10/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import "BMWAttendeeListViewDetail.h"
#import "BMWLinkedInProfile.h"
#import "BMWViewProvider.h"

@interface BMWAttendeeListViewDetail ()

@property NSInteger selectedIndex;

@end

@implementation BMWAttendeeListViewDetail

+ (IDView *)view {
    return [super view];
}

- (void)viewWillLoad:(IDView *)view {
    BMWViewProvider *provider = self.application.hmiProvider;
    provider.linkedinView.linkedInDelegate = self;
    
    self.title = @"Event Attendees";
    NSMutableArray *attendeeButtons = [NSMutableArray array];
    const NSInteger kButtonLimit = 10;
    for (int i = 0; i < kButtonLimit; i++) {
        IDButton *button = [IDButton button];
        [button setTarget:self selector:@selector(buttonFocused:) forActionEvent:IDActionEventFocus];
        [button setTargetView:provider.linkedinView];
        button.visible = NO;
        [attendeeButtons addObject:button];
    }
    self.widgets = attendeeButtons;
}

- (void)viewDidBecomeFocused:(IDView *)view {
    NSInteger index = 0;
    for (BMWLinkedInProfile *profile in self.attendees) {
        IDButton *button = [self.widgets objectAtIndex:index];
        button.text = profile.name;
        button.visible = YES;
        index++;
    }
}

- (void)viewDidLoseFocus:(IDView *)view {
    for (IDButton *button in self.widgets) {
        button.visible = NO;
    }
}

- (void)buttonFocused:(IDButton *)button {
    _selectedIndex = [self.widgets indexOfObject:button];
}

#pragma mark - BMWLinkedInViewDelegate

- (BMWLinkedInProfile *)attendeeForAttendeeView:(BMWLinkedInView *)profileView {
    return self.attendees[self.selectedIndex];
}

@end
