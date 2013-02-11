/*  
 *  IDVersionInfo.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


/*!
 @class IDVersionInfo
 @abstract IDVersionInfo represents the version information used throughout the iDrive framework.
 */
@interface IDVersionInfo : NSObject
{
@private
    NSUInteger _major;
    NSUInteger _minor;
    NSUInteger _revision;
}

+ (IDVersionInfo*)versionInfoWithString:(NSString*)versionString;
+ (IDVersionInfo*)versionInfoWithMajor:(NSUInteger)major minor:(NSUInteger)minor revision:(NSUInteger)revision;
- (id)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor revision:(NSUInteger)revision;

/*!
 @property stringValue
 @abstract Returns a string representing the version in the form "<major>.<minor>.<revision>".
 */
- (NSString*)stringValue;

/*!
 * @abstract returns true when this version is equal to the other version 
 */
-(BOOL) isEqualToVersion:(IDVersionInfo*)otherVersion;

/*!
 * @abstract Returns a NSComparisonResult object indicating whether the receiver comes before or after the argument
 */
-(NSComparisonResult) compare:(IDVersionInfo*) otherVersion;

/*!
 @property major
 @abstract The major part of the version.
 */
@property (assign) NSUInteger major;

/*!
 @property minor
 @abstract The minor part of the version.
 */
@property (assign) NSUInteger minor;

/*!
 @property revision
 @abstract The revision part of the version.
 */
@property (assign) NSUInteger revision;

@end
