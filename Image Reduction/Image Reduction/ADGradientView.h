//
//  ADGradientView.h
//  Image Reduction
//
//  Created by Don Willems on 16-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ADGradientView : NSView {
    NSColor *topColor;
    NSColor *bottomColor;
    NSColor *topLineColor;
    NSColor *bottomLineColor;
}

@property (readwrite) NSColor *topColor;
@property (readwrite) NSColor *bottomColor;
@property (readwrite) NSColor *topLineColor;
@property (readwrite) NSColor *bottomLineColor;

@end
