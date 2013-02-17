#import "HFTTestImageView.h"

@interface HFTTestImageView()

@property (nonatomic, retain) IDImage *image;

// Private properties
@property (assign, nonatomic) NSInteger currentImage;
@property (assign, nonatomic) NSInteger currentPosX;
@property (assign, nonatomic) NSInteger currentPosY;

@end

@implementation HFTTestImageView

@synthesize image = _image;

@synthesize currentImage = _currentImage;
@synthesize currentPosX = _currentPosX;
@synthesize currentPosY = _currentPosY;

- (void)viewWillLoad:(IDView *)view
{
    self.title = @"Test Image Properties";
    
    _currentPosX = 0;
    _currentPosY = 0;
    _currentImage = 1;
    
    self.image = [IDImage image];
    
    self.mainWidget = [IDImage image];
    [self.image setPosition:CGPointMake(300,0)];
    [self.mainWidget setImageData:[self.application.imageBundle imageWithName:@"iconLike" type:@"png"]];

    IDButton *buttonChangeDatabaseImage = [IDButton button];
    buttonChangeDatabaseImage.text = @"Switch Image";
    [buttonChangeDatabaseImage setTarget:self selector:@selector(changeImage:) forActionEvent:IDActionEventSelect];

    IDButton *buttonChangePosition = [IDButton button];
    buttonChangePosition.text = @"Change Image Position";
    [buttonChangePosition setTarget:self selector:@selector(changePosition:) forActionEvent:IDActionEventSelect];    
    
    self.widgets = [NSArray arrayWithObjects:
                    buttonChangeDatabaseImage,
                    buttonChangePosition,
                    self.image,
                    nil];
    
    [super viewWillLoad:view];
}

- (void)viewDidAppear:(IDView *)view
{
    //this is done to prevent the image from being add to the zip file sent to the car
    [self.image setImageData:[self.application.imageBundle imageWithName:@"BMW_7er" type:@"jpg"] clearWhileSending:YES];
}

#pragma mark - Event Handlers

- (void)changeImage:(IDButton *)button
{
    self.currentImage = (self.currentImage % 4)+1;
    NSLog(@"%s:%d--CHANGE DATABASE IMAGE to %d button pressed", __FUNCTION__, __LINE__, self.currentImage);
    [self.mainWidget setImageData:[self imageDataForInt:self.currentImage]];
    [self.mainWidget setNeedsFlush];
}

- (void)changePosition:(IDButton *)button
{
    NSLog(@"%s:%d--CHANGE IMAGE POSITION button pressed", __FUNCTION__, __LINE__);
    self.currentPosX = (self.currentPosX + 20 ) % 400;
    self.currentPosY = (self.currentPosY + 40 ) % 300;
    [self.mainWidget setPosition:CGPointMake(self.currentPosX, self.currentPosY)];
}

@end
