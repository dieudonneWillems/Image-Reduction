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
    pixels = (double**)malloc(sizeof(double*)*width);
    for(i=0;i<width;i++){
        NSLog(@"i=%ld",i);
        pixels[i] = (double*)malloc(sizeof(double)*height);
        for(j=0;j<height;j++){
            pixels[i][j] = [data doubleValueAtColumn:i row:j plane:plane];
        }
    }
    //for(i=0;i<nvalues;i++) NSLog(@"sorted[%ld]=%f",i,sortedValues[i]);
    double tot = 0;
    for(i=0;i<width;i++){
        for(j=0;j<height;j++){
            tot+=pixels[i][j];
            if(i==0 && j==0){
                minimumValue = pixels[i][j];
                maximumValue = pixels[i][j];
            }else{
                if(minimumValue>pixels[i][j]) minimumValue = pixels[i][j];
                if(maximumValue<pixels[i][j]) maximumValue = pixels[i][j];
            }
           // NSLog(@"pixel value at (%ld,%ld) = %f",i,j,pixels[i][j]);
        }
    }
    averageValue = tot/(width*height);
    tot=0;
    for(i=0;i<width;i++){
        for(j=0;j<height;j++){
            tot = tot + pow((pixels[i][j]-averageValue),2);
        }
    }
    standardDeviationValue = sqrt(tot/(width*height));
    NSLog(@"Average pixel value: %f",averageValue);
    NSLog(@"Maximum pixel value: %f",maximumValue);
    NSLog(@"Minimum pixel value: %f",minimumValue);
    NSLog(@"Standard Deviation pixel value: %f",standardDeviationValue);
    NSSize size = NSMakeSize(width, height);
    self = [super initWithSize:size];
    defaultScaling = [[ADScalingFunction alloc] init];
    [defaultScaling setBlackPoint:averageValue-standardDeviationValue];
    [defaultScaling setWhitePoint:averageValue+standardDeviationValue*2];
    return self;
}


- (void) dealloc
{
    NSInteger i;
    for(i=0;i<[self size].width;i++){
        free(pixels[i]);
    }
    free(pixels);
}

@synthesize averageValue;
@synthesize medianValue;
@synthesize minimumValue;
@synthesize maximumValue;
@synthesize standardDeviationValue;

- (void) recreateImageWithDefaultScaling
{
    [self recreateImageWithScalingFunction:defaultScaling];
}

- (void) recreateImageWithScalingFunction:(ADScalingFunction*)function
{
    int bps = 16;
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc]
                                initWithBitmapDataPlanes:NULL
                                pixelsWide:[self size].width pixelsHigh:[self size].height
                                bitsPerSample:bps
                                samplesPerPixel:1  // or 4 with alpha
                                hasAlpha:NO
                                isPlanar:NO
                                colorSpaceName:NSDeviceWhiteColorSpace
                                bitmapFormat:0
                                bytesPerRow:0  // 0 == determine automatically
                                bitsPerPixel:0];  // 0 == determine automatically
    NSUInteger maxv = (pow(2,bps)-1);
    NSUInteger i,j;
    for(i=0;i<[self size].width;i++){
        for(j=0;j<[self size].height;j++){
            double value = pixels[i][j];
            double scaled = [function scaledValueForValue:value];
            NSUInteger px[1];
            px[0]=maxv*scaled;
            //NSLog(@"p(%ld,%ld) = %ld   value=%f  scaled=%f  maxv=%ld" ,i,j,px[0],value,scaled,maxv);
            [bitmap setPixel:px atX:i y:[self size].height-1-j];
        }
    }
    [self addRepresentation:bitmap];
}

- (double) getPixelValueAtX:(NSInteger)x andY:(NSInteger)y
{
    if(x>=[self size].width || x<0 || y>=[self size].height || y<0){
        NSException *exception = [NSException exceptionWithName:@"FITSImageIndexOutOfRange" reason:[NSString stringWithFormat:@"Image index (%ld,%ld) out of range (%ld,%ld).", x,y,(NSInteger)[self size].width,(NSInteger)[self size].height] userInfo:nil];
        @throw exception;
    }
    return pixels[x][y];
}
@end
