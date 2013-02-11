//
//  HFTPropertiesTestView.m
//  HMIFeatureTour
//
//  Created by John Jessen on 7/18/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "HFTPropertiesTestView.h"

@implementation HFTPropertiesTestView

@synthesize mainWidget;

- (void)viewWillLoad:(IDView *)view
{
    IDButton *toggleVisible = [IDButton button];
    toggleVisible.text = @"Toggle Visibility";
    [toggleVisible setTarget:self selector:@selector(toggleVisiblePressed:) forActionEvent:IDActionEventSelect];
    
    IDButton *toggleSelectable = [IDButton button];
    toggleSelectable.text = @"Toggle Selectable";
    [toggleSelectable setTarget:self selector:@selector(toggleSelectablePressed:) forActionEvent:IDActionEventSelect];
    
    IDButton *toggleEnabled = [IDButton button];
    toggleEnabled.text = @"Toggle Enabled";
    [toggleEnabled setTarget:self selector:@selector(toggleEnablePressed:) forActionEvent:IDActionEventSelect];
    
    IDButton *focusButton = [IDButton button];
    focusButton.text = @"Focus On Widget";
    [focusButton setTarget:self selector:@selector(focusPressed:) forActionEvent:IDActionEventSelect];
    
    NSMutableArray *result = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:
                                                             self.mainWidget,
                                                             toggleVisible,
                                                             toggleSelectable,
                                                             toggleEnabled,
                                                             focusButton,
                                                             nil]];
    [result addObjectsFromArray:self.widgets];
    
    self.widgets = result;
}

- (IDImageData *)imageDataForInt:(int)i
{
    switch (i) {
        case 1:
            return [self.application.imageBundle imageWithName:@"iconLike" type:@"png"];
        case 2:
            return [self.application.imageBundle imageWithName:@"iconFlag" type:@"png"];
        case 3:
            return [self.application.imageBundle imageWithName:@"iconOpt" type:@"png"];
        case 4:
            return [self.application.imageBundle imageWithName:@"iconDislike" type:@"png"];
    }
    
    return nil;
}

#pragma mark - Event Handlers

- (void)toggleVisiblePressed:(IDButton *)button
{
    NSLog(@"%s:%d--VISIBILITY button pressed", __FUNCTION__, __LINE__);
    [self.mainWidget setVisible:![self.mainWidget visible]];
    
    button.text = [NSString stringWithFormat:@"Make%@Visible", ![self.mainWidget visible] ? @" ": @" Not "];
}

- (void)toggleSelectablePressed:(IDButton *)button
{
    NSLog(@"%s:%d--SELECT button pressed", __FUNCTION__, __LINE__);
    [self.mainWidget setSelectable:![self.mainWidget selectable]];
    
    button.text = [NSString stringWithFormat:@"Make%@Selectable", ![self.mainWidget selectable] ? @" " : @" Not "];
}

- (void)toggleEnablePressed:(IDButton *)button
{
    NSLog(@"%s:%d--ENABLED button pressed", __FUNCTION__, __LINE__);
    [self.mainWidget setEnabled:![self.mainWidget enabled]];
    
    button.text = [NSString stringWithFormat:@"Make%@Enabled", ![self.mainWidget enabled] ? @" " : @" Not "];
}

- (void)focusPressed:(IDButton *)button
{
    NSLog(@"%s:%d--FOCUS button pressed", __FUNCTION__, __LINE__);
    [self.mainWidget focus];
}

@end
