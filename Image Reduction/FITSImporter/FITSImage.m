//
//  FITSImage.m
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
//  Created by Don Willems on 22-03-13.
//
//

#import "FITSImage.h"
#import "FITSData.h"
#import "FITSHeader.h"
#import "FITSHeaderRecord.h"

@interface FITSImage (private)
+ (NSException*) createFITSExceptionForFISTStatus:(int)status;
- (id) initWithData:(FITSData*)data atPlaneIndex:(NSUInteger)plane withHeader:(FITSHeader*)header;
- (void) putInSortedArray:(double)value min:(NSUInteger)min max:(NSUInteger)max n:(NSUInteger)n;
- (void) parsePropertiesFromHeader:(FITSHeader*)header;
@end

@implementation FITSImage

+ (FITSImage*) createImageFromData:(FITSData*)data atPlaneIndex:(NSUInteger)plane withHeader:(FITSHeader*)header
{
    return [[FITSImage alloc] initWithData:data atPlaneIndex:plane withHeader:header];
}

- (id) initWithData:(FITSData*)data atPlaneIndex:(NSUInteger)plane withHeader:(FITSHeader*)header
{
    CGFloat width=0,height=0;
    NSInteger i=0,j;
    NSInteger naxis = [data numberOfAxes];
    if(naxis>=2){
        width = [data lengthOfAxis:0];
        height = [data lengthOfAxis:1];
    }
    NSSize size = NSMakeSize(width, height);
    self = [super initWithSize:size];
    if(self){
        for(i=0;i<width;i++){
            for(j=0;j<height;j++){
                pixels[i][j] = [data doubleValueAtColumn:i row:j plane:plane];
                [self setPixelValue:[data doubleValueAtColumn:i row:j plane:plane] atX:i andY:j];
            }
        }
    }
    [self calculateStatistics];
    return self;
}
@end
