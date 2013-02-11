#import "HFTToolbarStateView.h"

@implementation HFTToolbarStateView

- (void)viewWillLoad:(IDView *)view
{
    NSMutableArray *buttons = [NSMutableArray array];
    
    self.title = @"Toolbar View";
    
    IDLabel *toolbarIconSelected = [IDLabel label];
    toolbarIconSelected.text = @"None Selected";
    toolbarIconSelected.isInfoLabel = YES;
    
    IDLabel *toolbarIconFocused = [IDLabel label];
    toolbarIconFocused.text = @"Focused: Button One";
    toolbarIconFocused.isInfoLabel = YES;
    
    //create toolbar buttons
    for (int i = 0; i < 8; i++) {
        IDButton *toolbarButton = [IDButton button];
        IDImageData *data = [self imageForIndex:i];
        if (data) {
            toolbarButton.imageData = data;
        }
        
        if (i < 4) {
            [toolbarButton setTarget:self selector:@selector(toolbarButtonPressed:) forActionEvent:IDActionEventSelect];
            [toolbarButton setTarget:self selector:@selector(toolbarButtonFocused:) forActionEvent:IDActionEventFocus];
        } else {
            toolbarButton.selectable = NO;
        }
        
        [buttons addObject:toolbarButton];
    }    
    
    self.toolbarWidgets = buttons;
    
    //set button tooltip text
    for (int i = 0; i < 4; i++) {
        IDButton *button = [self.toolbarWidgets objectAtIndex:i];
        button.text = [NSString stringWithFormat:@"Button %@", [self buttonNumber:button]];
    }
    
    self.widgets = [NSArray arrayWithObjects:
                    toolbarIconFocused,
                    toolbarIconSelected,
                    nil];
}

#pragma mark - setup helper methods

- (IDImageData *)imageForIndex:(int)i
{
    switch (i) {
        case 0:
            return [self.application.imageBundle imageWithName:@"iconMan" type:@"png"];
        case 1:
            return [self.application.imageBundle imageWithName:@"iconNote" type:@"png"];
        case 2:
            return [self.application.imageBundle imageWithName:@"iconRemFav" type:@"png"];
        case 3:
            return [self.application.imageBundle imageWithName:@"iconAddFav" type:@"png"];
        default:
            return nil;
    }
}

- (NSString *)buttonNumber:(IDButton *)button
{
    switch ([self.toolbarWidgets indexOfObject:button]) {
        case 0:
            return @"One";
        case 1:
            return @"Two";
        case 2:
            return @"Three";
        case 3:
            return @"Four";
        default:
            return @"This should not have happened.";
    }
}

- (IDButton *)focusButton
{
    return [self.widgets objectAtIndex:0];
}

- (IDButton *)selectButton
{
    return [self.widgets objectAtIndex:1];
}

#pragma mark - Event handlers

- (void)toolbarButtonPressed:(IDButton *)button
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self selectButton].text = [NSString stringWithFormat:@"Selected: Button %@", [self buttonNumber:button]];
}

- (void)toolbarButtonFocused:(IDButton *)button
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self focusButton].text = [NSString stringWithFormat:@"Focused: Button %@", [self buttonNumber:button]];
}


@end
