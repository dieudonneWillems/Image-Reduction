//
//  FITSImporter.m
//  FITSImporter
//
//  Created by Don Willems on 23-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "FITSImporter.h"
#import "FITSFile.h"
#import "FITSHeaderAndDataUnit.h"

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
            [array addObject:[hud imageAtPlaneIndex:i]];
        }
    }
    return array;
}

@end
