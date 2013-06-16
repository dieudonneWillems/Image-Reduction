//
//  ADCursorLayer.m
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
//
//  Created by Don Willems on 14-05-13.
//

#import "ADCursorLayer.h"
#import "ADImageView.h"

@implementation ADCursorLayer

- (NSString*) name
{
    return @"Cursor";
}

- (void) initialize
{
    
}

- (ADPreferencePane*) preferencePane
{
    return nil;
}

- (BOOL) isVisible
{
    return YES;
}

- (void) setVisible:(BOOL)vis
{
    // Cannot be changed
}

- (CGFloat) topMargin { return 0.0; }
- (CGFloat) bottomMargin { return 0.0; }
- (CGFloat) leftMargin { return 0.0; }
- (CGFloat) rightMargin { return 0.0; }

- (void) drawLayerInImageView:(ADImageView*)view dirtyViewRect:(NSRect)dirtyViewRect dirtyImageRect:(NSRect)dirtyImageRect
{
    [[NSColor greenColor] set];
    NSRect cursorRect;
    cursorRect.origin = [view viewLocationFromImageLocation:[view origin]];
    cursorRect.origin.x -= 20;
    cursorRect.origin.y -= 20;
    cursorRect.size.width = 40;
    cursorRect.size.height = 40;
    NSBezierPath *cursor = [NSBezierPath bezierPathWithOvalInRect:cursorRect];
    [cursor setLineWidth:3.0];
    [cursor stroke];
}
@end
