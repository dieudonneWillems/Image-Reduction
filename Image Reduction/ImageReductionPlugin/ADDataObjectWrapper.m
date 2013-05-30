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
        type = tp;
        dataObject = object;
    }
    return self;
}

@synthesize dataObject;
@synthesize type;

- (NSString*) filename
{
    return filename;
}

- (void) setFilename:(NSString *)nname
{
    filename = nname;
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
@end
