/*  
 *  IDLabel.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDWidget.h"


/*!
 * This class implements the behavior of HMI labels in the Widget API.
 */
@interface IDLabel : IDWidget

#pragma mark - public properties
/*!
 * Set the Text of a label.
 * (not KVO compliant).
  @discussion Assigning nil to this property clears the string from the label.
 */
@property (nonatomic, copy) NSString *text;

/*!
 * Set the Position of a label.
 * @discussion Setting the absolute position of a label causes some sideeffects in the HMI. E.g. the label is no longer selectable and it will remain at a fixed position even when scrolling the HMI state.
 * (not KVO compliant).
 */
@property (nonatomic, assign) CGPoint position;

/*!
 * Sets the waitingAnimation property of a label.
 * @discussion Setting this property to YES adds a spinner to the label for indicating updates, server requests etc. Setting this property to NO will remove the spinner.
 */
@property (nonatomic, assign) BOOL waitingAnimation;

@property (nonatomic, assign) BOOL isInfoLabel;

+ (id)label;
+ (id)labelLocalized;

@end
