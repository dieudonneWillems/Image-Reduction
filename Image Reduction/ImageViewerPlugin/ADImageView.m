//
//  ADImageView.m
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
//  Created by Don Willems on 10-05-13.
//

#import "ADImageView.h"

@interface ADImageView (private)
@end

@implementation ADImageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        scale = 1.0;
        origin = NSMakePoint(800,800);
        backgroundColor = [NSColor colorWithCalibratedWhite:0.3 alpha:1];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setAcceptsTouchEvents:YES];
    layers = [NSMutableArray array];
    scale = 1.0;
    origin = NSMakePoint(134.2,656.32);
    backgroundColor = [NSColor colorWithCalibratedWhite:0.8 alpha:1];
}


- (void)drawRect:(NSRect)dirtyRect
{
    [backgroundColor set];
    NSRectFill(dirtyRect);
    NSRect dirtyImageRect = [self imageRectFromViewRect:dirtyRect];
    [image drawInRect:dirtyRect fromRect:dirtyImageRect operation:NSCompositeSourceOver fraction:1.0];
    for(id<ADImageLayer> layer in layers){
        [layer drawLayerInImageView:self dirtyViewRect:dirtyRect dirtyImageRect:dirtyImageRect];
    }
}


- (ADImage*) image
{
    return image;
}

- (void) setImage:(ADImage*)fimage
{
    image = fimage;
    [self setNeedsDisplay:YES];
}

- (double) scale
{
    return scale;
}

- (void) setScale:(double)nscale
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:scale],ADImageViewOriginalScale,[NSNumber numberWithDouble:nscale],ADImageViewNewScale, nil];
    scale = nscale;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:ADImageViewScaledChangedNotification object:self userInfo:userInfo];
    [self setNeedsDisplay:YES];
}

- (NSPoint) origin
{
    return origin;
}

- (void) setOrigin:(NSPoint)norigin
{
    if(norigin.x<0) norigin.x = 0;
    if(norigin.y<0) norigin.y = 0;
    NSSize isize = [image size];
    if(norigin.x>isize.width) norigin.x = isize.width;
    if(norigin.y>isize.height) norigin.y = isize.height;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithPoint:origin],ADImageViewOriginalOrigin,[NSValue valueWithPoint:norigin],ADImageViewNewOrigin, nil];
    origin = norigin;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:ADImageViewScaledChangedNotification object:self userInfo:userInfo];
    [self setNeedsDisplay:YES];
}

- (NSColor*) backgroundColor
{
    return backgroundColor;
}

- (void) setBackgroundColor:(NSColor *)color
{
    backgroundColor = color;
    [self setNeedsDisplay:YES];
}

#pragma mark Viewport

- (NSRect) visibleViewRect
{
    NSRect viewport = [self frame];
    viewport.origin = NSZeroPoint;
    for(id<ADImageLayer> layer in layers){
        CGFloat top = [layer topMargin];
        CGFloat bottom = [layer bottomMargin];
        CGFloat left = [layer leftMargin];
        CGFloat right = [layer rightMargin];
        viewport.size.height-=top+bottom;
        viewport.size.width-=right+left;
        viewport.origin.x+=left;
        viewport.origin.y+=bottom;
    }
    return viewport;
}

- (NSRect) visibleImageRect
{
    return [self imageRectFromViewRect:[self visibleViewRect]];
}

- (NSRect) imageRectFromViewRect:(NSRect)viewRect
{
    NSPoint p0 = viewRect.origin;
    NSPoint p1 = NSMakePoint(viewRect.origin.x+viewRect.size.width, viewRect.origin.y+viewRect.size.height);
    NSPoint i0 = [self imageLocationFromViewLocation:p0];
    NSPoint i1 = [self imageLocationFromViewLocation:p1];
    NSRect ir;
    ir.origin = i0;
    ir.size = NSMakeSize(i1.x-i0.x,i1.y-i0.y);
    return ir;
}

- (NSRect) viewRectFromImageRect:(NSRect)imageRect
{
    NSPoint p0 = imageRect.origin;
    NSPoint p1 = NSMakePoint(imageRect.origin.x+imageRect.size.width, imageRect.origin.y+imageRect.size.height);
    NSPoint v0 = [self viewLocationFromImageLocation:p0];
    NSPoint v1 = [self viewLocationFromImageLocation:p1];
    NSRect vr;
    vr.origin = v0;
    vr.size = NSMakeSize(v1.x-v0.x,v1.y-v0.y);
    return vr;
}

