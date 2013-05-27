//
//  FITSHeaderAndDataUnit.m
//  ObjCFITSIO
//
//  Created by Don Willems on 09-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "FITSHeaderAndDataUnit.h"

@implementation FITSHeaderAndDataUnit

- (id) initWithHeader:(FITSHeader*)fheader
{
    self = [super init];
    header = fheader;
    type = UNKNOWN_HUD_TYPE;
    return self;
}

- (id) initWithHeader:(FITSHeader*)fheader andImage:(FITSImage*)image
{
    self = [super init];
    header = fheader;
    dataObjects = [NSArray arrayWithObject:image];
    type = IMAGE_HUD;
    return self;
}

- (id) initWithHeader:(FITSHeader*)fheader andImagePlanes:(NSArray*)images
{
    self = [super init];
    header = fheader;
    dataObjects = images;
    type = IMAGE_HUD;
    return self;
}

@synthesize header;
@synthesize type;

- (FITSImage*) image
{
    if(type!=IMAGE_HUD || [dataObjects count]!=1) return nil;
    return [dataObjects objectAtIndex:0];
}

- (NSUInteger) numberOfImagePlanes
{
    if(type!=IMAGE_HUD) return 0;
    return [dataObjects count];
}

- (FITSImage*) imageAtPlaneIndex:(NSUInteger)planeIndex
{
    if(type!=IMAGE_HUD) return nil;
    return [dataObjects objectAtIndex:planeIndex];
}

@end
