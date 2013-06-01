//
//  ADImage.m
//  ReductionPlugin
//
//  Created by Don Willems on 26-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADImage.h"

@implementation ADImage

- (id) initWithSize:(NSSize)size
{
    self = [super initWithSize:size];
    if(self){
        needsCalculateStatistics = YES;
        NSUInteger i;
        pixels = (double**)malloc(sizeof(double*)*size.width);
        for(i=0;i<size.width;i++){
            pixels[i] = (double*)malloc(sizeof(double)*size.height);
        }
    }
    return self;
}

- (id) initWithData:(NSData*)data
{
    CGFloat width,height;
    [data getBytes:&height length:sizeof(CGFloat)];
    [data getBytes:&width range:NSMakeRange(sizeof(CGFloat), sizeof(CGFloat))];
    NSLog(@"**** image size: %f x %f",width,height);
    NSSize size = NSMakeSize(width, height);
    self = [self initWithSize:size];
    if(self){
        NSUInteger x,y;
        NSRange rng = NSMakeRange(2*sizeof(CGFloat), sizeof(double));
        for(y=0;y<[self size].height;y++){
            for(x=0;x<[self size].width;x++){
                double pv;
                [data getBytes:&pv range:rng];
                pixels[x][y] = pv;
                rng.location+=sizeof(double);
            }
        }
    }
    [self calculateStatistics];
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

@synthesize needsCalculateStatistics;
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

- (void) setPixelValue:(double)value atX:(NSInteger)x andY:(NSInteger)y
{
    if(x>=[self size].width || x<0 || y>=[self size].height || y<0){
        NSException *exception = [NSException exceptionWithName:@"FITSImageIndexOutOfRange" reason:[NSString stringWithFormat:@"Image index (%ld,%ld) out of range (%ld,%ld).", x,y,(NSInteger)[self size].width,(NSInteger)[self size].height] userInfo:nil];
        @throw exception;
    }
    needsCalculateStatistics = YES;
    pixels[x][y] = value;
   // NSLog(@"value = %f",value);
}

- (NSData*) dataRepresentation
{
    NSMutableData* data = [NSMutableData data];
    CGFloat width = [self size].width;
    CGFloat height = [self size].height;
    [data appendBytes:&height length:sizeof(CGFloat)];
    [data appendBytes:&width length:sizeof(CGFloat)];
    NSUInteger x,y;
    for(y=0;y<[self size].height;y++){
        for(x=0;x<[self size].width;x++){
            double pv = [self getPixelValueAtX:x andY:y];
            [data appendBytes:&pv length:sizeof(double)];
        }
    }
    return data;
}

- (void) calculateStatistics
{
    double tot = 0;
    NSUInteger i,j;
    CGFloat width = [self size].width;
    CGFloat height = [self size].height;
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
    needsCalculateStatistics = NO;
}
@end