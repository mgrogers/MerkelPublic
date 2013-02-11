/*  
 *  CDSPropertyDefinesVehicle.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2011 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @const      CDSVehicleLanguage
 @abstract   This field returns information about the current language setting in the vehicle.
 @discussion (vehicle.language) Stored in response key "language" as a enum of type eCDSVehicleLanguage.
 */
extern NSString * const CDSVehicleLanguage;
enum eCDSVehicleLanguage
{
    CDSVehicleLanguage_NOLANGUAGE = 0,
    CDSVehicleLanguage_DEUTSCH = 1,
    CDSVehicleLanguage_ENGLISHUK = 2,
    CDSVehicleLanguage_ENGLISHUS = 3,
    CDSVehicleLanguage_SPANISH = 4,
    CDSVehicleLanguage_ITALIAN = 5,
    CDSVehicleLanguage_FRENCH = 6,
    CDSVehicleLanguage_FLEMISH = 7,
    CDSVehicleLanguage_DUTCH = 8,
    CDSVehicleLanguage_ARABIC = 9,
    CDSVehicleLanguage_CHINESETRADITIONAL = 10,
    CDSVehicleLanguage_CHINESESIMPLE = 11,
    CDSVehicleLanguage_KOREAN = 12,
    CDSVehicleLanguage_JAPANESE = 13,
    CDSVehicleLanguage_RUSSIAN = 14,
    CDSVehicleLanguage_FRENCHCANADIAN = 15,
    CDSVehicleLanguage_SPANISHMEXICO = 16,
    CDSVehicleLanguage_PORTUGESE = 17,
    CDSVehicleLanguage_POLISH = 18,
    CDSVehicleLanguage_GREEK = 19,
    CDSVehicleLanguage_TURKISH = 20,
    CDSVehicleLanguage_HUNGARIAN = 21,
    CDSVehicleLanguage_ROMANIAN = 22,
    CDSVehicleLanguage_SWEDISH = 23,
    CDSVehicleLanguage_INVALID = 255
};

/*!
 @const      CDSVehicleTime
 @abstract   This returns information regarding the vehicle's customer clock in terms of day, hour, minute, seconds, etc.
 @discussion (vehicle.time) Stored in response key "time" as a dictionary with keys "hour", "minute", "second", "date", "month", "weekday", and "year".
 "hour", "minute", "second", "date", "month", and "year" are numbers except for possible values for weekday are: CDSVehicleTimeWeekday_MONDAY, CDSVehicleTimeWeekday_TUESDAY, CDSVehicleTimeWeekday_WEDNESDAY, CDSVehicleTimeWeekday_THURSDAY, CDSVehicleTimeWeekday_FRIDAY, CDSVehicleTimeWeekday_SATURDAY, CDSVehicleTimeWeekday_SUNDAY, CDSVehicleTimeWeekday_INVALID NOTE: the weekday values will not be available in all vehicles please do not rely on the weekday value. 
 */
extern NSString * const CDSVehicleTime;
enum eCDSVehicleTime
{
    CDSVehicleTimeWeekday_MONDAY = 0,
    CDSVehicleTimeWeekday_TUESDAY = 1,
    CDSVehicleTimeWeekday_WEDNESDAY = 2,
    CDSVehicleTimeWeekday_THURSDAY = 3,
    CDSVehicleTimeWeekday_FRIDAY = 4,
    CDSVehicleTimeWeekday_SATURDAY = 5,
    CDSVehicleTimeWeekday_SUNDAY = 6,
    CDSVehicleTimeWeekday_INVALID = 7
};

