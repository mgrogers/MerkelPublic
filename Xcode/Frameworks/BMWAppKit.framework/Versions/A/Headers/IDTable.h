/*  
 *  IDTable.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDWidget.h"


@class IDTable;
@class IDTableCell;
@class IDTableLocation;
@class IDVariantMap;
@class IDVariantData;
@class IDView;

/**
 * This property sets the alignment of a component. 
 * Parameters
 *      int alignment:
 0: Left_Top
 1: Center_Top
 2: Right_Top
 3: Left_Center
 4: Center_Center
 5: Right_Center
 6: Left_Bottom
 7: Center_Bottom
 8: Right_Bottom
 * Applicable for: all components
 */

typedef enum {
    IDTableAlignmentLeftTop = 0,
    IDTableAlignmentCenterTop = 1,
    IDTableAlignmentRightTop = 2,
    IDTableAlignmentLeftCenter = 3,
    IDTableAlignmentCenterCenter = 4,
    IDTableAlignmentRightCenter = 5,
    IDTableAlignmentLeftBottom = 6,
    IDTableAlignmentCenterBottom = 7,
    IDTableAlignmentRightBottom = 8
} IDTableAlignment;

@protocol IDTableDelegate <NSObject>
@optional
- (void)table:(IDTable *)table didSelectItemAtIndex:(NSInteger)index;
@end

#pragma mark -

/*!
 IDTable represents a "list" compoment from the HMI description.
 */
@interface IDTable : IDWidget

+ (id)table;

/*!
 @method removeAllCells
 @abstract Clear the table.
 */
- (void)removeAllCells;

/*!
 @method setRowCount:columnCount:
 @abstract Set the table's dimensions.
 @discussion If the dimentions are different truly new, this implicitly calls -clear as well.
 @param rows Number of rows to be displayed in the table
 @param columns Number of columns to be displayed in the table
 */
- (void)setRowCount:(NSInteger)rows columnCount:(NSInteger)columns;

/*!
 @method setCell:atRow:column:
 @abstract Set an individual cell.
 @param cell IDTableCell instance
 @param row Defines the row of cell to be set
 @param column Defines the column of the cell to be set
 */
- (void)setCell:(IDTableCell *)cell atRow:(NSInteger)row column:(NSInteger)column;

/*!
 @method setColumnWidths:
 @abstract Set the columns widths.
 @discussion Format is an NSArray of NSNumbers. Each NSNumber represents the width of one column.
 @param widths NSArray of NSNumber objects. The value of each NSNumber object represents the width of the according column
 */
- (void)setColumnWidths:(NSArray *)widths;

- (void)setColumnAlignments:(NSArray *)alignments;

/*!
 @method focusRow:
 @abstract Select a row programatically.
 @param row Row to focus
 */
- (void)focusRow:(int)row;

/*!
 @abstract Delegate that should receive the callbacks.
 @discussion The delegate must implement the IDTableDelegate protocol
 */
@property (assign) id<IDTableDelegate> delegate;

/*!
 @property targetView
 @abstract The target view. When an element from the table is selected, this view is presented automtically.
 @discussion not KVO compliant
 */
@property (nonatomic, assign) IDView *targetView;

@property (nonatomic, assign) BOOL isRichTextEnabled;

@end
