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
    NSString *type;
    NSMutableDictionary *properties;
}

+ (ADDataObjectWrapper*) createWrapperForDataObject:(id<ADDataObject>)object ofType:(NSString*)tp;

@property (readonly) id<ADDataObject> dataObject;
@property (readwrite) NSString *filename;
@property (readonly) NSString *type;

- (NSArray*) properties;
- (ADProperty*) propertyForKey:(NSString*)propertyKey;
- (void) addProperty:(ADProperty*)property;
- (void) addPropertiesFromArray:(NSArray*)props;

- (void) postUpdateDataObjectNotification;
@end
