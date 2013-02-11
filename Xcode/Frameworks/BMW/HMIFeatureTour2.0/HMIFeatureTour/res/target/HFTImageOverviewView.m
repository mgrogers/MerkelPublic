#import "HFTImageOverviewView.h"

@interface HFTImageOverviewView()

@property (nonatomic, retain) IDImage *photo;

@end

@implementation HFTImageOverviewView

@synthesize photo = _photo;

- (void)viewWillLoad:(IDView *)view
{
    self.title = @"Image";

    self.photo = [IDImage image];
    [self.photo setPosition:CGPointMake(100, 50)];
        
    self.widgets = [NSArray arrayWithObjects:
                    self.photo,
                    nil];
}

- (void)viewDidAppear:(IDView *)view
{
    [self.photo setImageData:[self.application.imageBundle imageWithName:@"BMW_7er" type:@"jpg"] clearWhileSending:YES];
}

@end
