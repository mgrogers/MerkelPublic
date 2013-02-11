#import "HFTButtonsOverviewView.h"

@interface HFTButtonsOverviewView()

@property (nonatomic, retain) IDButton *button1;
@property (nonatomic, retain) IDButton *button2;

@end

@implementation HFTButtonsOverviewView

@synthesize button1 = _button1;
@synthesize button2 = _button2;

- (void)viewWillLoad:(IDView *)view
{
    self.button1 = [IDButton button];
    self.button1.text = @"Button One";
    
    self.button2 = [IDButton button];
    self.button2.text = @"Button Two";
    
    [self.button1 setTarget:self selector:@selector(buttonDidPress:) forActionEvent:IDActionEventSelect];
    [self.button2 setTarget:self selector:@selector(buttonDidPress:) forActionEvent:IDActionEventSelect];
    
    self.button1.text = @"Click me!";
    self.button2.text = @"Click me!";
    
    self.title = @"Programmatic title";
    
    self.widgets = [NSArray arrayWithObjects:
                    self.button1,
                    self.button2,
                    nil];
}

#pragma mark - Event Handlers

- (void) buttonDidPress:(IDButton*)button
{
    if (button == self.button1)
    {
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
        self.button1.text = @"OOOPS!";
        self.button2.text  = @"Click me!";
        [self.button2 focus];   // depends on change 264 " [APPKIT-9] Added Code for HMI LUM"
    }
    else if (button == self.button2)
    {
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
        self.button1.text = @"Click me!";
        self.button2.text = @"OOOOPS!";
        [self.button1 focus];   // depends on change 264 " [APPKIT-9] Added Code for HMI LUM"
    }
}

@end
