/*  
 *  IDImageDataBundle.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <UIKit/UIKit.h>

@class IDImageData;

@interface IDImageDataBundle : NSObject

/*!
 @abstract Create an IDImageData object from the main application bundle by name and type.
 @discussion If this method is called before or within -(void)viewWillLoad of IDView, then the image referenced will be add to the zip file sent to the car. If this method
             is called after -(void)viewWillLoad, then the image will be sent to the car dynamically as NSData. If this method has previously been called for the given 
             image name and type, then the image will not be doubly added to the zip file.
 @param name and type of image
 @return an instance of IDImageData or nil if initialization did fail
 */
- (IDImageData *)imageWithName:(NSString *)imageName type:(NSString *)type;

/*!
 @abstract Create an IDImageData object from an NSData object
 @discussion The points discussed above apply to this function as well. This function does not look up an image by name in the bundle, but assigns an arbitrary name and 
             type to the image. Thus, after calling this method in -(void)viewWillLoad, the above method can be used to request an IDImageData object for this image 
             without needing to hold onto the data for the image.
 @param data of an image and an arbitrary name and type
 @return an instance of IDImageData or nil if initialization did fail
 */
- (IDImageData *)imageWithData:(NSData *)data name:(NSString *)imageName type:(NSString *)fileType;

/*!
 @abstract Create an IDImageData object from an NSData object
 @discussion Unlike the above functions, this function never adds an image to the zip file, it simply sends data for an image dynamically to the car.
 @param data of an image
 @return an instance of IDImageData or nil if initialization did fail
 */
- (IDImageData *)imageWithData:(NSData *)data;


@end
