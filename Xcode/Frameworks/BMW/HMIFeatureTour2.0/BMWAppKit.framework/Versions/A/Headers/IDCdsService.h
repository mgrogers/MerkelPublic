/*  
 *  IDCdsService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDService.h"
#import "IDEventHandler.h"


@class IDVersionInfo;

/*!
 @class IDCdsService
    This service class provides the communication layer to the car data server.
 */
@interface IDCdsService : IDService <IDEventHandler>

/*!
 @method bindProperty:target:selector:completionBlock:
    Bind to the value of a car data server property.
 @param propertyName
    Name of the car data server property which should bound to.
 @param target
    The target object to receive the callback
 @param selector
    The selector to be called when the property changed. It get always called
 @param completionBlock
 */
- (void)bindProperty:(NSString*)propertyName
              target:(id)target
            selector:(SEL)selector
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method bindProperty:interval:target:selector:completionBlock:
    Bind to the value of a car data server property.
 @param propertyName
    Name of the car data server property which should become bound.
 @param interval
    The minimum data update time interval in seconds.
 @param target
    The target object to receive the callback
 @param selector
    The selector to be called when the property changed. It get always called
 @param completionBlock
 */
- (void)bindProperty:(NSString*)propertyName
            interval:(NSTimeInterval)interval
              target:(id)target
            selector:(SEL)selector
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method unbindProperty:completionBlock:
    Unbind from the value of a car data server property.
 @param propertyName
    Name of the car data server property which should become unbound.
 @param completionBlock
 */
- (void)unbindProperty:(NSString*)propertyName
       completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method asyncGetProperty:target:selector:completionBlock:
    Asynchronously fetch the value of a car data server property.
 @param propertyName
    Name of the car data server property which should get fetched.
 @param target
    The target object to receive the callback
 @param selector
    The selector to be called when the property got fetched.
 @param completionBlock
 */
- (void)asyncGetProperty:(NSString*)propertyName
                  target:(id)target
                selector:(SEL)selector
         completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @property versionInfo
    The version of the car data server built in the car the device is connected to.
 */
@property (retain, readonly) IDVersionInfo *versionInfo;

@end
