/*  
 *  IDModel.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


typedef enum {
    IDModelTypeUnknown = 0,
    IDModelTypeData, // for text data and image data
    IDModelTypeTextId,
    IDModelTypeImageId,
    IDModelTypeList,
    IDModelTypeInteger, // or IDModelTypeTargetId used to set the target HMI state for HMI actions
    IDModelTypeBoolModel, // for Checkboxes
    IDModelTypeGauge
} IDModelType;

@interface IDModel : NSObject

+ (id)modelWithId:(NSInteger)identifier type:(IDModelType)type implicit:(BOOL)implicit;
- (id)initWithId:(NSInteger)identifier type:(IDModelType)type implicit:(BOOL)implicit;

@property (readonly) NSInteger identifier;
@property (readonly) IDModelType type;
@property (readonly) BOOL implicit;

@end
