//
//  FITSHeaderAndDataUnit.h
//  ObjCFITSIO
//
//  Created by Don Willems on 09-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>


static short const UNKNOWN_HUD_TYPE = 0;
static short const IMAGE_HUD = 1;
static short const TABLE_HUD = 2;
static short const SPECTRUM_HUD = 3;

@class FITSHeader,FITSImage;

@interface FITSHeaderAndDataUnit : NSObject {
    FITSHeader *header;
    NSArray *dataObjects;
    short type;
}

- (id) initWithHeader:(FITSHeader*)header;
- (id) initWithHeader:(FITSHeader*)header andImage:(FITSImage*)image;
- (id) initWithHeader:(FITSHeader*)header andImagePlanes:(NSArray*)images;

@property (readonly) FITSHeader *header;
@property (readonly) short type;

// Return nil when HUD does not contain an image.
- (FITSImage*) image;
- (NSUInteger) numberOfImagePlanes;
- (FITSImage*) imageAtPlaneIndex:(NSUInteger)planeIndex;
@end
