#import "HFTAllFeaturesCommonTestView.h"
#import "HFTHmiProvider.h"

@interface HFTAllFeaturesCommonTestView()

@property (nonatomic, retain) IDButton *buttonWidget;
@property (nonatomic, retain) IDButton *labelWidget;
@property (nonatomic, retain) IDButton *imageWidget;

@end

@implementation HFTAllFeaturesCommonTestView

@synthesize buttonWidget = _buttonWidget;
@synthesize labelWidget = _labelWidget;
@synthesize imageWidget = _imageWidget;

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
    HFTHmiProvider *provider = self.application.hmiProvider;
    
    self.buttonWidget = [IDButton button];
    self.buttonWidget.text = @"Button";
    [self.buttonWidget setTargetView:provider.testButtonView];
    
    self.labelWidget = [IDButton button];
    self.labelWidget.text = @"Label";
    [self.labelWidget setTargetView:provider.testLabelView];
    
    self.imageWidget = [IDButton button];
    self.imageWidget.text = @"Image";
    [self.imageWidget setTargetView:provider.testImageView];
    
    self.title = @"Test Common Widget Properties";
    
    self.widgets = [NSArray arrayWithObjects:
                    self.buttonWidget,
                    self.labelWidget,
                    self.imageWidget,
                    nil];
}

@end
