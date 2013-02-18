/*  
 *  CDSPropertyDefinesSensors.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @const      CDSSensorsFuel
 @abstract   The amount of driving range given the current fuel level expressed in km and if the reserve tank is being used.
 @discussion (sensors.fuel) Stored in response key "fuel" as dictionary with keys "range", "tanklevel" and "reserve".  tanlevel and range are returned as numbers while reserve is returned as an enum. Possible values for reserve are CDSSensorsFuelReserve_NO, CDSSensorsFuelReserve_YES, CDSSensorsFuelReserve_INVALID
 */
extern NSString * const CDSSensorsFuel;
enum eCDSSensorsFuelReserve
{
    CDSSensorsFuelReserve_NO = 0,
    CDSSensorsFuelReserve_YES = 1,
    CDSSensorsFuelReserve_INVALID = 3
};
