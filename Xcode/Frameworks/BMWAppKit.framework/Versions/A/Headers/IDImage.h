/*  
 *  IDImage.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"

@class IDImageData;

@interface IDImage : IDWidget

+ (id)image;

/*!
 @method setImageData:
 @abstract Update the image model of the image widget with the image data.
 @discussion The image data format could either be JPEG oder PNG. For PNG data alpha is supported.
 @param imageData the image data (@see IDImageData). Setting imageData to nil is equivalent to setting it to [IDImageData emptyImageData].
 */
- (void)setImageData:(IDImageData *)imageData clearWhileSending:(BOOL)clearWhileSending;

/*!
 * Set the image data.
 * (not KVO compliant)
 */
@property (nonatomic, retain) IDImageData *imageData;

/*!
 * Set the Image's position.
 * (not KVO compliant)
 */
@property (nonatomic, assign) CGPoint position;

@end
