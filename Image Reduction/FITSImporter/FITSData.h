//
//  FITSData.h
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
//  Created by Don Willems on 28-03-13.
//
//

#import <Foundation/Foundation.h>

@class FITSHeader,FITSHeaderAndDataUnit;

static int const UNSIGNED_BINARY_INT_BITPIX = 8;
static int const INTEGER_16BIT_BITPIX = 16;
static int const INTEGER_32BIT_BITPIX = 32;
static int const INTEGER_64BIT_BITPIX = 64;
static int const FLOAT_32BIT_BITPIX = -32;
static int const FLOAT_64BIT_BITPIX = -64;

@interface FITSData : NSObject {
    int bitpix;
    NSInteger naxes;
    NSInteger *naxis;
    NSData *data;
    NSString *type;
    FITSHeader *header;
}

+ (FITSData*) createFITSDataFromData:(NSData*)data withHeader:(FITSHeader*)header numberOfBytes:(NSUInteger*)flength;

- (id) initWithBitsPerPixel:(int)bitp numberOfAxes:(NSInteger)caxes lengthOfAxis:(NSInteger*)naxs data:(NSData*)fdata type:(NSString*)type header:(FITSHeader*)fheader;

- (FITSHeaderAndDataUnit*) headerAndDataUnit;
- (int) bitsPerPixel;
- (NSInteger) numberOfAxes;
- (NSInteger) lengthOfAxis:(NSInteger)axis;


- (double) doubleValueAtColumn:(NSUInteger)column row:(NSUInteger)row plane:(NSUInteger)plane;
- (long long) longLongValueForCoordinates:(NSInteger)coord, ... ;
- (double) doubleValueForCoordinates:(NSInteger)coord, ... ;
@end
