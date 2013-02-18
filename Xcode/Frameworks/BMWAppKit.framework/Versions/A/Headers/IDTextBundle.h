/*  
 *  IDTextBundle.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface IDTextBundle : NSObject

/*!
 @abstract Create an instance of IDTextBundle
 @discussion This should never be called by the client. IDApplication creates an instance for the client.
 @return an instance of IDTextBundle or nil if initialization did fail
 */
+ (IDTextBundle *)textBundle;

/*!
 @abstract Get the id in the localization text files sent to the car for the equivalent key used in the .strings files created
 @discussion This method should never be used by the client. Instead the client should use IDLocalizedString(), which falls more in line with
             the iOS way of localization.
 @param key used in a .strings file
 @return the id of a piece of localized text
 */
- (NSString *)idForKey:(NSString *)key;

- (NSData *)getDataForZipFile;

@end
