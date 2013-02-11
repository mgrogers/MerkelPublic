#import <Foundation/Foundation.h>
#import <BMWAppKit/BMWAppKit.h>

#import "HFTAllFeaturesView.h"
#import "HFTWidgetsOverviewView.h"
#import "HFTAllFeaturesCommonTestView.h"
#import "HFTTestButtonView.h"
#import "HFTTestLabelView.h"
#import "HFTTestImageView.h"
#import "HFTButtonsOverviewView.h"
#import "HFTLabelsOverviewView.h"
#import "HFTImageOverviewView.h"
#import "HFTCheckboxRadioOverviewView.h"
#import "HFTGaugeOverviewView.h"
#import "HFTInputSpellerOverviewView.h"
#import "HFTResultsStateView.h"
#import "HFTTableOverviewView.h"
#import "HFTStatesOverviewView.h"
#import "HFTToolbarStateView.h"
#import "HFTPagingStateView.h"
#import "HFTTableLayoutStateView.h"

@interface HFTHmiProvider : NSObject <IDHmiProvider>

@property (nonatomic, retain) HFTAllFeaturesView *allFeaturesView;
@property (nonatomic, retain) HFTWidgetsOverviewView *widgetsOverviewView;
@property (nonatomic, retain) HFTAllFeaturesCommonTestView *allFeaturesCommonTestView;
@property (nonatomic, retain) HFTTestButtonView *testButtonView;
@property (nonatomic, retain) HFTTestLabelView *testLabelView;
@property (nonatomic, retain) HFTTestImageView *testImageView;
@property (nonatomic, retain) HFTButtonsOverviewView *buttonsOverviewView;
@property (nonatomic, retain) HFTLabelsOverviewView *labelsOverviewView;
@property (nonatomic, retain) HFTImageOverviewView *imageOverviewView;
@property (nonatomic, retain) HFTCheckboxRadioOverviewView *checkboxRadioOverviewView;
@property (nonatomic, retain) HFTGaugeOverviewView *gaugeOverviewView;
@property (nonatomic, retain) HFTInputSpellerOverviewView *inputSpellerOverviewView;
@property (nonatomic, retain) HFTResultsStateView *resultsStateView;
@property (nonatomic, retain) HFTTableOverviewView *tableOverviewView;
@property (nonatomic, retain) HFTStatesOverviewView *statesOverviewView;
@property (nonatomic, retain) HFTToolbarStateView *toolbarStateView;
@property (nonatomic, retain) HFTPagingStateView *pagingStateView;
@property (nonatomic, retain) HFTTableLayoutStateView *tableLayoutView;

@end
