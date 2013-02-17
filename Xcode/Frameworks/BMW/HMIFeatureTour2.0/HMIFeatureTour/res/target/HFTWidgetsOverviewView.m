#import "HFTWidgetsOverviewView.h"
#import "HFTHmiProvider.h"

@interface HFTWidgetsOverviewView()

@property (nonatomic, retain) IDButton *buttonWidgets;
@property (nonatomic, retain) IDButton *buttonLabels;
@property (nonatomic, retain) IDButton *buttonImage;
@property (nonatomic, retain) IDButton *buttonCheckbox;
@property (nonatomic, retain) IDButton *buttonGauges;
@property (nonatomic, retain) IDButton *buttonSpeller;
@property (nonatomic, retain) IDButton *buttonTables;

@end

@implementation HFTWidgetsOverviewView

@synthesize buttonWidgets = _buttonWidgets;
@synthesize buttonLabels = _buttonLabels;
@synthesize buttonImage = _buttonImage;
@synthesize buttonCheckbox = _buttonCheckbox;
@synthesize buttonGauges = _buttonGauges;
@synthesize buttonSpeller = _buttonSpeller;
@synthesize buttonTables = _buttonTables;

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
    
    self.buttonWidgets = [IDButton button];
    self.buttonWidgets.text = @"Buttons";
    [self.buttonWidgets setTargetView:provider.buttonsOverviewView];
    
    self.buttonLabels = [IDButton button];
    self.buttonLabels.text = @"Labels";
    [self.buttonLabels setTargetView:provider.labelsOverviewView];
    
    self.buttonImage =  [IDButton button];
    self.buttonImage.text = @"Image";
    [self.buttonImage setTargetView:provider.imageOverviewView];
    
    self.buttonCheckbox =  [IDButton button];
    self.buttonCheckbox.text = @"Checkbox";
    [self.buttonCheckbox setTargetView:provider.checkboxRadioOverviewView];
    
    self.buttonGauges =  [IDButton button];
    self.buttonGauges.text = @"Gauges";
    [self.buttonGauges setTargetView:provider.gaugeOverviewView];
    
    self.buttonSpeller =  [IDButton button];
    self.buttonSpeller.text = @"Speller";
    [self.buttonSpeller setTargetView:provider.inputSpellerOverviewView];
    
    self.buttonTables =  [IDButton button];
    self.buttonTables.text = @"Tables";
    [self.buttonTables setTargetView:provider.tableOverviewView];
    
    self.title = @"Widgets";
    
    self.widgets = [NSArray arrayWithObjects:
                    self.buttonWidgets,
                    self.buttonLabels,
                    self.buttonImage,
                    self.buttonCheckbox,
                    self.buttonGauges,
                    self.buttonSpeller,
                    self.buttonTables,
                    nil];
}

@end
