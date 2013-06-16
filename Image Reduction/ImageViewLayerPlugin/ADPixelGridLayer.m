//
//  ADPixelGridLayer.m
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
//  Created by Don Willems on 13-05-13.
//

#import "ADPixelGridLayer.h"
#import "ADImageView.h"

@implementation ADPixelGridLayer

- (id) init
{
    self = [super init];
    visible = true;
    backgroundColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.6];
    foregroundColor = [NSColor colorWithCalibratedWhite:0.0 alpha:1.0];
    return self;
}

- (NSString*) name
{
    return @"Pixel Grid";
}

- (void) initialize
{
    
}

- (ADPreferencePane*) preferencePane
{
    return nil;
}

@synthesize backgroundColor;
@synthesize foregroundColor;

- (BOOL) isVisible
{
    return visible;
}

- (void) setVisible:(BOOL)vis
{
    visible = vis;
}

- (CGFloat) topMargin
{
    return 20.0;
}

- (CGFloat) bottomMargin
{
    return 20.0;
}

- (CGFloat) leftMargin
{
    return 20.0;
}

- (CGFloat) rightMargin
{
    return 20.0;
}

- (void) drawLayerInImageView:(ADImageView*)view dirtyViewRect:(NSRect)dirtyViewRect dirtyImageRect:(NSRect)dirtyImageRect
{
    NSRect leftmargin = NSMakeRect(0, [self bottomMargin], [self leftMargin], [view frame].size.height-[self bottomMargin]-[self topMargin]);
    NSRect rightmargin = NSMakeRect([view frame].size.width-[self rightMargin], [self bottomMargin], [self rightMargin], [view frame].size.height-[self bottomMargin]-[self topMargin]);
    NSRect bottommargin = NSMakeRect(0, 0, [view frame].size.width,[self bottomMargin]);
    NSRect topmargin = NSMakeRect(0, [view frame].size.height-[self topMargin], [view frame].size.width,[self topMargin]);
    [backgroundColor set];
    if(NSIntersectsRect(dirtyViewRect, leftmargin)){
        NSRect inrect = NSIntersectionRect(dirtyViewRect, leftmargin);
        NSBezierPath *bp = [NSBezierPath bezierPathWithRect:inrect];
        [bp fill];
    }
    if(NSIntersectsRect(dirtyViewRect, rightmargin)){
        NSRect inrect = NSIntersectionRect(dirtyViewRect, rightmargin);
        NSBezierPath *bp = [NSBezierPath bezierPathWithRect:inrect];
        [bp fill];
    }
    if(NSIntersectsRect(dirtyViewRect, bottommargin)){
        NSRect inrect = NSIntersectionRect(dirtyViewRect, bottommargin);
        NSBezierPath *bp = [NSBezierPath bezierPathWithRect:inrect];
        [bp fill];
    }
    if(NSIntersectsRect(dirtyViewRect, topmargin)){
        NSRect inrect = NSIntersectionRect(dirtyViewRect, topmargin);
        NSBezierPath *bp = [NSBezierPath bezierPathWithRect:inrect];
        [bp fill];
    }
    [foregroundColor set];
    CGFloat stepsize = (CGFloat)((NSInteger)(50.0/[view scale]));
    if(NSIntersectsRect(dirtyViewRect, topmargin) || NSIntersectsRect(dirtyViewRect, bottommargin)){
        CGFloat xpos = (CGFloat)(((NSInteger)(dirtyImageRect.origin.x/stepsize))*stepsize);
        while(xpos<dirtyImageRect.origin.x+dirtyImageRect.size.width){
            if(NSIntersectsRect(dirtyViewRect, bottommargin)){
                NSPoint p0 = NSMakePoint(xpos, bottommargin.origin.y+bottommargin.size.height);
                NSPoint v0 = [view viewLocationFromImageLocation:p0];
                NSPoint p1 = NSMakePoint(xpos, bottommargin.origin.y+bottommargin.size.height-10);
                NSPoint v1 = [view viewLocationFromImageLocation:p1];
                NSBezierPath *bp = [NSBezierPath bezierPath];
                [bp moveToPoint:v0];
                [bp lineToPoint:v1];
                [bp stroke];
            }
            xpos+=stepsize;
        }
    }
}

@end
