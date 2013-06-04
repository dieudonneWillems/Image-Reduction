//
//  ADProperties.m
//
// 	This file is part of Image Reduction.
//
//    Image Reduction is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Image Reduction is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Image Reduction.  If not, see <http://www.gnu.org/licenses/>.
//
//  Copyright (c) 2013 Dieudonné Willems. All rights reserved.
//
//
//  Created by Don Willems on 27-05-13.
//
//

#import "ADProperty.h"

NSString * const ADPropertyFilename = @"ADPropertyFilename";
NSString * const ADPropertyOriginalFilename = @"ADPropertyOriginalFilename";

NSString * const ADPropertyType = @"ADPropertyType";
NSString * const ADPropertyTypeImage = @"ADPropertyTypeImage";
NSString * const ADPropertyTypeTable = @"ADPropertyTypeTable";
NSString * const ADPropertyTypePlot = @"ADPropertyTypePlot";

NSString * const ADPropertyImageType = @"ADPropertyImageType";
NSString * const ADPropertyImageTypeUnknown = @"ADPropertyImageTypeUnknown";
NSString * const ADPropertyImageTypeRaw = @"ADPropertyImageTypeRaw";
NSString * const ADPropertyImageTypeBias = @"ADPropertyImageTypeBias";
NSString * const ADPropertyImageTypeFlat = @"ADPropertyImageTypeFlat";
NSString * const ADPropertyImageTypeDark = @"ADPropertyImageTypeDark";
NSString * const ADPropertyImageTypeMasterFlat = @"ADPropertyImageTypeMasterFlat";
NSString * const ADPropertyImageTypeCalibrated = @"ADPropertyImageTypeCalibrated";
NSString * const ADPropertyImageTypeStacked = @"ADPropertyImageTypeStacked";

double const ADUnknownValue = NAN;
double const ADUnknownErrorValue = NAN;

@interface ADProperty (private)
- (id) initWithKey:(NSString*)propKey valueKey:(NSString*)valKey;
- (id) initWithKey:(NSString *)propKey stringValue:(NSString *)str;
- (id) initWithKey:(NSString *)propKey doubleValue:(double)value units:(NSString*)units positiveError:(double)posError negativeError:(double)negError;
- (id) initWithKey:(NSString *)propKey floatValue:(CGFloat)value units:(NSString*)units positiveError:(CGFloat)posError negativeError:(CGFloat)negError;
- (id) initWithKey:(NSString *)propKey integerValue:(NSInteger)value;
@end

@implementation ADProperty

+ (ADProperty*) typePropertyWithValueKey:(NSString*)valueKey
{
    return [ADProperty propertyOfType:ADPropertyType withValueKey:valueKey];
}

+ (ADProperty*) imageTypePropertyWithValueKey:(NSString*)valueKey
{
    return [ADProperty propertyOfType:ADPropertyImageType withValueKey:valueKey];
}


