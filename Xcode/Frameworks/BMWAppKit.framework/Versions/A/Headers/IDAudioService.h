/*  
 *  IDAudioService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDService.h"

@class IDAudioService;

/*!
 * Defines various possible audio states.
 */
typedef enum  {
    IDAudioStateActivePlaying,
    IDAudioStateActiveMuted,
    IDAudioStateInactive
} IDAudioState;

/*!
 * Defines various possible audio button events.
 */
typedef enum {
    IDAudioButtonEventSkipUp,
    IDAudioButtonEventSkipDown,
    IDAudioButtonEventSkipLongUp,
    IDAudioButtonEventSkipLongDown,
    IDAudioButtonEventSkipStop
} IDAudioButtonEvent;

#pragma mark -
#pragma mark IDAudioServiceDelegate protocol

/*!
 * Audio Service Delegate protocol.
 */
@protocol IDAudioServiceDelegate <NSObject>

@required
- (void)audioService:(IDAudioService *)audioService entertainmentStateChanged:(IDAudioState)newState;
- (void)audioService:(IDAudioService *)audioService interruptStateChanged:(IDAudioState)newState;
- (void)audioService:(IDAudioService *)audioService multimediaButtonEvent:(IDAudioButtonEvent)button;

@end

#pragma mark -
#pragma mark IDAudioService

@interface IDAudioService : IDService

/*!
 * Standard Initializer.
 *
 * Typically not used directly. Access your
 * pre-configured instance of the audio
 * service via [application audioservice].
 */
- (id)initWithApplication:(IDApplication *)application;

/*!
 * Actiate the entertainment audio channel. 
 * Result is sent asyncronously via the delegate.
 */
- (void)activateEntertainment;

/*!
 * Deactivate the entertainment audio channel. 
 * Result is sent asyncronously via the delegate.
 */
- (void)deactivateEntertainment;

/*!
 * Actiate the interrupt audio channel. 
 * Result is sent asyncronously via the delegate.
 */
- (void)activateInterrupt;

/*!
 * Deactivate the interrupt audio channel. 
 * Result is sent asyncronously via the delegate.
 */
- (void)deactivateInterrupt;

/*!
 * The Audio Service delegate is passed updates
 * when changes to audio state occur.
 *
 * After setting the delegate, have it initially
 * check the current state and react accordingly.
 * Only new audio state changes will be automatically
 * passed to the delegate.
 */
@property (assign) id<IDAudioServiceDelegate> delegate;

/*!
 * Current entertainment audio state.
 */
@property (readonly, nonatomic) IDAudioState entertainmentAudioState;

/*!
 * Current interrupt audio state.
 */
@property (readonly, nonatomic) IDAudioState interruptAudioState;

@end
