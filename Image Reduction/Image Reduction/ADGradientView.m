//
//  ADGradientView.m
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
//  Created by Don Willems on 16-06-13.
//

#import "ADGradientView.h"

@interface ADGradientView (private)
- (void) windowDidChangeKey:(NSNotification*)not;
@end

@implementation ADGradientView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        topColor = [NSColor colorWithCalibratedWhite:0.86 alpha:1.0];
        bottomColor = [NSColor colorWithCalibratedWhite:0.73 alpha:1.0];
        topLineColor = [NSColor colorWithCalibratedWhite:0.37 alpha:1.0];
        bottomLineColor = [NSColor colorWithCalibratedWhite:0.33 alpha:1.0];
        notKeyTopColor = [NSColor colorWithCalibratedWhite:0.96 alpha:1.0];
        notKeyBottomColor = [NSColor colorWithCalibratedWhite:0.84 alpha:1.0];
        notKeyTopLineColor = [NSColor colorWithCalibratedWhite:0.62 alpha:1.0];
        notKeyBottomLineColor = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
        drawBottomLine = YES;
        drawTopLine = YES;
    }
    return self;
}

- (void) awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeKey:) name:NSWindowDidResignMainNotification object:[self window]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeKey:) name:NSWindowDidResignKeyNotification object:[self window]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeKey:) name:NSWindowDidBecomeMainNotification object:[self window]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeKey:) name:NSWindowDidBecomeKeyNotification object:[self window]];
}

- (void) windowDidChangeKey:(NSNotification*)not
{
    [self setNeedsDisplay:YES];
}

@synthesize topColor;
@synthesize bottomColor;
@synthesize topLineColor;
@synthesize bottomLineColor;
@synthesize notKeyTopColor;
@synthesize notKeyTopLineColor;
@synthesize notKeyBottomColor;
@synthesize notKeyBottomLineColor;
@synthesize drawTopLine;
@synthesize drawBottomLine;

- (void)drawRect:(NSRect)dirtyRect
{
    NSColor *tc=nil, *tlc=nil, *bc=nil, *blc=nil;
    if([[self window] isKeyWindow]){
        tc = topColor;
        bc = bottomColor;
        tlc = topLineColor;
        blc = bottomLineColor;
    }else{
        tc = notKeyTopColor;
        bc = notKeyBottomColor;
        tlc = notKeyTopLineColor;
        blc = notKeyBottomLineColor;
    }
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:tc endingColor:bc];
    NSRect nrect= dirtyRect;
    nrect.origin.y = [self frame].origin.y;
    nrect.size.height = [self frame].size.height;
    [gradient drawInRect:nrect angle:-90];
    if(drawBottomLine){
        NSBezierPath *bp = [NSBezierPath bezierPath];
        [bp moveToPoint:NSMakePoint(nrect.origin.x, nrect.origin.y+0.5)];
        [bp lineToPoint:NSMakePoint(nrect.origin.x+nrect.size.width, nrect.origin.y+0.5)];
        [blc set];
        [bp stroke];
    }
    if(drawTopLine){
        NSBezierPath *bp = [NSBezierPath bezierPath];
        [bp moveToPoint:NSMakePoint(nrect.origin.x, nrect.origin.y+nrect.size.height)];
        [bp lineToPoint:NSMakePoint(nrect.origin.x+nrect.size.width, nrect.origin.y+nrect.size.height)];
        [tlc set];
        [bp stroke];
    }
}
@end
