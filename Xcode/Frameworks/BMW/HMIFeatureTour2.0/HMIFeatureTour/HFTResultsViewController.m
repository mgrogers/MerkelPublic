//
//  HFTTestSpellerViewController.m
//  HMIFeatureTour
//
//  Created by Ramos Ernesto, (Ernesto.Ramos@partner.bmw.de) on 13.03.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "HFTResultsViewController.h"

@interface HFTResultsViewController ()

//Private properties
@property (retain) HFTResultsStateView *view;

@end

@implementation HFTResultsViewController

@synthesize view = _view;


#pragma mark - Object lifecycle

- (id)initWithView:(HFTResultsStateView *)aView
{
    self = [super init];
    if (self)
    {
        _view = [aView retain];
    }
    return self;
}

- (void)dealloc
{
    [_view release];
    _view = nil;
    [super dealloc];
}


#pragma mark - Class Methods

- (void)displayNewSelectedValue:(NSString *)selectedInfo
{
//    self.view.labelResultsText.text = selectedInfo;
}

@end
