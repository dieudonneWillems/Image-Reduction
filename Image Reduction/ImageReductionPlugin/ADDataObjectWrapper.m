//
//  ADDataObjectWrapper.m
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
//  Created by Don Willems on 29-05-13.
//
//

#import "ADDataObjectWrapper.h"
#import "ImageReductionPlugin.h"

static NSDictionary *_thattr;

@interface ADDataObjectWrapper (private)
- (id) initWithDataObject:(id<ADDataObject>)object ofType:(NSString*)tp;
@end

@implementation ADDataObjectWrapper

+ (ADDataObjectWrapper*) createWrapperForDataObject:(id<ADDataObject>)object ofType:(NSString*)tp
{
    return [[ADDataObjectWrapper alloc] initWithDataObject:object ofType:tp];
}

- (id) initWithDataObject:(id<ADDataObject>)object ofType:(NSString*)tp
{
    self = [super init];
    if(self){
        properties = [NSMutableDictionary dictionary];
        type = tp;
        dataObject = object;
        ADProperty *otype = [ADProperty typePropertyWithValueKey:tp];
        [properties setObject:otype forKey:[otype propertyKey]];
      //  [self createThumbnail];
    }
    return self;
}

- (id) initFromDictionary:(NSDictionary*)dict
{
    self = [super init];
    if(self){
        properties = [NSMutableDictionary dictionary];
        filename = [dict objectForKey:@"ADFileName"];
        originalFilename = [dict objectForKey:@"ADOriginalFileName"];
        type = [dict objectForKey:@"ADType"];
        NSData* tndata = (NSData*)[dict objectForKey:@"ADThumbnail"];
        if(tndata) thumbnail = [[NSImage alloc] initWithData:tndata];
        NSArray *prps = [dict objectForKey:@"ADProperties"];
        for(NSDictionary *prp in prps){
            ADProperty *prop = [[ADProperty alloc] initWithSerializedDictionary:prp];
            [properties setObject:prop forKey:[prop propertyKey]];
        }
    }
    return self;
}

- (NSDictionary*) serializeToDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:filename forKey:@"ADFileName"];
    if(originalFilename){
        [dict setObject:originalFilename forKey:@"ADOriginalFileName"];
    }
    [dict setObject:type forKey:@"ADType"];
    if(thumbnail){
        NSData *tndata = [thumbnail TIFFRepresentation];
        [dict setObject:tndata forKey:@"ADThumbnail"];
    }
    NSMutableArray *prps = [NSMutableArray array];
    NSArray *prpks = [properties allValues];
    for(ADProperty *prop in prpks){
        NSDictionary *prpd = [prop serializableDictionary];
        [prps addObject:prpd];
    }
    [dict setObject:prps forKey:@"ADProperties"];
    return dict;
}

- (id<ADDataObject>) dataObject
{
    return dataObject;
}

- (void) setDataObject:(id<ADDataObject>)ndataObject
{
    dataObject = ndataObject;
    [self createThumbnail];
    [self postUpdateDataObjectNotification];
}

- (void) createThumbnail
{
    if([dataObject isKindOfClass:[ADImage class]]){
        ADImage *image = (ADImage*)dataObject;
        [image recreateImageWithDefaultScaling];
        thumbnail = [[NSImage alloc] initWithSize:NSMakeSize(32, 32)];
        [thumbnail lockFocus];
        NSRect thn;
        thn.origin = NSZeroPoint;
        thn.size = [thumbnail size];
        NSRect ori;
        ori.origin = NSZeroPoint;
        ori.size = [image size];
        [image drawInRect:thn fromRect:ori operation:NSCompositeCopy fraction:1.0];
        ADProperty *it = [self propertyForKey:ADPropertyImageType];
        NSString *kval = [it propertyValueKey];
        NSColor *strcol = nil;
        NSString *str = nil;
        if([kval isEqualToString:ADPropertyImageTypeBias]){
            strcol = [NSColor colorWithCalibratedRed:0 green:0.7 blue:0.7 alpha:0.5];
            str = @"BIAS";
        }else if([kval isEqualToString:ADPropertyImageTypeDark]){
            strcol = [NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.7 alpha:0.5];
            str = @"DARK";
        }else if([kval isEqualToString:ADPropertyImageTypeFlat]){
            strcol = [NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.0 alpha:0.5];
            str = @"FLAT";
        }else if([kval isEqualToString:ADPropertyImageTypeMasterFlat]){
            strcol = [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.0 alpha:0.5];
            str = @"MFLAT";
        }else if([kval isEqualToString:ADPropertyImageTypeStacked]){
            strcol = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:0.5];
            str = @"STACK";
        }else if([kval isEqualToString:ADPropertyImageTypeCalibrated]){
            strcol = [NSColor colorWithCalibratedRed:0.0 green:1.0 blue:0.0 alpha:0.5];
            str = @"CALIB";
        }
        if(strcol){
            [strcol set];
            NSRect strrect = NSMakeRect(0, 2, 32, 9);
            NSBezierPath *bp = [NSBezierPath bezierPathWithRect:strrect];
            [bp fill];
            if(!_thattr){
                _thattr = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0],NSForegroundColorAttributeName,[NSFont boldSystemFontOfSize:8],NSFontAttributeName, nil];
            }
            NSSize size = [str sizeWithAttributes:_thattr];
            NSPoint strp;
            strp.x = strrect.origin.x+(strrect.size.width-size.width)/2;
            strp.y = strrect.origin.y+(strrect.size.height-size.height)/2;
            [str drawAtPoint:strp withAttributes:_thattr];
        }
        [thumbnail unlockFocus];
    }
}

