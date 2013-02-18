/*  
 *  IDVariantMap.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


@class IDVariantData;

/*!
 @class IDVariantMap
 */
@interface IDVariantMap : NSObject
{
    NSMutableDictionary* _content;
}

+ (IDVariantMap*)variantMapWithVariant:(IDVariantData*)variant forId:(NSInteger)theId;
+ (IDVariantMap*)variantMapWithDictionary:(NSDictionary*)dictionary;

- (id)initWithVariant:(IDVariantData*)variant forId:(NSInteger)theId;
- (id)initWithDictionary:(NSDictionary*)dictionary;

- (void)setVariant:(IDVariantData*)variant forId:(NSInteger)theId; // IDParameterTypes
- (IDVariantData*)variantForId:(NSInteger)theId; // IDParameterTypes

- (NSUInteger)count;

@end
