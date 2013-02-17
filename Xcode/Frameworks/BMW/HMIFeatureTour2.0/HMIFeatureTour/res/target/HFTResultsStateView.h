#import <Foundation/Foundation.h>

#import <BMWAppKit/BMWAppKit.h>

@interface HFTResultsStateView : IDView <IDViewDelegate>

// Public method used by Controller Manager to indicate the ViewController
// that a new message is to be displayed in the corresponding View (TestSpellerStateView)
- (void)displayNewSelectedValue:(NSString *)selectedInfo;

@end
