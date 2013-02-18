/*  
 *  IDTableData.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import <Foundation/Foundation.h>


@class IDTableRow;

/*!
 @class IDTableData
 */
@interface IDTableData : NSObject
{
    NSMutableArray* rows;
    NSUInteger columns;
}

+ (id)tableDataWithCapacity:(NSUInteger)capacity columns:(NSUInteger)maxColumns;

- (id)initWithCapacity:(NSUInteger)capacity columns:(NSUInteger)maxColumns;

- (void)addRow:(IDTableRow*)row;

@property (nonatomic, readonly) NSUInteger columns;
@property (nonatomic, readonly) NSArray* rows;

@end
