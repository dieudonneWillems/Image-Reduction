//
//  ADScalingFunction.h
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

@interface ADScalingFunction : NSObject {
    double blackPoint;
    double whitePoint;
}

- (double) scaledValueForValue:(double)value;
- (NSColor*) colorForValue:(double)value;

@property (readwrite) double blackPoint;
@property (readwrite) double whitePoint;

@end
