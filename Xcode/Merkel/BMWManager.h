//
//  BMWManager.h
//  TemplateName
//
//  Created by Paul Doersch on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMWAppKit/BMWAppKit.h>

extern NSString* BMWManagerConnectionStateChanged;

enum BMWManagerStatus {
    BMWManagerStatusNotConnected,
    BMWManagerStatusConnectionChanging,
    BMWManagerStatusConnected
} typedef BMWManagerStatus;

/**
 * Simply Alloc/init an instance
 * of this object to start your
 * BMW App listening for a car
 * to connect to.
 */
@interface BMWManager : NSObject

- (BMWManagerStatus)status;

@end
