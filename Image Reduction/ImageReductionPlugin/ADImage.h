//
//  ADImage.h
//  ReductionPlugin
//
//  Created by Don Willems on 26-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADDataObject.h"
#import "ADScalingFunction.h"

@interface ADImage : NSImage <ADDataObject> {
    double **pixels;
    double averageValue;
    double medianValue;
    double minimumValue;
    double maximumValue;
    double standardDeviationValue;
    ADScalingFunction *defaultScaling;
    BOOL needsCalculateStatistics;
}

- (id) initWithData:(NSData*)data;

@property (readwrite) BOOL needsCalculateStatistics;
@property (readonly) double averageValue;
@property (readonly) double medianValue;
@property (readonly) double minimumValue;
@property (readonly) double maximumValue;
@property (readonly) double standardDeviationValue;

- (void) recreateImageWithDefaultScaling;
- (void) recreateImageWithScalingFunction:(ADScalingFunction*)function;
- (double) getPixelValueAtX:(NSInteger)x andY:(NSInteger)y;
- (void) setPixelValue:(double)value atX:(NSInteger)x andY:(NSInteger)y;

- (void) calculateStatistics;

@end
