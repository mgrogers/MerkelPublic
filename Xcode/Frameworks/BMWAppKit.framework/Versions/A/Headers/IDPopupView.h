/*  
 *  IDPopupView.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDView.h"

/*!
 @class IDPopupView
 @abstract Extends IDView for popup specific behavior
 @discussion This class is a subclass of IDView and extends its superclass with popup specific behavior like showing or dismissing the popup
 */

@interface IDPopupView : IDView

/*!
 @discussion The designated initializer.
 */
- (id)initWithHmiState:(NSInteger)hmiState
            titleModel:(IDModel *)titleModel
            focusEvent:(NSInteger)focusEvent
            popupEvent:(NSInteger)popupEvent;

/*!
 @discussion Legacy initializer for compatibility reasons.
 */
- (id)initWithHmiState:(NSInteger)hmiState
          titleModelId:(NSInteger)titleModelId
            focusEvent:(NSInteger)focusEvent
            popupEvent:(NSInteger)popupEvent __attribute__((deprecated));

- (void)show;
- (void)dismiss;

@end
