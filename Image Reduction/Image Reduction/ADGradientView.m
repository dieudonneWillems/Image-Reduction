//
//  ADGradientView.m
//  Image Reduction
//
//  Created by Don Willems on 16-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADGradientView.h"

@implementation ADGradientView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        topColor = [NSColor colorWithCalibratedWhite:0.86 alpha:1.0];
        bottomColor = [NSColor colorWithCalibratedWhite:0.73 alpha:1.0];
        topLineColor = [NSColor colorWithCalibratedWhite:0.37 alpha:1.0];
        bottomLineColor = [NSColor colorWithCalibratedWhite:0.33 alpha:1.0];
    }
    return self;
}

@synthesize topColor;
@synthesize bottomColor;
@synthesize topLineColor;
@synthesize bottomLineColor;

- (void)drawRect:(NSRect)dirtyRect
{
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:topColor endingColor:bottomColor];
    NSRect nrect= dirtyRect;
    nrect.origin.y = [self frame].origin.y;
    nrect.size.height = [self frame].size.height;
    [gradient drawInRect:nrect angle:-90];
    NSBezierPath *bp = [NSBezierPath bezierPath];
    [bp moveToPoint:NSMakePoint(nrect.origin.x, nrect.origin.y+0.5)];
    [bp lineToPoint:NSMakePoint(nrect.origin.x+nrect.size.width, nrect.origin.y+0.5)];
    [bottomLineColor set];
    [bp stroke];
    bp = [NSBezierPath bezierPath];
    [bp moveToPoint:NSMakePoint(nrect.origin.x, nrect.origin.y+nrect.size.height)];
    [bp lineToPoint:NSMakePoint(nrect.origin.x+nrect.size.width, nrect.origin.y+nrect.size.height)];
    [topLineColor set];
    [bp stroke];
}
@end