+ (ADProperty*) propertyOfType:(NSString*)typekey withValueKey:(NSString*)valueKey
{
    return [[ADProperty alloc] initWithKey:typekey valueKey:valueKey];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withStringValue:(NSString*)str
{
    return [[ADProperty alloc] initWithKey:typekey stringValue:str];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withDoubleValue:(double)value inUnits:(NSString*)unitkey
{
    return [[ADProperty alloc] initWithKey:typekey doubleValue:value units:unitkey positiveError:ADUnknownErrorValue negativeError:ADUnknownErrorValue];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withDoubleValue:(double)value inUnits:(NSString*)unitkey withError:(double)error
{
    return [[ADProperty alloc] initWithKey:typekey doubleValue:value units:unitkey positiveError:error negativeError:error];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withDoubleValue:(double)value inUnits:(NSString*)unitkey withPositiveError:(double)posError andNegativeError:(double)negError
{
    return [[ADProperty alloc] initWithKey:typekey doubleValue:value units:unitkey positiveError:posError negativeError:negError];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withFloatValue:(CGFloat)value inUnits:(NSString*)unitkey
{
    return [[ADProperty alloc] initWithKey:typekey floatValue:value units:unitkey positiveError:ADUnknownErrorValue negativeError:ADUnknownErrorValue];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withFloatValue:(CGFloat)value inUnits:(NSString*)unitkey withError:(CGFloat)error
{
    return [[ADProperty alloc] initWithKey:typekey floatValue:value units:unitkey positiveError:error negativeError:error];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withFloatValue:(CGFloat)value inUnits:(NSString*)unitkey withPositiveError:(CGFloat)posError andNegativeError:(CGFloat)negError
{
    return [[ADProperty alloc] initWithKey:typekey floatValue:value units:unitkey positiveError:posError negativeError:negError];
}

+ (ADProperty*) propertyOfType:(NSString *)typekey withIntegerValue:(NSInteger)value
{
    return [[ADProperty alloc] initWithKey:typekey integerValue:value];
}


- (id) initWithKey:(NSString*)propKey valueKey:(NSString*)valKey
{
    self = [super init];
    if(self){
        propertyKey = propKey;
        propertyValueKey = valKey;
        stringValue = nil;
        unitKey = nil;
        doubleValue = ADUnknownValue;
        floatValue = ADUnknownValue;
        integerValue = ADUnknownValue;
        doublePositiveErrorValue = ADUnknownErrorValue;
        doubleNegativeErrorValue = ADUnknownErrorValue;
        floatPositiveErrorValue = ADUnknownErrorValue;
        floatNegativeErrorValue = ADUnknownErrorValue;
        dataType = ADPropertyDataTypeConstrainedValue;
    }
    return self;
}

- (id) initWithKey:(NSString *)propKey stringValue:(NSString *)str
{
    self = [super init];
    if(self){
        propertyKey = propKey;
        propertyValueKey = nil;
        stringValue = str;
        unitKey = nil;
        doubleValue = ADUnknownValue;
        floatValue = ADUnknownValue;
        integerValue = ADUnknownValue;
        doublePositiveErrorValue = ADUnknownErrorValue;
        doubleNegativeErrorValue = ADUnknownErrorValue;
        floatPositiveErrorValue = ADUnknownErrorValue;
        floatNegativeErrorValue = ADUnknownErrorValue;
        dataType = ADPropertyDataTypeString;
    }
    return self;
}

- (id) initWithKey:(NSString *)propKey doubleValue:(double)value units:(NSString*)units positiveError:(double)posError negativeError:(double)negError
{
    self = [super init];
    if(self){
        propertyKey = propKey;
        propertyValueKey = nil;
        stringValue = nil;
        unitKey = units;
        doubleValue = value;
        floatValue = ADUnknownValue;
        integerValue = ADUnknownValue;
        doublePositiveErrorValue = posError;
        doubleNegativeErrorValue = negError;
        floatPositiveErrorValue = ADUnknownErrorValue;
        floatNegativeErrorValue = ADUnknownErrorValue;
        dataType = ADPropertyDataTypeDouble;
    }
    return self;
}

- (id) initWithKey:(NSString *)propKey floatValue:(CGFloat)value units:(NSString*)units positiveError:(CGFloat)posError negativeError:(CGFloat)negError
{
    self = [super init];
    if(self){
        propertyKey = propKey;
        propertyValueKey = nil;
        stringValue = nil;
        unitKey = units;
        doubleValue = ADUnknownValue;
        floatValue = value;
        integerValue = ADUnknownValue;
        doublePositiveErrorValue = ADUnknownErrorValue;
        doubleNegativeErrorValue = ADUnknownErrorValue;
        floatPositiveErrorValue = posError;
        floatNegativeErrorValue = negError;
        dataType = ADPropertyDataTypeFloat;
    }
    return self;
}

- (id) initWithKey:(NSString *)propKey integerValue:(NSInteger)value
{
    self = [super init];
    if(self){
        propertyKey = propKey;
        propertyValueKey = nil;
        stringValue = nil;
        unitKey = nil;
        doubleValue = ADUnknownValue;
        floatValue = ADUnknownValue;
        integerValue = value;
        doublePositiveErrorValue = ADUnknownErrorValue;
        doubleNegativeErrorValue = ADUnknownErrorValue;
        floatPositiveErrorValue = ADUnknownErrorValue;
        floatNegativeErrorValue = ADUnknownErrorValue;
        dataType = ADPropertyDataTypeInteger;
    }
    return self;
}


- (id) initWithSerializedDictionary:(NSDictionary*)prop
{
    self = [super init];
    if(self){
        propertyKey = [prop objectForKey:@"ADPropertyKey"];
        dataType = (ADPropertyDataType)[[prop objectForKey:@"ADPropertyDataType"] shortValue];
        propertyValueKey = nil;
        stringValue = nil;
        unitKey = nil;
        doubleValue = ADUnknownValue;
        floatValue = ADUnknownValue;
        integerValue = ADUnknownValue;
        doublePositiveErrorValue = ADUnknownErrorValue;
        doubleNegativeErrorValue = ADUnknownErrorValue;
        floatPositiveErrorValue = ADUnknownErrorValue;
        floatNegativeErrorValue = ADUnknownErrorValue;
        NSNumber *en, *ep;
        switch (dataType) {
            case ADPropertyDataTypeConstrainedValue:
                propertyValueKey = [prop objectForKey:@"ADPropertyValue"];
                break;
            case ADPropertyDataTypeDouble:
                doubleValue = [(NSNumber*)[prop objectForKey:@"ADPropertyValue"] doubleValue];
                en = [prop objectForKey:@"ADPropertyNegativeError"];
                if(en) doubleNegativeErrorValue = [en doubleValue];
                ep = [prop objectForKey:@"ADPropertyPositiveError"];
                if(en) doublePositiveErrorValue = [ep doubleValue];
                unitKey = [prop objectForKey:@"ADPropertyUnit"];
                break;
            case ADPropertyDataTypeFloat:
                floatValue = [(NSNumber*)[prop objectForKey:@"ADPropertyValue"] floatValue];
                en = [prop objectForKey:@"ADPropertyNegativeError"];
                if(en) floatNegativeErrorValue = [en floatValue];
                ep = [prop objectForKey:@"ADPropertyPositiveError"];
                if(en) floatPositiveErrorValue = [ep floatValue];
                unitKey = [prop objectForKey:@"ADPropertyUnit"];
                break;
            case ADPropertyDataTypeInteger:
                integerValue = [[prop objectForKey:@"ADPropertyValue"] integerValue];
                break;
            case ADPropertyDataTypeString:
                stringValue = [prop objectForKey:@"ADPropertyValue"];
                break;
        }
    }
    return self;
}

@synthesize propertyKey;
@synthesize propertyValueKey;
@synthesize stringValue;
@synthesize doubleValue;
@synthesize floatValue;
@synthesize integerValue;
@synthesize unitKey;
@synthesize doublePositiveErrorValue;
@synthesize floatPositiveErrorValue;
@synthesize doubleNegativeErrorValue;
@synthesize floatNegativeErrorValue;
@synthesize dataType;

- (NSString*) valueDescription
{
    if(propertyValueKey) return propertyValueKey;
    if(stringValue) return [NSString stringWithFormat:@"'%@'",stringValue];
    if(integerValue!=ADUnknownValue) return [NSString stringWithFormat:@"%ld",integerValue];
    if(doubleValue!=ADUnknownValue) {
        NSString *errorstr = @"";
        if(doublePositiveErrorValue!=ADUnknownErrorValue && doublePositiveErrorValue==doubleNegativeErrorValue){
            errorstr = [NSString stringWithFormat:@" ±%f",doublePositiveErrorValue];
        }else if(doublePositiveErrorValue!=ADUnknownErrorValue){
            errorstr = [NSString stringWithFormat:@" +%f -%f",doublePositiveErrorValue,doubleNegativeErrorValue];
        }
        NSString *ustr = @"";
        if(unitKey){
            ustr = unitKey;
        }
        return [NSString stringWithFormat:@"%f%@ %@",doubleValue,errorstr,ustr];
    }
    if(floatValue!=ADUnknownValue) {
        NSString *errorstr = @"";
        if(floatPositiveErrorValue!=ADUnknownErrorValue && floatPositiveErrorValue==floatNegativeErrorValue){
            errorstr = [NSString stringWithFormat:@" ±%f",floatPositiveErrorValue];
        }else if(floatPositiveErrorValue!=ADUnknownErrorValue){
            errorstr = [NSString stringWithFormat:@" +%f -%f",floatPositiveErrorValue,floatNegativeErrorValue];
        }
        NSString *ustr = @"";
        if(unitKey){
            ustr = unitKey;
        }
        return [NSString stringWithFormat:@"%f%@ %@",doubleValue,errorstr,ustr];
    }
    return nil;
}

- (NSString*) description
{
    NSString *vdesc = [self valueDescription];
    return [NSString stringWithFormat:@"%@ = %@",propertyKey,vdesc];
}

- (NSDictionary*) serializableDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:propertyKey forKey:@"ADPropertyKey"];
    [dict setObject:[NSNumber numberWithShort:dataType] forKey:@"ADPropertyDataType"];
    switch (dataType) {
        case ADPropertyDataTypeConstrainedValue:
            [dict setObject:propertyValueKey forKey:@"ADPropertyValue"];
            break;
        case ADPropertyDataTypeString:
            [dict setObject:stringValue forKey:@"ADPropertyValue"];
            break;
        case ADPropertyDataTypeDouble:
            [dict setObject:[NSNumber numberWithDouble:doubleValue] forKey:@"ADPropertyValue"];
            if(doubleNegativeErrorValue!=ADUnknownErrorValue) [dict setObject:[NSNumber numberWithDouble:doubleNegativeErrorValue] forKey:@"ADPropertyNegativeError"];
            if(doublePositiveErrorValue!=ADUnknownErrorValue) [dict setObject:[NSNumber numberWithDouble:doublePositiveErrorValue] forKey:@"ADPropertyPositiveError"];
            if(unitKey) [dict setObject:unitKey forKey:@"ADPropertyUnit"];
            break;
        case ADPropertyDataTypeFloat:
            [dict setObject:[NSNumber numberWithFloat:floatValue] forKey:@"ADPropertyValue"];
            if(floatNegativeErrorValue!=ADUnknownErrorValue) [dict setObject:[NSNumber numberWithFloat:floatNegativeErrorValue] forKey:@"ADPropertyNegativeError"];
            if(floatPositiveErrorValue!=ADUnknownErrorValue) [dict setObject:[NSNumber numberWithFloat:floatPositiveErrorValue] forKey:@"ADPropertyPositiveError"];
            if(unitKey) [dict setObject:unitKey forKey:@"ADPropertyUnit"];
            break;
        case ADPropertyDataTypeInteger:
            [dict setObject:[NSNumber numberWithInteger:integerValue] forKey:@"ADPropertyValue"];
            break;
    }
    return dict;
}

@end