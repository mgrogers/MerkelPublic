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

@class TCDevice, EKEvent;
@protocol TCConnectionDelegate;

@interface BMWPhone : NSObject

+ (instancetype)sharedPhone;
- (void)quickCallWithDelegate:(id<TCConnectionDelegate>)connectionDelegate;
- (void)callWithDelegate:(id<TCConnectionDelegate>)connectionDelegate
       andConferenceCode: (NSString*) conferenceCode;
- (void)disconnect;
- (void)dialConferenceCode:(NSString *)conferenceCode;

@property (readonly) BOOL isReady;
@property (nonatomic, getter = isSpeakerEnabled) BOOL speakerEnabled;
@property (nonatomic, getter = isMuted) BOOL muted;
@property (readonly) BMWPhoneStatus status;
@property (readonly) NSString *phoneNumber;
@property (nonatomic, strong) EKEvent *currentCallEvent;
@property (nonatomic, copy) NSString *currentCallCode;
@property (nonatomic, weak) id <TCConnectionDelegate>connectionDelegate;

@end
