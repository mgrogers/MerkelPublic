#import "HFTResultsStateView.h"

@interface HFTResultsStateView()

@property (nonatomic, retain) IDLabel *labelResult;

@end

@implementation HFTResultsStateView

@synthesize labelResult = _labelResult;

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
    self.labelResult = [IDLabel label];
    self.labelResult.text = @"State called from Speller Result";    
    
    self.title = @"User Selection Result";
    
    self.widgets = [NSArray arrayWithObjects:
                    self.labelResult,
                    nil];
}

#pragma mark - Class Methods

- (void)displayNewSelectedValue:(NSString *)selectedInfo
{
    self.labelResult.text = selectedInfo;
}

@end
