#import "HFTTestLabelView.h"

@interface HFTTestLabelView()

// Private properties
@property (assign, nonatomic) NSInteger currentTitle;
@property (assign, nonatomic) NSInteger currentPosX;
@property (assign, nonatomic) NSInteger currentPosY;

@end

@implementation HFTTestLabelView

@synthesize currentTitle = _currentTitle;
@synthesize currentPosX = _currentPosX;
@synthesize currentPosY = _currentPosY;

- (void)viewWillLoad:(IDView *)view
{
    self.title = @"Test Label Properties";

    _currentPosX = 0;
    _currentPosY = 0;
    
    self.mainWidget = [IDLabel label];
    [self.mainWidget setText:@" Tested Label"];
    
    IDButton *buttonChangeTitle = [IDButton button];
    buttonChangeTitle.text = @"Change Title";
    [buttonChangeTitle setTarget:self selector:@selector(changeTitlePressed:) forActionEvent:IDActionEventSelect];

    IDButton *buttonChangeWaitingImage = [IDButton button];
    buttonChangeWaitingImage.text = @"Set Waiting Image";
    [buttonChangeWaitingImage setTarget:self selector:@selector(toggleWaitingImage:) forActionEvent:IDActionEventSelect];

    IDButton *buttonChangePosition = [IDButton button];
    buttonChangePosition.text = @"Change Label Position";
    [buttonChangePosition setTarget:self selector:@selector(changePosition:) forActionEvent:IDActionEventSelect];
    
    
    self.widgets = [NSArray arrayWithObjects:
                    buttonChangeTitle,
                    buttonChangeWaitingImage,
                    buttonChangePosition,
                    nil];
    
    [super viewWillLoad:view];
}

#pragma mark - Event Handlers

- (void)changeTitlePressed:(IDButton *)button
{
    NSLog(@"%s:%d--CHANGE TITLE button pressed", __FUNCTION__, __LINE__);
    self.currentTitle = (self.currentTitle % 4)+1;
    [self.mainWidget setText:[NSString stringWithFormat:@"          Label Title %d",self.currentTitle]];
}

- (void)toggleWaitingImage:(IDButton *)button
{
    NSLog(@"%s:%d--CHANGE WAITING IMAGE STATE button pressed", __FUNCTION__, __LINE__);
    [self.mainWidget setWaitingAnimation:![self.mainWidget waitingAnimation]];
    
    button.text = [NSString stringWithFormat:@"%@ Waiting Image", [self.mainWidget waitingAnimation] ? @"Remove" : @"Show"];
}

- (void)changePosition:(IDButton *)button
{
    NSLog(@"%s:%d--CHANGE LABEL POSITION button pressed", __FUNCTION__, __LINE__);
    self.currentPosX = (self.currentPosX + 20 ) % 400;
    self.currentPosY = (self.currentPosY + 40 ) % 300;
    [self.mainWidget setPosition:CGPointMake(self.currentPosX, self.currentPosY)];
}

@end
