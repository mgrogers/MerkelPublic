/*  
 *  IDButton.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDWidget.h"


@class IDImageData;
@class IDView;

/*!
 @class IDButton
    This class implements the behavior of HMI buttons in the Widget API.
 */
/*!
 @enum IDActionEvent
    Enumeration of possible action events
 @constant IDActionEventSelect
    The button was selected in the HMI
 @constant IDActionEventFocus
    The button was focused in the HMI
 */
typedef enum IDActionEvent {
    IDActionEventSelect,
    IDActionEventFocus
} IDActionEvent;

/*
 * This class implements the behavior of HMI buttons in the Widget API.
 */
@interface IDButton : IDWidget

#pragma mark - public methods

+ (id)button;
+ (id)buttonLocalized;

/*!
 @method setTarget:selector:forActionEvent
    Set the callback target and selector for a button click.
 @discussion
    The selector must have the following signature '-(void)yourMethod:(IDButton*)button'. The selector will not be retained by the button. There will be only one selector for each IDActionEvent at the same time.
 @param target
    The object the selector will be called upon
 @param selector
    The selector that should be called
 @param event
    The action event for which the target will be called @see IDActionEvent
 */
- (void)setTarget:(id)target selector:(SEL)selector forActionEvent:(IDActionEvent)event;

/*!
 @property text
    Set the text of a button.
 @discussion
    Assigning nil to this property clears the string from the label. This property is not KVO compliant.
 */
@property (nonatomic, retain) NSString *text;

/*!
 @property image
    Set the image of a button.
 @discussion
    This property is not KVO compliant.
 */
@property (nonatomic, retain) IDImageData *imageData;

/*!
 @property targetView
    Set the target view of a button.
 @discussion
    This property is not KVO compliant.
 */
@property (nonatomic, assign) IDView *targetView;

@end
