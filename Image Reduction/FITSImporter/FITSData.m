//
//  FITSData.m
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

#import "FITSData.h"
#import "FITSHeader.h"
#import "FITSImage.h"
#import "FITSHeaderAndDataUnit.h"

@interface FITSData (private)
- (void) readPixels;
@end

@implementation FITSData

+ (FITSData*) createFITSDataFromData:(NSData*)data withHeader:(FITSHeader*)header numberOfBytes:(NSUInteger*)flength
{
    NSString *type = @"IMAGE";// At the moment we assume that the primary HDU is of type IMAGE
    NSString *etype = [header stringValueForRecordWithIdentifier:@"XTENSION"]; 
    if(etype) type = etype;
    int bitpix = [header intValueForRecordWithIdentifier:@"BITPIX"];
    NSInteger naxes = [header intValueForRecordWithIdentifier:@"NAXIS"];
    NSInteger *naxis = (NSInteger*)malloc(sizeof(NSInteger)*naxes);
    int i;
    *flength = fabs((double)bitpix)/8.0;
    for(i=0;i<naxes;i++){
        NSInteger n = [header intValueForRecordWithIdentifier:[NSString stringWithFormat:@"NAXIS%d",i+1]];
        naxis[i] = n;
        *flength = (*flength)*n;
    }
    FITSData *fdata = [[FITSData alloc] initWithBitsPerPixel:bitpix numberOfAxes:naxes lengthOfAxis:naxis data:data type:type header:header];
    free(naxis);
    return fdata;
}

- (id) initWithBitsPerPixel:(int)bitp numberOfAxes:(NSInteger)caxes lengthOfAxis:(NSInteger*)naxs data:(NSData*)fdata type:(NSString*)etype header:(FITSHeader*)fheader;
{
    self = [super init];
    bitpix = bitp;
    naxes = caxes;
    naxis = (NSInteger*)malloc(sizeof(NSInteger)*caxes);
    NSInteger i;
    NSUInteger size = 1;
    type = etype;
    for(i=0;i<naxes;i++) {
        naxis[i] = naxs[i];
        size = size*naxis[i];
    }
    data = fdata;
    header = fheader;
    return self;
}

- (void) dealloc
{
    free(naxis);   
}

- (FITSHeaderAndDataUnit*) headerAndDataUnit
{
    if([type isEqualToString:@"IMAGE"] && naxes>=2){
        if(naxes>2){
            NSInteger l = [self lengthOfAxis:2];
            int i=0;
            NSMutableArray *images = [NSMutableArray array];
            for(i=0;i<l;i++){
                FITSImage *image = [FITSImage createImageFromData:self atPlaneIndex:i withHeader:header];
                [images addObject:image];
            }
            FITSHeaderAndDataUnit *hud = [[FITSHeaderAndDataUnit alloc] initWithHeader:header andImagePlanes:images];
            return hud;
        }else{
            FITSImage *image = [FITSImage createImageFromData:self atPlaneIndex:0 withHeader:header];
            FITSHeaderAndDataUnit *hud = [[FITSHeaderAndDataUnit alloc] initWithHeader:header andImage:image];
            return hud;
        }
    }
    // create Tables, Spectra ...
    return nil;
}

- (int) bitsPerPixel
{
    return bitpix;
}

- (NSInteger) numberOfAxes
{
    return naxes;
}

- (NSInteger) lengthOfAxis:(NSInteger)axis
{
    return naxis[axis];
}

- (long long) longLongValueForCoordinates:(NSInteger)coord, ...
{
    return 0;
}

