//
//  FITSHeaderAndDataUnit.h
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
