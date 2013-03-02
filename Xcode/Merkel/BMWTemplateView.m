//
//  BMWGlympseVC.m
//  TemplateName
//
//  This is the View that appears on the BMW's screen
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "BMWTemplateView.h"
#import "BMWViewProvider.h"
#import "BMWGCalenderDataSource.h"

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
    NSString *urlString = @"https://safe-mountain-5325.herokuapp.com/";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];

    [[BMWGCalenderDataSource sharedDataSource] authorizeRequest:request
                                              completionHandler:^(NSError *error) {
          if (error == nil) {
              //change this to async?
              NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
              if(responseData) {
                  NSError *error;
                  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                  NSLog(@"Response string %@", responseString);
                  
                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                  NSArray *eventsFromJSON = [json objectForKey:@"events"];
                  NSString *output = [NSString stringWithFormat:@"Event name: %@ on %@", [eventsFromJSON[1] objectForKey:@"summary"], [[eventsFromJSON[1] objectForKey:@"start"] objectForKey:@"dateTime"]];
                  [[self.widgets lastObject] setText: output];
              } else {
                  [[self.widgets lastObject] setText: @"Connection to calendar failed."];
                  
                  
              }
              
          } else {
              NSLog("failed");
          }
    }];
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
