/*  
 *  IDVariantData.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


typedef enum
{
    IDVariantTypeInvalid = 0,
    IDVariantTypeBoolean,
    IDVariantTypeInteger,
    IDVariantTypeString,
    IDVariantTypeDate,
    IDVariantTypeTextId,
    IDVariantTypePreInstTextId,
    IDVariantTypeImageId,
    IDVariantTypePreInstImageId,
    IDVariantTypeImageData,
    IDVariantTypeArray,
    IDVariantTypeHashtable
} IDVariantType;

/*!
 @class IDVariantData
 */
@interface IDVariantData : NSObject
{
    id             _variant;
    IDVariantType  _variantType;
}

+ (IDVariantData *)variantWithBoolean:(BOOL)data;
+ (IDVariantData *)variantWithInteger:(NSInteger)data;
+ (IDVariantData *)variantWithString:(NSString *)data;
+ (IDVariantData *)variantWithDate:(NSDateComponents *)data;
+ (IDVariantData *)variantWithTextId:(NSInteger)data;
+ (IDVariantData *)variantWithPreInstTextId:(NSInteger)data;
+ (IDVariantData *)variantWithImageId:(NSInteger)data;
+ (IDVariantData *)variantWithPreInstImageId:(NSInteger)data;
+ (IDVariantData *)variantWithImageData:(NSData *)data;
+ (IDVariantData *)variantWithArray:(NSArray *)data;
+ (IDVariantData *)variantWithDictionary:(NSDictionary *)data;

- (id)initWithBoolean:(BOOL)data;
- (id)initWithInteger:(NSInteger)data;
- (id)initWithString:(NSString *)data;
- (id)initWithDate:(NSDateComponents *)data;
- (id)initWithTextId:(NSInteger)data;
- (id)initWithPreInstTextId:(NSInteger)data;
- (id)initWithImageId:(NSInteger)data;
- (id)initWithPreInstImageId:(NSInteger)data;
- (id)initWithImageData:(NSData *)data;
- (id)initWithArray:(NSArray *) data;
- (id)initWithDictionary:(NSDictionary *) data;

- (BOOL)booleanValue;
- (NSInteger)integerValue;
- (NSString *)string;
- (NSDateComponents *)date;
- (NSInteger)textId;
- (NSInteger)imageId;
- (NSData *)imageData;

- (BOOL)isTypeOf:(IDVariantType)type;

@property (readonly) IDVariantType type;

@end
