//
//  ADGradientView.h
//
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
//  Created by Don Willems on 16-06-13.
//

#import <Cocoa/Cocoa.h>

@interface ADGradientView : NSView {
    NSColor *topColor;
    NSColor *bottomColor;
    NSColor *topLineColor;
    NSColor *bottomLineColor;
    NSColor *notKeyTopColor;
    NSColor *notKeyBottomColor;
    NSColor *notKeyTopLineColor;
    NSColor *notKeyBottomLineColor;
    BOOL drawTopLine;
    BOOL drawBottomLine;
}

@property (readwrite) NSColor *topColor;
@property (readwrite) NSColor *bottomColor;
@property (readwrite) NSColor *topLineColor;
@property (readwrite) NSColor *bottomLineColor;

@property (readwrite) NSColor *notKeyTopColor;
@property (readwrite) NSColor *notKeyBottomColor;
@property (readwrite) NSColor *notKeyTopLineColor;
@property (readwrite) NSColor *notKeyBottomLineColor;

@property (readwrite) BOOL drawTopLine;
@property (readwrite) BOOL drawBottomLine;

@end
