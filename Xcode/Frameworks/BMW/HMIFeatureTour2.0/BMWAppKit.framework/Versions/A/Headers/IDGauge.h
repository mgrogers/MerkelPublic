/*  
 *  IDGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"

typedef enum {
    IDGaugeTypeBalance,
    IDGaugeTypeProgress,
    IDGaugeTypeBigNumber,
    IDGaugeTypeDateTime,
    IDGaugeTypeDate,
    IDGaugeTypeTime,
    IDGaugeTypeDefault
} IDGaugeType;

@class IDGauge;

/*!
 @class IDGauge
 */
@interface IDGauge : IDWidget

/**
 * Use this property to set the width of a gauge
 @discussion adjusting the width works only for gauges whose model type is "Progress".
 * Setter of this property is not KVO compliant
 */
@property (assign, nonatomic) NSInteger width;

/*!
 @property position
    Use this property to adjust the position of a gauge's top left corner.
 @discussion
    This property is not KVO compliant.
 */
@property (assign, nonatomic) CGPoint position;

/*!
 * Set the Text of a label.
 * (not KVO compliant).
 @discussion Assigning nil to this property clears the string from the label.
 */
@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) IDGaugeType type;

+ (id)gauge;
+ (id)gaugeWithMin:(int)min max:(int)max increment:(int)inc startValue:(int)start;

@end


