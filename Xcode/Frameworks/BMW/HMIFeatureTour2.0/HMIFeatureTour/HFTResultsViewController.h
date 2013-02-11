//
//  HFTTestSpellerViewController.h
//  HMIFeatureTour
//
//  Created by Ramos Ernesto, (Ernesto.Ramos@partner.bmw.de) on 13.03.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMWAppKit/BMWAppKit.h>
#import "HFTResultsStateView.h"

@protocol HFTHmiResultDelegate

- (void)didSelectResult:(NSString *)result;

@end


@interface HFTResultsViewController : NSObject <IDViewDelegate>

- (id)initWithView:(HFTResultsStateView *)aView;

// Public method used by Controller Manager to indicate the ViewController
// that a new message is to be displayed in the corresponding View (TestSpellerStateView)
- (void)displayNewSelectedValue:(NSString *)selectedInfo;

@end
