//
//  ADImage.h
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
//  Copyright (c) 2013 Dieudonné Willems. All rights reserved.Plugin
//
//  Created by Don Willems on 26-05-13.
//
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
