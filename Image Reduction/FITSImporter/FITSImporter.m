//
//  FITSImporter.m
//  FITSImporter
//
//  Created by Don Willems on 23-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
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

- (NSArray*) importFileAtPath:(NSString*)path
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
            [wrapper setFilename:[[path lastPathComponent] stringByDeletingPathExtension]];
            [array addObject:wrapper];
        }
    }
    return array;
}


- (void) parsePropertiesFromHeader:(FITSHeader*)header into:(ADDataObjectWrapper*)wrapper
{
    NSLog(@"header = %@",header);
    NSMutableArray *properties = [NSMutableArray array];
    NSString *obstype = [header stringValueForRecordWithIdentifier:@"OBSTYPE"];
    NSString *fltype = [header stringValueForRecordWithIdentifier:@"FILETYPE"];
    ADProperty *otype = [ADProperty typePropertyWithValueKey:ADPropertyTypeImage];
    [properties addObject:otype];
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
