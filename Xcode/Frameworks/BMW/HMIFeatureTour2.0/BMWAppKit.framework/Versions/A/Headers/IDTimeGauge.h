/*  
 *  IDTimeGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDGauge.h"


@class IDTimeGauge;

@protocol IDTimeGaugeDelegate <NSObject>

@optional
/**
 * Called when the user clicks on the gauge to finish updating the value.
 *
 * NSDate time is the new value.
 */
- (void)gauge:(IDTimeGauge *)gauge didEndEditingTime:(NSDate *)date;

/**
 * Called when the user changes a gauge's value. Not called when
 * gauge value is programmatically set via the value property.
 *
 * NSDate time is the new value after the gauge has updated.
 */
- (void)gauge:(IDTimeGauge *)gauge didChangeTime:(NSDate *)date;

@end


@interface IDTimeGauge : IDGauge

/**
 * Delegate object for handling gauge update & change events must
 * implement IDTimeGaugeDelegate protocol.
 * Everytime the time value of the gauge is updated, following method
 * of the delegate object will be triggered
 * [self.delegate gauge:self didEndEditingTime:self.date]
 *
 * when a new time value is set to the gauge, following method of the
 * delegate object will be triggered
 * [self.delegate gauge:self didChangeTime:self.date]
 */
@property (assign, nonatomic) id<IDTimeGaugeDelegate> delegate;

/**
 * time property used to store/retreive the value of the gauge in
 * NSDate datatype. Only hour and minute of the date components are
 * considered in the setter.
 * This property is not KVO compliant
 */
@property (retain, nonatomic) NSDate *time;



@end


