//
//  HFTStatesOverviewView.m
//  HMIFeatureTour
//
//  Created by John Jessen on 7/19/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "HFTStatesOverviewView.h"
#import "HFTHmiProvider.h"

@implementation HFTStatesOverviewView

- (void)viewWillLoad:(IDView *)view
{    
    HFTHmiProvider *provider = self.application.hmiProvider;

    self.title = @"HMI States";

    IDButton *toolbarButton = [IDButton button];
    toolbarButton.text = @"Toolbar State";
    [toolbarButton setTargetView:provider.toolbarStateView];
    
    IDButton *pagingButton = [IDButton button];
    pagingButton.text = @"Paging State";
    [pagingButton setTargetView:provider.pagingStateView];
    
    IDButton *tableLayout = [IDButton button];
    tableLayout.text = @"Table Layout State";
    [tableLayout setTargetView:provider.tableLayoutView];
    
    self.widgets = [NSArray arrayWithObjects:
                    toolbarButton,
                    pagingButton,
                    tableLayout,
                    nil];
}

@end
