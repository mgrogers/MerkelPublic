#import "HFTAllFeaturesView.h"
#import "HFTHmiProvider.h"

@implementation HFTAllFeaturesView

- (void)viewWillLoad:(IDView *)view
{    
    HFTHmiProvider *provider = self.application.hmiProvider;
 
    self.title = @"Features Menu";
    
    IDLabel *titleLabel = [IDLabel label];
    titleLabel.text = @"A BMW Feature Tour";
    titleLabel.selectable = NO;
    
    IDButton *widgetsButton = [IDButton button];
    widgetsButton.text = @"Widgets Overview";
    [widgetsButton setTargetView:provider.widgetsOverviewView];
    
    IDButton *propertiesButton = [IDButton button];
    propertiesButton .text = @"Test Widget Properties";
    [propertiesButton  setTargetView:provider.allFeaturesCommonTestView];
    
    IDButton *hmiScreensButton = [IDButton button];
    hmiScreensButton.text = @"HMI Screens";
    [hmiScreensButton setTargetView:provider.statesOverviewView];
    
    IDButton *statusBar = [IDButton button];
    statusBar.text = @"Status Bar";
    [statusBar setTarget:self selector:@selector(changeStatusBarPressed:) forActionEvent:IDActionEventSelect];

    IDButton *multimediaInfo = [IDButton button];
    multimediaInfo.text = @"Multimedia Info";
    [multimediaInfo setTarget:self selector:@selector(changeMultimediaInfoPressed:) forActionEvent:IDActionEventSelect];

    self.widgets = [NSArray arrayWithObjects:
                    titleLabel,
                    widgetsButton,
                    propertiesButton,
                    hmiScreensButton,
                    statusBar,
                    multimediaInfo,
                    nil];
}

#pragma mark - Event Handlers
- (void) changeStatusBarPressed:(IDButton *)button
{
    [self.application.hmiProvider statusBar].text = @"HMI Feature Tour";
}

- (void) changeMultimediaInfoPressed:(IDButton *)button
{
    // In order to be able to display multimedia infos we need to become the active entertainment source frist
    [self.application.audioService activateEntertainment];
}

#pragma mark - IDAudioDelegate methods

- (void)audioService:(IDAudioService *)audioService entertainmentStateChanged:(IDAudioState)newState
{
    switch (newState) {
        case IDAudioStateActivePlaying:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Entertainment";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Playing";
            break;
        case IDAudioStateActiveMuted:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Entertainment";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Muted";
            break;
        case IDAudioStateInactive:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Entertainment";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Inactive";
            break;
        default:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Entertainment";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Unknown";
            break;
    }
}

- (void)audioService:(IDAudioService *)audioService interruptStateChanged:(IDAudioState)newState
{
    NSLog(@"%s -- does not support interrupt audio!", __PRETTY_FUNCTION__);
}


- (void)audioService:(IDAudioService *)audioService multimediaButtonEvent:(IDAudioButtonEvent)event
{
    switch (event) {
        case IDAudioButtonEventSkipDown:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Button Event";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Skip Down";
            break;
        case IDAudioButtonEventSkipUp:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Button Event";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Skip Up";
            break;
        case IDAudioButtonEventSkipLongDown:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Button Event";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Long Down";
            break;
        case IDAudioButtonEventSkipLongUp:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Button Event";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Long Up";
            break;
        case IDAudioButtonEventSkipStop:
            self.application.hmiProvider.multimediaInfo.firstLine = @"Button Event";
            self.application.hmiProvider.multimediaInfo.secondLine = @"Skip Stop";
            break;
    }
}

@end