/*!
 @const      CDSVehicleType
 @abstract   This returns information regarding the BMW or MINI vehicle type as the model E, F, RR or R code.
 @discussion (vehicle.type) Stored in response key "type" as an enumeration with the possible values:
 CDSVehicleType_E93, CDSVehicleType_E92, CDSVehicleType_E91, CDSVehicleType_E87, CDSVehicleType_E82, CDSVehicleType_E81, CDSVehicleType_RR01, CDSVehicleType_E90, CDSVehicleType_E64, CDSVehicleType_E63, CDSVehicleType_E61, CDSVehicleType_E60, CDSVehicleType_E67, CDSVehicleType_E66, CDSVehicleType_E65, CDSVehicleType_NOINFO, CDSVehicleType_F13, CDSVehicleType_F12, CDSVehicleType_F11, CDSVehicleType_10, CDSVehicleType_F07, CDSVehicleType_F03, CDSVehicleType_F02, CDSVehicleType_F01, CDSVehicleType_E72, CDSVehicleType_E89, CDSVehicleType_R57, CDSVehicleType_R56, CDSVehicleType_R55, CDSVehicleType_E88, CDSVehicleType_E71, CDSVehicleType_E70, CDSVehicleType_RR4, CDSVehicleType_R60, CDSVehicleType_F25, CDSVehicleType_E84, CDSVehicleType_F23, CDSVehicleType_F22, CDSVehicleType_F30, CDSVehicleType_F20, CDSVehicleType_F33, CDSVehicleType_F32, CDSVehicleType_F31, CDSVehicleType_F04, CDSVehicleType_INVALID
 */
extern NSString * const CDSVehicleType;
enum eCDSVehicleType
{
    CDSVehicleType_NOINFO = 0,
    CDSVehicleType_E65 = 1,
    CDSVehicleType_E66 = 2,
    CDSVehicleType_E67 = 3,
    CDSVehicleType_E60 = 4,
    CDSVehicleType_E61 = 5,
    CDSVehicleType_E63 = 6,
    CDSVehicleType_E64 = 7,
    CDSVehicleType_E90 = 8,
    CDSVehicleType_RR01 = 9,
    CDSVehicleType_E81 = 10,
    CDSVehicleType_E82 = 11,
    CDSVehicleType_E87 = 12,
    CDSVehicleType_E91 = 13,
    CDSVehicleType_E92 = 14,
    CDSVehicleType_E93 = 15,
    CDSVehicleType_E70 = 16,
    CDSVehicleType_E71 = 17,
    CDSVehicleType_E88 = 18,
    CDSVehicleType_R55 = 19,
    CDSVehicleType_R56 = 20,
    CDSVehicleType_R57 = 21,
    CDSVehicleType_E89 = 22,
    CDSVehicleType_E72 = 23,
    CDSVehicleType_F01 = 24,
    CDSVehicleType_F02 = 25,
    CDSVehicleType_F03 = 26,
    CDSVehicleType_F07 = 27,
    CDSVehicleType_F10 = 28,
    CDSVehicleType_F11 = 29,
    CDSVehicleType_F12 = 30,
    CDSVehicleType_F13 = 31,
    CDSVehicleType_F04 = 32,
    CDSVehicleType_F31 = 33,
    CDSVehicleType_F32 = 34,
    CDSVehicleType_F33 = 35,
    CDSVehicleType_F20 = 36,
    CDSVehicleType_F30 = 37,
    CDSVehicleType_F22 = 38,
    CDSVehicleType_F23 = 39,
    CDSVehicleType_E84 = 40,
    CDSVehicleType_F25 = 41,
    CDSVehicleType_R60 = 42,
    CDSVehicleType_RR4 = 43,
    CDSVehicleType_INVALID = 255
};

/*!
 @const      CDSVehicleUnits
 @abstract   This field returns information about the current unit settings in the vehicle for airPressure, fuel consumption, date display units, distance, fuel volume, temperature and time.
 @discussion (vehicle.units) Stored in response key "units" as a dictionary with keys "airPressure" "consumption", "date", "distance", "fuel", "time", "temperature", .  All are enumerations.
 Possible values for airPressure are: CDSVehicleUnitsAirPressure_DEFAULT, CDSVehicleUnitsAirPressure_BAR, CDSVehicleUnitsAirPressure_KPA, CDSVehicleUnitsAirPressure_PSI, CDSVehicleUnitsAirPressure_INVALID 
 Possile values for consumption are: CDSVehicleUnitsConsumption_DEFAULT, CDSVehicleUnitsConsumption_L100KM, CDSVehicleUnitsConsumption_MPGUK, CDSVehicleUnitsConsumption_MPGUS, CDSVehicleUnitsConsumption_KML, CDSVehicleUnitsConsumption_INVALID
 Possible values for date are: CDSVehicleUnitsDate_DEFAULT, CDSVehicleUnitsDate_DMY, CDSVehicleUnitsDate_MDY, CDSVehicleUnitsDate_INVALID
 Possible values for distance are: CDSVehicleUnitsDistance_DEFAULT, CDSVehicleUnitsDistance_KM, CDSVehicleUnitsDistance_MI, CDSVehicleUnitsDistance_INVALID
 Possible values for fuel are: CDSVehicleUnitsFuel_DEFAULT, CDSVehicleUnitsFuel_LITER, CDSVehicleUnitsFuel_GALONUK, CDSVehicleUnitsFuel_GALONUS, CDSVehicleUnitsFuel_INVALID
 Possible values for temperature are: CDSVehicleUnitsTemperature_DEFAULT, CDSVehicleUnitsTemperature_C, CDSVehicleUnitsTemperature_F, CDSVehicleUnitsTemperature_INVALID
 Possible values for time are: CDSVehicleUnitsTime_DEFAULT, CDSVehicleUnitsTime_12H, CDSVehicleUnitsTime_24H, CDSVehicleUnitsTime_INVALID
 */
