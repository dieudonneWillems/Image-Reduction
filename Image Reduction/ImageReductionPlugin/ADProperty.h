//
//  ADProperties.h
//  Image Reduction
//
//  Created by Don Willems on 27-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ADPropertyFilename;
extern NSString * const ADPropertyOriginalFilename;

extern NSString * const ADPropertyType;
// values
extern NSString * const ADPropertyTypeImage;
extern NSString * const ADPropertyTypeTable;
extern NSString * const ADPropertyTypePlot;


extern NSString * const ADPropertyImageType;
// values
extern NSString * const ADPropertyImageTypeUnknown;
extern NSString * const ADPropertyImageTypeRaw;
extern NSString * const ADPropertyImageTypeBias;
extern NSString * const ADPropertyImageTypeFlat;
extern NSString * const ADPropertyImageTypeDark;
extern NSString * const ADPropertyImageTypeMasterFlat;
extern NSString * const ADPropertyImageTypeCalibrated;
extern NSString * const ADPropertyImageTypeStacked;


extern double const ADUnknownValue;
extern double const ADUnknownErrorValue;

typedef enum __property_data_type {
    ADPropertyDataTypeConstrainedValue,
    ADPropertyDataTypeString,
    ADPropertyDataTypeDouble,
    ADPropertyDataTypeInteger,
    ADPropertyDataTypeFloat
} ADPropertyDataType;

@interface ADProperty : NSObject {
    NSString *propertyKey;
    NSString *propertyValueKey;
    NSString *stringValue;
    double doubleValue;
    NSInteger integerValue;
    CGFloat floatValue;
    NSString *unitKey;
    // error = ADUnknownErrorValue if unknown
    double doublePositiveErrorValue;
    double doubleNegativeErrorValue;
    CGFloat floatPositiveErrorValue;
    CGFloat floatNegativeErrorValue;
    ADPropertyDataType dataType;
}

+ (ADProperty*) typePropertyWithValueKey:(NSString*)valueKey;
+ (ADProperty*) imageTypePropertyWithValueKey:(NSString*)valueKey;

+ (ADProperty*) propertyOfType:(NSString*)typekey withValueKey:(NSString*)valueKey;
+ (ADProperty*) propertyOfType:(NSString *)typekey withStringValue:(NSString*)str;
+ (ADProperty*) propertyOfType:(NSString *)typekey withDoubleValue:(double)value inUnits:(NSString*)unitkey;
+ (ADProperty*) propertyOfType:(NSString *)typekey withDoubleValue:(double)value inUnits:(NSString*)unitkey withError:(double)error;
+ (ADProperty*) propertyOfType:(NSString *)typekey withDoubleValue:(double)value inUnits:(NSString*)unitkey withPositiveError:(double)posError andNegativeError:(double)negError;
+ (ADProperty*) propertyOfType:(NSString *)typekey withFloatValue:(CGFloat)value inUnits:(NSString*)unitkey;
+ (ADProperty*) propertyOfType:(NSString *)typekey withFloatValue:(CGFloat)value inUnits:(NSString*)unitkey withError:(CGFloat)error;
+ (ADProperty*) propertyOfType:(NSString *)typekey withFloatValue:(CGFloat)value inUnits:(NSString*)unitkey withPositiveError:(CGFloat)posError andNegativeError:(CGFloat)negError;
+ (ADProperty*) propertyOfType:(NSString *)typekey withIntegerValue:(NSInteger)value;

- (id) initWithSerializedDictionary:(NSDictionary*)prop;

@property (readonly) NSString *propertyKey;
@property (readonly) NSString *propertyValueKey;
@property (readonly) NSString *stringValue;
@property (readonly) double doubleValue;
@property (readonly) NSInteger integerValue;
@property (readonly) CGFloat floatValue;
@property (readonly) NSString *unitKey;
@property (readonly) double doublePositiveErrorValue;
@property (readonly) CGFloat floatPositiveErrorValue;
@property (readonly) double doubleNegativeErrorValue;
@property (readonly) CGFloat floatNegativeErrorValue;
@property (readonly) ADPropertyDataType dataType;

- (NSString*) valueDescription;

- (NSDictionary*) serializableDictionary;

@end