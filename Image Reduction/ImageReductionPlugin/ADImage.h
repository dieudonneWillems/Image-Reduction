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

@protocol ADImage <ADDataObject>

@required

@property (readonly) double averageValue;
@property (readonly) double medianValue;
@property (readonly) double minimumValue;
@property (readonly) double maximumValue;
@property (readonly) double standardDeviationValue;

- (void) recreateImageWithDefaultScaling;
- (void) recreateImageWithScalingFunction:(ADScalingFunction*)function;
- (double) getPixelValueAtX:(NSInteger)x andY:(NSInteger)y;

@end
