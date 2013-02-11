/*  
 *  IDTableRow.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import <Foundation/Foundation.h>


@class IDVariantData;

/*!
 @class IDTableRow
 */
@interface IDTableRow : NSObject
{
    NSMutableArray* _variants;
}

+ (IDTableRow*)rowWithColumns:(NSUInteger)columns;

- (id)initWithColumns:(NSUInteger)columns;

- (void)setItem:(IDVariantData*)data atColumn:(NSInteger)column;
- (IDVariantData*)itemAtColumn:(NSInteger)column;
- (NSEnumerator*) objectEnumerator;

@property (nonatomic, readonly) NSUInteger columns;

@end
