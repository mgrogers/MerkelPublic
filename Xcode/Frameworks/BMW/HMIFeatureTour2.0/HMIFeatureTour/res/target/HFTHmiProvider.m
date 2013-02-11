#import "HFTHmiProvider.h"

@interface HFTHmiProvider()
{
    NSArray *_viewArray;
}

@property(nonatomic, retain) IDMultimediaInfo* multimediaInfo;
@property(nonatomic, retain) IDStatusBar* statusBar;

@end

@implementation HFTHmiProvider

@synthesize allFeaturesView = _allFeaturesView;
@synthesize widgetsOverviewView = _widgetsOverviewView;
@synthesize allFeaturesCommonTestView = _allFeaturesCommonTestView;
@synthesize testButtonView = _testButtonView;
@synthesize testLabelView = _testLabelView;
@synthesize testImageView = _testImageView;
@synthesize buttonsOverviewView = _buttonsOverviewView;
@synthesize labelsOverviewView = _labelsOverviewView;
@synthesize imageOverviewView = _imageOverviewView;
@synthesize checkboxRadioOverviewView = _checkboxRadioOverviewView;
@synthesize gaugeOverviewView = _gaugeOverviewView;
@synthesize inputSpellerOverviewView = _inputSpellerOverviewView;
@synthesize resultsStateView = _resultsStateView;
@synthesize tableOverviewView = _tableOverviewView;
@synthesize statesOverviewView = _statesOverviewView;
@synthesize toolbarStateView = _toolbarStateView;
@synthesize pagingStateView = _pagingStateView;
@synthesize multimediaInfo = _multimediaInfo;
@synthesize statusBar = _statusBar;
@synthesize tableLayoutView = _tableLayoutView;

@synthesize mainView = _mainView;

- (id)init
{
    if (self = [super init])
    {
        _allFeaturesView = [[HFTAllFeaturesView view] retain];
        _widgetsOverviewView = [[HFTWidgetsOverviewView view] retain];
        _allFeaturesCommonTestView = [[HFTAllFeaturesCommonTestView view] retain];
        _testButtonView = [[HFTTestButtonView view] retain];
        _testLabelView = [[HFTTestLabelView view] retain];
        _toolbarStateView = [[HFTToolbarStateView view] retain];
        _testImageView = [[HFTTestImageView view] retain];
        _buttonsOverviewView = [[HFTButtonsOverviewView view] retain];
        _labelsOverviewView = [[HFTLabelsOverviewView view] retain];
        _imageOverviewView = [[HFTImageOverviewView view] retain];
        _checkboxRadioOverviewView = [[HFTCheckboxRadioOverviewView view] retain];
        _pagingStateView = [[HFTPagingStateView view] retain];
        _inputSpellerOverviewView = [[HFTInputSpellerOverviewView view] retain];
        _resultsStateView = [[HFTResultsStateView view] retain];
        _tableOverviewView = [[HFTTableOverviewView view] retain];
        _statesOverviewView = [[HFTStatesOverviewView view] retain];
        _gaugeOverviewView = [[HFTGaugeOverviewView view] retain];
        _tableLayoutView = [[HFTTableLayoutStateView view] retain];
        
        _statusBar = [[IDStatusBar statusBar] retain];
        _multimediaInfo = [[IDMultimediaInfo multimediaInfo] retain];
        
        _viewArray = [[NSArray arrayWithObjects:
                       _allFeaturesView,
                       _widgetsOverviewView,
                       _allFeaturesCommonTestView,
                       _testButtonView,
                       _testLabelView,
                       _testImageView,
                       _pagingStateView,
                       _buttonsOverviewView,
                       _labelsOverviewView, 
                       _imageOverviewView, 
                       _toolbarStateView,  
                       _checkboxRadioOverviewView,
                       _inputSpellerOverviewView,
                       _resultsStateView, 
                       _tableOverviewView, 
                       _statesOverviewView,
                       _gaugeOverviewView,
                       _tableLayoutView,
                     nil] retain];
        
        _mainView = _allFeaturesView;
    }
    return self;
}

- (void)dealloc
{
    [_allFeaturesView release];
    [_widgetsOverviewView release];
    [_allFeaturesCommonTestView release];
    [_testButtonView release];
    [_testLabelView release];
    [_testImageView release];
    [_buttonsOverviewView release];
    [_labelsOverviewView release];
    [_imageOverviewView release];
    [_checkboxRadioOverviewView release];
    [_gaugeOverviewView release];
    [_inputSpellerOverviewView release];
    [_resultsStateView release];
    [_tableOverviewView release];
    [_statusBar release]; 
    [_multimediaInfo release];
    [_toolbarStateView release];
    [_pagingStateView release];
    [_statesOverviewView release];
    [_statusBar release];
    [_multimediaInfo release];
    
    [super dealloc];
}

- (id)viewForId:(NSInteger)identifier
{
    return nil;
}

- (NSArray *)allViews
{
    return [NSArray arrayWithArray:_viewArray];
}
- (IDMultimediaInfo *) multimediaInfo
{
    return _multimediaInfo;
}

- (IDStatusBar *) statusBar
{
    return _statusBar;
}

-(IDModel *)modelForId:(NSInteger)identifier
{
    return nil;
}

-(NSSet *)allModels
{
    return nil;
}
@end
