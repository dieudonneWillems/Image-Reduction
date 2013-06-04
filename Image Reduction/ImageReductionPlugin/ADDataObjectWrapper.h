//
//  ADDataObjectWrapper.h
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

#import <Foundation/Foundation.h>
#import "ADProperty.h"
#import "ADDataObject.h"

@interface ADDataObjectWrapper : NSObject {
    NSString *filename;
    id<ADDataObject> dataObject;
    NSString *originalFilename;
    NSString *type;
    NSMutableDictionary *properties;
    NSImage *thumbnail;
}

+ (ADDataObjectWrapper*) createWrapperForDataObject:(id<ADDataObject>)object ofType:(NSString*)tp;

- (id) initFromDictionary:(NSDictionary*)dict;

@property (readwrite) id<ADDataObject> dataObject;
@property (readwrite) NSString *filename;
@property (readwrite) NSString *originalFilename;
@property (readonly) NSString *type;
@property (readwrite) NSImage *thumbnail;
- (void) createThumbnail;

- (void) bundleFilenameFromOriginalFilename:(NSString*)original withSeed:(NSUInteger)seed;

- (BOOL) dataObjectIsLoaded;
- (BOOL) loadDataObjectFromBundleAtPath:(NSString*)bundlepath;

- (NSArray*) properties;
- (ADProperty*) propertyForKey:(NSString*)propertyKey;
- (void) addProperty:(ADProperty*)property;
- (void) addPropertiesFromArray:(NSArray*)props;

- (void) postUpdateDataObjectNotification;

- (NSDictionary*) serializeToDictionary;
@end
