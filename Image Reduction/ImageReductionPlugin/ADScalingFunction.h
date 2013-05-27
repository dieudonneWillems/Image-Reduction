//
//  ADScalingFunction.h
//  ReductionPlugin
//
//  Created by Don Willems on 26-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADScalingFunction : NSObject {
    double blackPoint;
    double whitePoint;
}

- (double) scaledValueForValue:(double)value;

@property (readwrite) double blackPoint;
@property (readwrite) double whitePoint;

@end
