/*  
 *  IDDateGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDGauge.h"


@class IDDateGauge;

@protocol IDDateGaugeDelegate <NSObject>

@optional

/**
 * Called when the user clicks on the gauge to finish updating the value.
 *
 * NSDate date is the new value.
 */
- (void)gauge:(IDDateGauge *)gauge didEndEditingDate:(NSDate *)date;

/**
 * Called when the user changes a gauge's value. Not called when
 * gauge value is programmatically set via the value property.
 *
 * NSDate date is the new value after the gauge has updated.
 */
- (void)gauge:(IDDateGauge *)gauge didChangeDate:(NSDate *)date;

@end

#pragma mark -

@interface IDDateGauge : IDGauge

/**
 * Delegate object for handling gauge update & change events must
 * implement IDDateGaugeDelegate protocol.
 * Everytime the date value of the gauge is updated, following method
 * of the delegate object will be triggered
 * [self.delegate gauge:self didEndEditingDate:self.date]
 *
 * when a new date value is set to the gauge, following method of the
 * delegate object will be triggered
 * [self.delegate gauge:self didChangeDate:self.date]
 */
@property (assign, nonatomic) id<IDDateGaugeDelegate> delegate;

/**
 * date property used to store/retreive the value of the gauge in
 * NSDate datatype. Only day, month and year of the date components are
 * considered.
 * This property is not KVO compliant
 */
@property (retain, nonatomic) NSDate *date;

@end
