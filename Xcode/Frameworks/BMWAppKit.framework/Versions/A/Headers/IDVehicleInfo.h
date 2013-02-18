/*  
 *  IDVehicleInfo.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

/*!
 @class IDVehicleInfo
    IDVehicleInfo holds detailed information about the currently connected vehicle. This includes some details about the HMI.
 */
@interface IDVehicleInfo : NSObject

/*!
 @enum IDVehicleBrand
    Enumeration of supported vehicle brands.
 @constant IDVehicleBrandUnknown        unknown vehicle brand
 @constant IDVehicleBrandBMW            BMW brand
 @constant IDVehicleBrandMINI           MINI brand
 @constant IDVehicleBrandRollsRoyce     RollsRoyce brand
*/
typedef enum  {
    IDVehicleBrandUnknown = 0,
    IDVehicleBrandBMW,
    IDVehicleBrandMINI,
    IDVehicleBrandRollsRoyce
} IDVehicleBrand;

/*
 @enum IDVehicleCountry
    Enumeration of available vehicle countrys. This represents the country the vehicle was produced for. There is no connection to the language setting in the hmi.
 @constant IDVehicleCountryUnknown      unknown country
 @constant IDVehicleCountryGermany     "Deutschland"
 @constant IDVehicleCountryEgypt       "_gypten"
 @constant IDVehicleCountryAustralia   "Australien"
 @constant IDVehicleCountryChina       "China"
 @constant IDVehicleCountryECE         "ECE"
 @constant IDVehicleCountryHongKong    "Hongkong"
 @constant IDVehicleCountryJapan       "Japan"
 @constant IDVehicleCountryCanada      "Kanada"
 @constant IDVehicleCountryKorea       "Korea"
 @constant IDVehicleCountryTaiwan      "Taiwan"
 @constant IDVehicleCountryUSA         "US"
*/
typedef enum {
    IDVehicleCountryUnknown = 0,
    IDVehicleCountryGermany,
    IDVehicleCountryEgypt,
    IDVehicleCountryAustralia,
    IDVehicleCountryChina,
    IDVehicleCountryECE,
    IDVehicleCountryHongKong,
    IDVehicleCountryJapan,
    IDVehicleCountryCanada,
    IDVehicleCountryKorea,
    IDVehicleCountryTaiwan,
    IDVehicleCountryUSA
} IDVehicleCountry;

/*!
 @enum IDVehicleHmiVersion
    Enumeration of available HMI versions.
 @constant IDVehicleHmiVersionUnknown   No version information available.
 @constant IDVehicleHmiVersion1011      November 2010 release.
 @constant IDVehicleHmiVersion1103      March 2011 release.
 @constant IDVehicleHmiVersion1107      July 2011 release.
 @constant IDVehicleHmiVersion1111      November 2011 release.
 @constant IDVehicleHmiVersion1203      March 2012 release.
 @constant IDVehicleHmiVersion1207      July 2012 release.
 @constant IDVehicleHmiVersion1211      November 2012 release.
 */
typedef enum  {
    IDVehicleHmiVersionUnknown = 0,
    IDVehicleHmiVersion1011,
    IDVehicleHmiVersion1103,
    IDVehicleHmiVersion1107,
    IDVehicleHmiVersion1111,
    IDVehicleHmiVersion1203,
    IDVehicleHmiVersion1207,
    IDVehicleHmiVersion1211
} IDVehicleHmiVersion;

/*!
 @enum IDVehicleHmiType
    Enumeration of available HMI types.
 @constant IDVehicleHmiTypeUnknown      unknown hmi type
 @constant IDVehicleHmiTypeID4          ID4 (2D hmi)
 @constant IDVehicleHmiTypeID4PlusPlus  ID4++ (3D hmi)
 */
typedef enum {
    IDVehicleHmiTypeUnknown = 0,
    IDVehicleHmiTypeID4,
    IDVehicleHmiTypeID4PlusPlus
} IDVehicleHmiType;

/*!
 Enumeration of possible hmi skins.
 This is to be used for all UI related decisions.
 */
typedef enum {
    IDVehicleHmiSkinUnknown,
    IDVehicleHmiSkinBMW,
    IDVehicleHmiSkinMINI,
    IDVehicleHmiSkinRollsRoyce,
    IDVehicleHmiSkinBMW3D
} IDVehicleHmiSkin;

/*!
 IDVehicleInfo holds detailed information about the currently connected vehicle. This includes some details about the hmi.
 */

/*
 @property brand
 Returns the brand of the currently connected vehicle. (not KVO compliant)
 */
@property (nonatomic, readonly) IDVehicleBrand brand;

/*!
 @property hmiVersion
    Returns the hmi version of the currently connected vehicle. (not KVO compliant)
 */
@property (nonatomic, readonly) IDVehicleHmiVersion hmiVersion;

/*!
 @property hmiType
    Returns the hmi type of the currently connected vehicle. (not KVO compliant)
 */
@property (nonatomic, readonly) IDVehicleHmiType hmiType;

/*!
 @property country
    Returns the country of the currently connected vehciel. (not KVO compliant)
 */
@property (nonatomic, readonly) IDVehicleCountry country;
@property (nonatomic, readonly) IDVehicleHmiSkin hmiSkin; // Returns the hmi skin of the currently connected vehicle. (not KVO compliant)

@end
