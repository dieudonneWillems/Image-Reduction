//
//  FITSImporter.m
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
//  Copyright (c) 2013 Dieudonné Willems. All rights reserved
//
//  Created by Don Willems on 23-05-13.
//
//

#import "FITSImporter.h"
#import "FITSFile.h"
#import "FITSImage.h"
#import "FITSHeaderAndDataUnit.h"
#import "FITSHeader.h"

@interface FITSImporter (private)
- (void) parsePropertiesFromHeader:(FITSHeader*)header into:(ADDataObjectWrapper*)wrapper;
@end

@implementation FITSImporter 

- (NSString*) name
{
    return @"FITS Importer";
}

- (void) initialize
{
    NSLog(@"Initializing FITSImporter");
}

- (ADPreferencePane*) preferencePane
{
    return nil;
}

- (NSArray*) supportedFileTypes
{
    return [NSArray arrayWithObject:@"fits"];
}

- (NSArray*) importFileAtPath:(NSString*)path withSeed:(NSUInteger)seed
{
    FITSFile *fitsfile = [FITSFile FITSFileAtPath:path];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *huds = [fitsfile headerAndDataUnits];
    for(FITSHeaderAndDataUnit *hud in huds){
        NSUInteger cnt = [hud numberOfImagePlanes];
        NSUInteger i;
        for(i=0;i<cnt;i++){
            FITSImage *image = [hud imageAtPlaneIndex:i];
            ADDataObjectWrapper *wrapper = [ADDataObjectWrapper createWrapperForDataObject:image ofType:ADPropertyTypeImage];
            [self parsePropertiesFromHeader:[hud header] into:wrapper];
            [wrapper bundleFilenameFromOriginalFilename:[path lastPathComponent] withSeed:seed];
            [array addObject:wrapper];
        }
    }
    return array;
}


- (void) parsePropertiesFromHeader:(FITSHeader*)header into:(ADDataObjectWrapper*)wrapper
{
    NSMutableArray *properties = [NSMutableArray array];
    NSString *obstype = [header stringValueForRecordWithIdentifier:@"OBSTYPE"];
    NSString *fltype = [header stringValueForRecordWithIdentifier:@"FILETYPE"];
    if([[obstype uppercaseString] isEqualToString:@"BIAS"]){
        ADProperty *obst = [ADProperty imageTypePropertyWithValueKey:ADPropertyImageTypeBias];
        [properties addObject:obst];
    }else if([[obstype uppercaseString] isEqualToString:@"FLAT"]){
        ADProperty *obst = [ADProperty imageTypePropertyWithValueKey:ADPropertyImageTypeFlat];
        [properties addObject:obst];
    }else if([[obstype uppercaseString] isEqualToString:@"DARK"]){
        ADProperty *obst = [ADProperty imageTypePropertyWithValueKey:ADPropertyImageTypeDark];
        [properties addObject:obst];
    }else if([[obstype uppercaseString] isEqualToString:@"OBJECT"]){
        ADProperty *obst = [ADProperty imageTypePropertyWithValueKey:ADPropertyImageTypeRaw];
        [properties addObject:obst];
    }else if([[obstype uppercaseString] isEqualToString:@"SCIENCE"]){
        ADProperty *obst = [ADProperty imageTypePropertyWithValueKey:ADPropertyImageTypeRaw];
        [properties addObject:obst];
    }else if([[fltype uppercaseString] isEqualToString:@"SCI"]){
        ADProperty *obst = [ADProperty imageTypePropertyWithValueKey:ADPropertyImageTypeRaw];
        [properties addObject:obst];
    }else {
        ADProperty *obst = [ADProperty imageTypePropertyWithValueKey:ADPropertyImageTypeUnknown];
        [properties addObject:obst];
    }
    [wrapper addPropertiesFromArray:properties];
}
@end
