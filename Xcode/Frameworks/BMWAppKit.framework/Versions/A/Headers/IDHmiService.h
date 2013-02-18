/*  
 *  IDHmiService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDService.h"
#import "IDPropertyTypes.h"
#import "IDEventHandler.h"


@class IDVariantData;
@class IDVariantMap;
@class IDTableData;
@class IDVersionInfo;


/*!
 @class IDHmiService
 */
@interface IDHmiService : IDService <IDEventHandler>

@property (retain, readonly) NSString* name;
@property (retain, readonly) NSString* vendor;
@property (retain, readonly) IDVersionInfo* version;
@property (retain, readonly) NSDictionary *hmiCapabilities;

- (BOOL)startWithHmiDescription:(NSData *)hmiDescription
                  textDatabases:(NSArray *)textDatabases
                 imageDatabases:(NSArray *)imageDatabases
                          error:(NSError **)error;

- (void)addHandlerForHmiEvent:(NSUInteger)eventId
                    component:(NSUInteger)componentId
                       target:(id)target
                     selector:(SEL)selector;

- (void)addHandlerForActionEvent:(NSUInteger)actionId
                          target:(id)target
                        selector:(SEL)selector;

- (void)removeHandlerForHmiEvent:(NSUInteger)eventId
                       component:(NSUInteger)componentId
                          target:(id)target
                        selector:(SEL)selector;

- (void)removeHandlerForActionEvent:(NSUInteger)actionId
                             target:(id)target
                           selector:(SEL)selector;

- (void)setDataModel:(NSInteger)modelId
         variantData:(IDVariantData*)data
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

- (void)setListModel:(NSInteger)modelId
           tableData:(IDTableData*)data
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

- (void)setListModel:(NSInteger)modelId
           tableData:(IDTableData*)data
             fromRow:(NSUInteger)fromRow
                rows:(NSUInteger)rows
          fromColumn:(NSUInteger)fromColumn
             columns:(NSUInteger)columns
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

- (void)setListModel:(NSInteger)modelId
           tableData:(IDTableData*)data
             fromRow:(NSUInteger)fromRow
                rows:(NSUInteger)rows
          fromColumn:(NSUInteger)fromColumn
             columns:(NSUInteger)columns
           totalRows:(NSUInteger)totalRows
        totalColumns:(NSUInteger)totalColumns
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

- (void)setProperty:(IDPropertyType)propertyId
       forComponent:(NSInteger)componentId
         variantMap:(IDVariantMap*)map
    completionBlock:(IDServiceCallCompletionBlock)completionBlock;

- (void)setComponent:(NSInteger)modelId
             visible:(BOOL)visible
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

- (void)triggerHmiEvent:(NSUInteger)eventId
        completionBlock:(IDServiceCallCompletionBlock)completionBlock;

- (void)triggerHmiEvent:(NSUInteger)eventId
           parameterMap:(IDVariantMap*)params
        completionBlock:(IDServiceCallCompletionBlock)completionBlock;

@end