- (NSPoint) imageLocationFromViewLocation:(NSPoint)location
{
    CGFloat wi = [image size].width;
    CGFloat hi = [image size].height;
    CGFloat x0 = [self visibleViewRect].origin.x;
    CGFloat y0 = [self visibleViewRect].origin.y;
    CGFloat wv = [self visibleViewRect].size.width;
    CGFloat hv = [self visibleViewRect].size.height;
    CGFloat xI = origin.x;
    CGFloat yI = origin.y;
    CGFloat xv = location.x;
    CGFloat yv = location.y;
    CGFloat xi = 0;
    CGFloat yi = 0;
    //1
    xi = (xv-x0-wv/2)/scale + xI;
    if(wi<wv/scale){
        //3
        xi = (xv-x0-wv/2)/scale + wi/2;
    }else if((wi-xI)*scale<wv/2){
        //2
        xi = wi+(xv-x0-wv)/scale;
    }else if(wv/2-xI*scale>0){
        //4
        xi = (xv-x0)/scale;
    }
    //1
    yi = (yv-y0-hv/2)/scale + yI;
    if(hi<hv/scale){
        //3
        yi = (yv-y0-hv/2)/scale + hi/2;
    }else if((hi-yI)*scale<hv/2){
        //2
        yi = hi+(yv-y0-hv)/scale;
    }else if(hv/2-yI*scale>0){
        //4
        yi = (yv-y0)/scale;
    }
    return NSMakePoint(xi, yi);
}

- (NSPoint) viewLocationFromImageLocation:(NSPoint)location
{
    CGFloat wi = [image size].width;
    CGFloat hi = [image size].height;
    CGFloat x0 = [self visibleViewRect].origin.x;
    CGFloat y0 = [self visibleViewRect].origin.y;
    CGFloat wv = [self visibleViewRect].size.width;
    CGFloat hv = [self visibleViewRect].size.height;
    CGFloat xI = origin.x;
    CGFloat yI = origin.y;
    CGFloat xv = 0;
    CGFloat yv = 0;
    CGFloat xi = location.x;
    CGFloat yi = location.y;
    xv = (xi-xI)*scale+x0+wv/2;
    if(wi<wv/scale){
        //3
        xv = x0+wv/2+(xi-wi/2)*scale;
    }else if((wi-xI)*scale<wv/2){
        //2
        xv = x0+wv+(xi-wi)*scale;
    }else if(wv/2-xI*scale>0){
        //4
        xv = x0+xi*scale;
    }
    //1
    yv = (yi-yI)*scale+y0+hv/2;
    if(hi<hv/scale){
        //3
        yv = y0+hv/2+(yi-hi/2)*scale;
    }else if((hi-yI)*scale<hv/2){
        //2
        yv = y0+hv+(yi-hi)*scale;
    }else if(hv/2-yI*scale>0){
        //4
        yv = y0+yi*scale;
    }
    return NSMakePoint(xv, yv);
}

# pragma mark Layer methods

- (void) addLayer:(id<ADImageLayer>)layer
{
    [layers addObject:layer];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:ADImageViewLayerAddedNotification object:self userInfo:[NSDictionary dictionaryWithObject:layer forKey:ADImageViewLayer]];
    [self setNeedsDisplay:YES];
}

- (void) insertLayer:(id<ADImageLayer>)layer atIndex:(NSUInteger)index
{
    [layers insertObject:layer atIndex:index];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:ADImageViewLayerAddedNotification object:self userInfo:[NSDictionary dictionaryWithObject:layer forKey:ADImageViewLayer]];
    [self setNeedsDisplay:YES];
}

- (NSUInteger) layerCount
{
    return [layers count];
}

- (id<ADImageLayer>) layerAtIndex:(NSUInteger)index
{
    return [layers objectAtIndex:index];
}

- (void) removeLayerAtIndex:(NSUInteger)index
{
    id<ADImageLayer> layer = [layers objectAtIndex:index];
    [layers removeObjectAtIndex:index];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:ADImageViewLayerDeletedNotification object:self userInfo:[NSDictionary dictionaryWithObject:layer forKey:ADImageViewLayer]];
    [self setNeedsDisplay:YES];
}

- (void) removeLayer:(id<ADImageLayer>)layer
{
    [layers removeObject:layer];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:ADImageViewLayerDeletedNotification object:self userInfo:[NSDictionary dictionaryWithObject:layer forKey:ADImageViewLayer]];
    [self setNeedsDisplay:YES];
}

- (BOOL) layerIsVisibleAtIndex:(NSUInteger)index
{
    id<ADImageLayer> layer = [self layerAtIndex:index];
    return [layer isVisible];
}

- (void) setLayerAtIndex:(NSUInteger)index isVisible:(BOOL)visible
{
    id<ADImageLayer> layer = [self layerAtIndex:index];
    [layer setVisible:visible];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:ADImageViewLayerVisibilityChangedNotification object:self userInfo:[NSDictionary dictionaryWithObject:layer forKey:ADImageViewLayer]];
    [self setNeedsDisplay:YES];
}

# pragma mark Events

- (void) mouseDown:(NSEvent *)theEvent
{
    NSPoint eventLocation = [theEvent locationInWindow];
    NSPoint vl = [self convertPoint:eventLocation fromView:nil];
    NSPoint no = [self imageLocationFromViewLocation:vl];
    [self setOrigin:no];
}

- (void)magnifyWithEvent:(NSEvent *)event
{
    CGFloat nscale = scale*(1.0+[event magnification]);
    [self setScale:nscale];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if([theEvent deltaX]!=0 || [theEvent deltaY]!=0){
    NSPoint vcent = [self viewLocationFromImageLocation:origin];
    vcent.x-=[theEvent deltaX];
    vcent.y+=[theEvent deltaY];
    NSPoint norig = [self imageLocationFromViewLocation:vcent];
    [self setOrigin:norig];
    }
}
@end
