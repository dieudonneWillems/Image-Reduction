//
//  ADDataObjectWrapper.h
//  Image Reduction
//
//  Created by Don Willems on 29-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADProperty.h"
#import "ADDataObject.h"

@interface ADDataObjectWrapper : NSObject {
    NSString *filename;
    NSString *originalFilename;
    NSString *type;
    NSMutableDictionary *properties;
    NSImage *thumbnail;
}

+ (ADDataObjectWrapper*) createWrapperForDataObject:(id<ADDataObject>)object ofType:(NSString*)tp;

- (id) initFromDictionary:(NSDictionary*)dict;

@property (readonly) id<ADDataObject> dataObject;
@property (readwrite) NSString *filename;
@property (readwrite) NSString *originalFilename;
@property (readonly) NSString *type;
@property (readwrite) NSImage *thumbnail;

- (void) bundleFilenameFromOriginalFilename:(NSString*)original withSeed:(NSUInteger)seed;

- (NSArray*) properties;
- (ADProperty*) propertyForKey:(NSString*)propertyKey;
- (void) addProperty:(ADProperty*)property;
- (void) addPropertiesFromArray:(NSArray*)props;

- (void) postUpdateDataObjectNotification;

- (NSDictionary*) serializeToDictionary;
@end
