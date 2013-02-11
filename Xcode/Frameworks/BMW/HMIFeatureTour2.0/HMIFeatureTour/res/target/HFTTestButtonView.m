#import "HFTTestButtonView.h"

@interface HFTTestButtonView()

@property (assign, nonatomic) NSInteger currentImage;
@property (assign, nonatomic) NSInteger currentTitle;

@end

@implementation HFTTestButtonView

@synthesize currentImage = _currentImage;
@synthesize currentTitle = _currentTitle;

- (void)viewWillLoad:(IDView *)view
{    
    self.title = @"Test Button Properties";
    
    _currentImage = 1;
    _currentTitle = 0;
    
    self.mainWidget = [IDButton button];
    [self.mainWidget setText:@"***** TestedButton *****"];
    [self.mainWidget setTarget:self selector:@selector(buttonPressed:) forActionEvent:IDActionEventSelect];
    IDButton *button = self.mainWidget;
    button.imageData = [self imageDataForInt:_currentImage];
    
    IDButton *buttonChangeTitle = [IDButton button];
    buttonChangeTitle.text = @"Change Title";
    [buttonChangeTitle setTarget:self selector:@selector(changeTitlePressed:) forActionEvent:IDActionEventSelect];

    IDButton *buttonChangeImage = [IDButton button];
    buttonChangeImage.text = @"Change Image";
    [buttonChangeImage setTarget:self selector:@selector(changeImagePressed:) forActionEvent:IDActionEventSelect];
    
    self.widgets = [NSArray arrayWithObjects:
                    buttonChangeTitle,
                    buttonChangeImage,
                    nil];
    
    [super viewWillLoad:view];
}

#pragma mark - Event Handlers

- (void)buttonPressed:(IDButton *)button
{
    NSLog(@"%s:%d--Test button pressed", __FUNCTION__, __LINE__);
}

- (void)changeTitlePressed:(IDButton *)button
{
    NSLog(@"%s:%d--CHANGE TITLE button pressed", __FUNCTION__, __LINE__);
    self.currentTitle = (self.currentTitle % 4)+1;
    [self.mainWidget setText:[NSString stringWithFormat:@"          Button Title %d",self.currentTitle]];
}

- (void)changeImagePressed:(IDButton *)button
{
    NSLog(@"%s:%d--CHANGE IMAGE button pressed", __FUNCTION__, __LINE__);
    self.currentImage = (self.currentImage % 4)+1;
    IDButton *myButton = self.mainWidget;
    myButton.imageData = [self imageDataForInt:self.currentImage];
}

@end
