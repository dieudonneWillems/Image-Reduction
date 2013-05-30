//
//  ADDataObjectWrapper.m
//  Image Reduction
//
//  Created by Don Willems on 29-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADDataObjectWrapper.h"
#import "ImageReductionPlugin.h"

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

@synthesize dataObject;
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
    return thumbnail;
}

- (void) setThumbnail:(NSImage *)nthumbnail
{
    thumbnail = nthumbnail;
    [self postUpdateDataObjectNotification];
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
