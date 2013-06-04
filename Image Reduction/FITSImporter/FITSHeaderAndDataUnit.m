//
//  FITSHeaderAndDataUnit.m
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
//  Created by Don Willems on 09-05-13.
//
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
