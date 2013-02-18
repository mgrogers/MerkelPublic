/*  
 *  CDSPropertyDefinesDriving.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @const      CDSDrivingOdometer
 @abstract   The total number of kilometers on a vehicle.  Should miles be required, the client should be responsible for the conversion.
 @discussion (driving.odometer) Stored in response key "odometer" as a number.
 */
extern NSString * const CDSDrivingOdometer;

/*!
 @const      CDSDrivingSpeedActual
 @abstract   The current actual driving speed reported in km/h.
 @discussion (driving.speedActual) Value is stored in response key "speedActual" as a number.
 */
extern NSString * const CDSDrivingSpeedActual;