@synthesize type;

- (void) bundleFilenameFromOriginalFilename:(NSString*)original withSeed:(NSUInteger)seed
{
    originalFilename = original;
    NSMutableString *ext = [NSMutableString string];
    NSInteger nrz = 5-(NSInteger)log10(seed);
    NSInteger i;
    for(i=0;i<nrz;i++){
        [ext appendString:@"0"];
    }
    [ext appendFormat:@"%ld",seed];
    [properties setObject:[ADProperty propertyOfType:ADPropertyOriginalFilename withStringValue:original] forKey:ADPropertyOriginalFilename];
    filename = [[[originalFilename lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:ext];
    [properties setObject:[ADProperty propertyOfType:ADPropertyFilename withStringValue:filename] forKey:ADPropertyFilename];
    [self postUpdateDataObjectNotification];
}

- (NSString*) filename
{
    return filename;
}

- (void) setFilename:(NSString *)nname
{
    filename = nname;
    [properties setObject:[ADProperty propertyOfType:ADPropertyFilename withStringValue:nname] forKey:ADPropertyFilename];
    [self postUpdateDataObjectNotification];
}

- (NSString*) originalFilename
{
    return originalFilename;
}

- (void) setOriginalFilename:(NSString *)nname
{
    originalFilename = nname;
    [properties setObject:[ADProperty propertyOfType:ADPropertyOriginalFilename withStringValue:nname] forKey:ADPropertyOriginalFilename];
    [self postUpdateDataObjectNotification];
}

- (NSImage*) thumbnail
{
    if(!thumbnail && dataObject) [self createThumbnail];
    return thumbnail;
}

- (void) setThumbnail:(NSImage *)nthumbnail
{
    thumbnail = nthumbnail;
    [self postUpdateDataObjectNotification];
}

- (BOOL) dataObjectIsLoaded
{
    return (dataObject!=nil);
}

- (BOOL) loadDataObjectFromBundleAtPath:(NSString*)bundlepath
{
    NSString *path = nil;
    if(bundlepath==nil) return NO;
    if([[bundlepath lastPathComponent] isEqualToString:@"data"]){
        path = [bundlepath stringByAppendingPathComponent:filename];
    }else{
        path = [[bundlepath stringByAppendingPathComponent:@"data"] stringByAppendingPathComponent:filename];
    }
    NSLog(@"loading dataobject from: %@",path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    if([type isEqualToString:ADPropertyTypeImage]){
        dataObject = [[ADImage alloc] initWithData:data];
    } // todo Add loading of tables, plots, ...
    return (dataObject!=nil);
}

- (NSArray*) properties
{
    return [properties allValues];
}

- (ADProperty*) propertyForKey:(NSString*)propertyKey
{
    return [properties objectForKey:propertyKey];
}

- (void) addProperty:(ADProperty*)property
{
    [properties setObject:property forKey:[property propertyKey]];
    [self postUpdateDataObjectNotification];
}

- (void) addPropertiesFromArray:(NSArray*)props
{
    for(ADProperty* prop in props){
        [properties setObject:prop forKey:[prop propertyKey]];
    }
    [self postUpdateDataObjectNotification];
}

- (void) postUpdateDataObjectNotification
{
    NSNotification *not = [NSNotification notificationWithName:ADDataObjectUpdatedNotification object:self userInfo:[NSDictionary dictionaryWithObject:self forKey:ADUpdatedDataObject]];
    [[NSNotificationCenter defaultCenter] postOnMainThreadNotification:not];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"ADDataObjectWrapper <%@>",[self filename]];
}
@end