- (double) doubleValueAtColumn:(NSUInteger)column row:(NSUInteger)row plane:(NSUInteger)plane
{
    double value;
    char c;
    int integ;
    long int longint;
    long long longlong;
    float floatv;
    NSSwappedDouble sdouble;
    NSSwappedFloat sfloat;
    NSInteger pos = 0,i,j;
    for(i=0;i<naxes;i++){
        NSInteger dpos = column;
        if(i==1) dpos = row;
        else if(i==2) dpos = plane;
        for(j=0;j<i;j++){
            dpos = dpos*naxis[j];
        }
        pos+=dpos;
    }
    NSUInteger bitsize = abs(bitpix)/8;
    switch (bitpix) {
        case UNSIGNED_BINARY_INT_BITPIX:
            [data getBytes:&c range:NSMakeRange(pos*bitsize,bitsize)];
            //c = NSSwapLittleShortToHost(c);
            c = NSSwapBigShortToHost(c);
            value = (double)c;
            break;
        case INTEGER_16BIT_BITPIX:
            //NSLog(@"size of int: %ld   (%ld,%ld)",sizeof(int),column,row);
            [data getBytes:&integ range:NSMakeRange(pos*bitsize,bitsize)];
            //integ = NSSwapLittleIntToHost(integ);
            integ = NSSwapBigIntToHost(integ);
            //NSLog(@"value = %d",integ);
            int pp = pow(2,16);
            value = (double)(integ/pp+pp/2);
            break;
        case INTEGER_32BIT_BITPIX:
            [data getBytes:&longint range:NSMakeRange(pos*bitsize,bitsize)];
           // longint = NSSwapLittleLongToHost(longint);
            longint = NSSwapBigLongToHost(longint);
            value = (double)longint;
            break;
        case INTEGER_64BIT_BITPIX:
            [data getBytes:&longlong range:NSMakeRange(pos*bitsize,bitsize)];
           // longlong = NSSwapLittleLongLongToHost(longlong);
            longlong = NSSwapBigLongLongToHost(longlong);
            value = (double)longlong;
            break;
        case FLOAT_32BIT_BITPIX:
            [data getBytes:&sfloat range:NSMakeRange(pos*bitsize,bitsize)];
            //floatv = NSSwapLittleFloatToHost(sfloat);
            floatv = NSSwapBigFloatToHost(sfloat);
            value = (double)floatv;
            break;
        case FLOAT_64BIT_BITPIX:
            [data getBytes:&sdouble range:NSMakeRange(pos*bitsize,bitsize)];
           // value = NSSwapLittleDoubleToHost(sdouble);
            value = NSSwapBigDoubleToHost(sdouble);
            break;
    }
    return value;
}

- (double) doubleValueForCoordinates:(NSInteger)coord, ...
{
    va_list args;
    NSInteger *coords = (NSInteger*)malloc(sizeof(NSInteger)*naxes);
    NSInteger i = 0,j;
    coords[i] = coord;
    va_start(args, coord);
    for(i=0;i<naxes;i++){
        coords[i] = va_arg(args,NSInteger);
        NSLog(@"coords[%ld] = %ld",i,coords[i]);
    }
    va_end(args);
    NSInteger pos =0;
    for(i=0;i<naxes;i++){
        NSInteger dpos = coords[i];
        for(j=i+1;j<naxes;j++){
            dpos = dpos*naxis[j];
        }
        pos+=dpos;
    }
    NSLog(@"pos = %ld",pos);
    double value;
    char c;
    int integ;
    long int longint;
    long long longlong;
    float floatv;
    NSSwappedDouble sdouble;
    NSSwappedFloat sfloat;
    switch (bitpix) {
        case UNSIGNED_BINARY_INT_BITPIX:
            [data getBytes:&c range:NSMakeRange(pos*sizeof(char),sizeof(char))];
            c = NSSwapLittleShortToHost(c);
            value = (double)c;
            break;
        case INTEGER_16BIT_BITPIX:
            [data getBytes:&integ range:NSMakeRange(pos*sizeof(int),sizeof(int))];
            integ = NSSwapLittleIntToHost(integ);
            value = (double)integ;
            break;
        case INTEGER_32BIT_BITPIX:
            [data getBytes:&longint range:NSMakeRange(pos*sizeof(long int),sizeof(long int))];
            longint = NSSwapLittleLongToHost(longint);
            value = (double)longint;
            break;
        case INTEGER_64BIT_BITPIX:
            [data getBytes:&longlong range:NSMakeRange(pos*sizeof(long long),sizeof(long long))];
            longlong = NSSwapLittleLongLongToHost(longlong);
            value = (double)longlong;
            break;
        case FLOAT_32BIT_BITPIX:
            [data getBytes:&sfloat range:NSMakeRange(pos*sizeof(float),sizeof(float))];
            floatv = NSSwapLittleFloatToHost(sfloat);
            value = (double)floatv;
            break;
        case FLOAT_64BIT_BITPIX:
            [data getBytes:&sdouble range:NSMakeRange(pos*sizeof(double),sizeof(double))];
            value = NSSwapLittleDoubleToHost(sdouble);
            break;
    }
    free(coords);
    return value;
}

@end
