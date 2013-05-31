//
//  FITSImage.m
//  ObjCFITSIO
//
//  Created by Don Willems on 22-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
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
    return self;
}
@end
