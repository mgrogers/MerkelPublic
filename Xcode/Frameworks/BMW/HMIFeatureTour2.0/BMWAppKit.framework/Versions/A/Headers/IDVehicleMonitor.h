/*  
 *  IDVehicleMonitor.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import <Foundation/Foundation.h>


@class IDVehicleInfo;

/*!
 Notification sent after the vehicle or the hmi simulation did connect.
 */
extern NSString *IDVehicleDidConnectNotification;

/*!
 Notification sent after the vehicle or hmi simulation did disconnect.
 */
extern NSString *IDVehicleDidDisconnectNotification;

@interface IDVehicleMonitor : NSObject

+ (IDVehicleMonitor*)sharedMonitor;

@property (assign, readonly) BOOL connected;
@property (retain, readonly) IDVehicleInfo *vehicleInfo;

@end
