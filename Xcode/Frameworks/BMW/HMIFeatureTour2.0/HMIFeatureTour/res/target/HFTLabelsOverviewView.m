#import "HFTLabelsOverviewView.h"

@interface HFTLabelsOverviewView()

@property (nonatomic, retain) IDLabel *label1;
@property (nonatomic, retain) IDLabel *label2;
@property (nonatomic, retain) IDButton *buttonChangeLabel1;
@property (nonatomic, retain) IDButton *buttonChangeLabel2;

@end

@implementation HFTLabelsOverviewView

@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize buttonChangeLabel1 = _buttonChangeLabel1;
@synthesize buttonChangeLabel2 = _buttonChangeLabel2;

-(id)init
{
    if (self = [super init])
    {
        self.delegate = self;
    }
    return self;
}

- (void)viewWillLoad:(IDView *)view
{
    self.label1 = [IDLabel label];
    self.label1.text = @"First Label";
    
    self.label2 = [IDLabel label];
    self.label2.text = @"Second Label";
    
    self.buttonChangeLabel1 = [IDButton button];
    self.buttonChangeLabel1.text = @"Change Label 1 Text";
    
    self.buttonChangeLabel2 = [IDButton button];
    self.buttonChangeLabel2.text = @"Change Label 2 Text &amp; Pos";
    
    [self.buttonChangeLabel1 setTarget:self selector:@selector(buttonChangeLabelDidPress:) forActionEvent:IDActionEventSelect];
    [self.buttonChangeLabel2 setTarget:self selector:@selector(buttonChangeLabelDidPress:) forActionEvent:IDActionEventSelect];
    self.title = @"Label Programmatic title";
    self.label1.text = @"This is label 1";
    self.label2.text = @"This is label 2";
    self.buttonChangeLabel1.text = @"Change Label1";
    self.buttonChangeLabel2.text = @"Change Label2";
    
    self.title = @"Labels";
    
    self.widgets = [NSArray arrayWithObjects:
                    self.label1,
                    self.label2,
                    self.buttonChangeLabel1,
                    self.buttonChangeLabel2,
                    nil];
}

#pragma mark - Event Handlers

- (void) buttonChangeLabelDidPress:(IDButton*)button
{
    if (button == self.buttonChangeLabel1)
    {
        self.label1.text = @"The text of Label1 changed";
        self.label1.selectable = YES;
    }
    else if (button == self.buttonChangeLabel2)
    {
        self.label2.text = @"Text & pos of Label2 changed";
        self.label2.position = CGPointMake(20, 350);
        self.label1.selectable = NO;
        self.label1.text = @"Label1 is now not selectable";
    }
}

@end
