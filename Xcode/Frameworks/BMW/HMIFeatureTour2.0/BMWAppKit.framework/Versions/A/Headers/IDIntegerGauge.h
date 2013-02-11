/*  
 *  IDIntegerGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDGauge.h"


@class IDIntegerGauge;

@protocol IDIntegerGaugeDelegate <NSObject>

@optional
/**
 * Called when the user clicks on the gauge to finish updating the value.
 *
 * NSInteger value is the new value.
 */
- (void)gauge:(IDIntegerGauge *)gauge didEndEditingValue:(NSInteger)value;

/**
 * Called when the user changes a gauge's value. Not called when
 * gauge value is programmatically set via the value property.
 *
 * NSInteger value is the new value after the gauge has updated.
 */
- (void)gauge:(IDIntegerGauge *)gauge didChangeValue:(NSInteger)value;

@end

#pragma mark -

@interface IDIntegerGauge : IDGauge

/**
 * Delegate object for handling gauge update & change events must
 * implement IDIntegerGaugeDelegate protocol.
 * Everytime the value of the gauge is updated, following method
 * of the delegate object will be triggered
 * [self.delegate gauge:self didEndEditingValue:self.value]
 *
 * when a new integer value is set to the gauge, following method of the
 * delegate object will be triggered
 * [self.delegate gauge:self didChangeValue:self.value]
 */
@property (assign, nonatomic) id<IDIntegerGaugeDelegate> delegate;
/**
 * value property used to store/retreive the value of the gauge in
 * NSInteger datatype.
 * This property is not KVO compliant
 */
@property (assign, nonatomic) NSInteger value;


@end
