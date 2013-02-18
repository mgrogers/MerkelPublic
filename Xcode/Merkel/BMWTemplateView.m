//
//  BMWGlympseVC.m
//  TemplateName
//
//  This is the View that appears on the BMW's screen
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "BMWTemplateView.h"
#import "BMWViewProvider.h"

@implementation BMWTemplateView

- (void)viewWillLoad:(IDView *)view
{
    self.title = @"Merkel";
    
    IDLabel *label = [IDLabel label];
    label.text = @"Welcome to Merkel";
    
    IDButton *button = [IDButton button];
    button.text = @"Get latest calendar event";
    button.imageData = [self.application.imageBundle imageWithName:@"bmwLogo" type:@"png"];
    
    IDLabel *calendarText = [IDLabel label];
    
    [button setTarget:self selector:@selector(buttonPressed) forActionEvent:IDActionEventSelect];
    
//    IDImage *image = [IDImage image];
//    image.imageData = [self.application.imageBundle imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bmw" ofType:@"jpg"]]];
//    image.position = CGPointMake(100, 150);
    
    self.widgets = [NSArray arrayWithObjects:
                    label,
                    button,
                    calendarText,
                    nil];
}

static int counter = 0;


-(void)fetchLatestCalendarEvent {
//    [PFCloud callFunctionInBackground:@"latest_calendar_event" withParameters:@{} block:^(id object, NSError *error) {
//        
//        NSString *response = (NSString*)object;
//        [self.widgets lastObject].text = response;
//        
//    }];
    
    
    NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:@"2/16 5pm Dinner", @"response",
        nil];
    [[self.widgets lastObject] setText:[response objectForKey:@"response"]];
    
}
- (void)buttonPressed
{
            
    if (counter % 2 == 0) {
        [self fetchLatestCalendarEvent];
    } else {
        [[self.widgets lastObject] setText:@""];
    }
    counter++;
}

@end
