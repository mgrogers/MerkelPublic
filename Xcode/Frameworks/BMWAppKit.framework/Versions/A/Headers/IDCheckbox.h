/*  
 *  IDCheckbox.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"

/*!
 @enum IDCheckboxStyle
 @constant IDCheckboxStyleDefault
 @constant IDCheckboxStyleRadioButton
 */
typedef enum IDCheckboxStyle {
    IDCheckboxStyleDefault,
    IDCheckboxStyleRadioButton
} IDCheckboxStyle;


@class IDApplication;
@class IDCheckbox;
@class IDModel;

/*!
 @protocol IDCheckboxDelegate
 */
@protocol IDCheckboxDelegate <NSObject>

@optional

/*!
 @method checkboxShouldToggle:
    Called when the user clicks on the checkbox. Not called when checkbox state is programmatically set via [IDCheckbox setChecked:] If the method is not implemented in the Delegate, YES is assumed so the checkbox will toggle its value.
 @return
    Return YES to allow the toggle to take place. Return NO to leave the checkbox state unchanged.
 */
- (BOOL)checkboxShouldToggle:(IDCheckbox *)checkbox;

/*!
 @method checkbox:didChangeCheckedValue:
    Called when the state of the checkbox has changed.Not called when checkbox state is programmatically set via [IDCheckbox setChecked:]
 @return
    BOOL checkedValue is the new value the checkbox has.
 */
- (void)checkbox:(IDCheckbox *)checkbox didChangeCheckedValue:(BOOL)checkedValue;

@end

#pragma mark -

@interface IDCheckbox : IDWidget


+ (id)checkbox;

/*!
 @method setChecked:
    Programmatically set the toggle widget's state.
 */

@property (assign, nonatomic) BOOL checked;

/*!
 @property text
    Set the text of a button.
 @discussion
    Assigning nil to this property clears the string from the label. This property is not KVO compliant.
 */
@property (nonatomic, copy) NSString *text;

/*!
 @property style
    Returns the style of the IDCheckbox component.
 @discussion
    returns IDCheckboxStyleDefault for checkbox HMI components and IDCheckboxStyleRadioButton for radioButton HMI components.
 */
@property (nonatomic, assign) IDCheckboxStyle style;

/*!
 @property delegate
    Delegate implementing the IDCheckboxDelegate protocol to process checkbox toggle events.
 */
@property (assign, nonatomic) id<IDCheckboxDelegate> delegate;

@end
