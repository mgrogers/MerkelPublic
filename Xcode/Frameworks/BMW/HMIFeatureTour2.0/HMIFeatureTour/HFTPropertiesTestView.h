//
//  HFTPropertiesTestView.h
//  HMIFeatureTour
//
//  Created by John Jessen on 7/18/12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMWAppKit/BMWAppKit.h>

@interface HFTPropertiesTestView : IDView

@property (nonatomic, retain) id mainWidget;

- (IDImageData *)imageDataForInt:(int)i;

@end
