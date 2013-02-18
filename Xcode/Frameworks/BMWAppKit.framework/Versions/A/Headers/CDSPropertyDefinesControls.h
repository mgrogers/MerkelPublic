/*  
 *  CDSPropertyDefinesControls.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @const      CDSControlsHeadlights
 @abstract   This gives the value pertaining to the current status of the vehicle's exterior headlight status
 @discussion (controls.headlights) Stored in response key "headlights" as an enumeration. Possible values are: CDSControlsLights_ON, CDSControlsLights_OFF
 */
extern NSString * const CDSControlsHeadlights;
enum eCDSControlsLights
{
    CDSControlsLights_OFF = 0,
    CDSControlsLights_ON = 1
};
