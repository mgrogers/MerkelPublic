//
//  BMWPhone.h
//  Merkel
//
//  Created by Tim Shi on 4/20/13.
//  Copyright (c) 2013 BossMobileWunderkinds. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BMWPhoneDeviceStatusDidChangeNotification;

typedef NS_ENUM(NSInteger, BMWPhoneStatus) {
    BMWPhoneStatusNotReady,
    BMWPhoneStatusReady,
    BMWPhoneStatusConnected
};

@class TCDevice;
@protocol TCConnectionDelegate;

@interface BMWPhone : NSObject

+ (instancetype)sharedPhone;
- (void)quickCallWithDelegate:(id<TCConnectionDelegate>)connectionDelegate;
- (void)disconnect;

@property (readonly) BOOL isReady;
@property (readonly) BMWPhoneStatus status;

@end
