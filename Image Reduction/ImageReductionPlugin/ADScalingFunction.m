//
//  ADScalingFunction.m
//  ReductionPlugin
//
//  Created by Don Willems on 26-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADScalingFunction.h"

@implementation ADScalingFunction

@synthesize blackPoint;
@synthesize whitePoint;

- (double) scaledValueForValue:(double)value
{
    double nval = (value-blackPoint)/(whitePoint-blackPoint);
    if(nval<0.0) nval = 0.0;
    if(nval>1.0) nval = 1.0;
    return nval;
}

@end
