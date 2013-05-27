//
//  FITSData.h
//  ObjCFITSIO
//
//  Created by Don Willems on 28-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
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