extern NSString * const CDSVehicleUnits;
enum eCDSVehicleUnitsAirPressure
{
    CDSVehicleUnitsAirPressure_DEFAULT = 0,
    CDSVehicleUnitsAirPressure_BAR = 1,
    CDSVehicleUnitsAirPressure_KPA = 2,
    CDSVehicleUnitsAirPressure_PSI = 3,
    CDSVehicleUnitsAirPressure_INVALID = 7
};
enum eCDSVehicleUnitsConsumption
{
    CDSVehicleUnitsConsumption_DEFAULT = 0,
    CDSVehicleUnitsConsumption_L100KM = 1,
    CDSVehicleUnitsConsumption_MPGUK = 2,
    CDSVehicleUnitsConsumption_MPGUS = 3,
    CDSVehicleUnitsConsumption_KML = 4,
    CDSVehicleUnitsConsumption_INVALID = 7
};
enum eCDSVehicleUnitsDate
{
    CDSVehicleUnitsDate_DEFAULT = 0,
    CDSVehicleUnitsDate_DMY = 1,
    CDSVehicleUnitsDate_MDY = 2,
    CDSVehicleUnitsDate_INVALID = 3
};
enum eCDSVehicleUnitsDistance
{
    CDSVehicleUnitsDistance_DEFAULT = 0,
    CDSVehicleUnitsDistance_KM = 1,
    CDSVehicleUnitsDistance_MI = 2,
    CDSVehicleUnitsDistance_INVALID = 3
};
enum eCDSVehicleUnitsFuel
{
    CDSVehicleUnitsFuel_DEFAULT = 0,
    CDSVehicleUnitsFuel_LITER = 1,
    CDSVehicleUnitsFuel_GALONUK = 2,
    CDSVehicleUnitsFuel_GALONUS = 3,
    CDSVehicleUnitsFuel_INVALID = 7
};
enum eCDSVehicleUnitsTemperature
{
    CDSVehicleUnitsTemperature_DEFAULT = 0,
    CDSVehicleUnitsTemperature_C = 1,
    CDSVehicleUnitsTemperature_F = 2,
    CDSVehicleUnitsTemperature_INVALID = 3
};
enum eCDSVehicleUnitsTime
{
    CDSVehicleUnitsTime_DEFAULT = 0,
    CDSVehicleUnitsTime_12H = 1,
    CDSVehicleUnitsTime_24H = 2,
    CDSVehicleUnitsTime_INVALID = 3
};

/*!
 @const      CDSVehicleUnitSpeed
 @abstract   This returns information regarding the units for the vehicle speed.  It does not affect the speedActual or speedDisplayed return value as these units are always set, but rather distinguishes the users preference for speed display units
 @discussion (vehicle.unitSpeed) Stored in response key "unitSpeed" as an enumeration with possible values: CDSVehicleUnitSpeed_KMH, CDSVehicleUnitSpeed_MPH, CDSVehicleUnitSpeed_INVALID
 */
extern NSString *const CDSVehicleUnitSpeed;
enum eCDSVehicleUnitSpeed
{
    CDSVehicleUnitSpeed_KMH = 0,
    CDSVehicleUnitSpeed_MPH = 1,
    CDSVehicleUnitSpeed_INVALID = 2
};

