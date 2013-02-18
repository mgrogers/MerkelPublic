/*  
 *  CDSPropertyDefinesEngine.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @const      CDSEngineStatus
 @abstract   Returns the value of the engine status.
 @discussion (engine.status) Possible values are eCDSEngineStatus_OFF, eCDSEngineStatus_STARTING, eCDSEngineStatus_RUNNING, or eCDSEngineStatus_INVALID.
 */
extern NSString * const CDSEngineStatus;
enum eCDSEngineStatus
{
    CDSEngineStatus_OFF = 0,
    CDSEngineStatus_STARTING = 1,
    CDSEngineStatus_RUNNING = 2,
    CDSEngineStatus_INVALID = 3
};
