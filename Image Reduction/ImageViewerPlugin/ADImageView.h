//
//  ADImageView.h
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

#import <Cocoa/Cocoa.h>
#import <ImageReductionPlugin/ImageReductionPlugin.h>
#import "ADImageLayer.h"

#define ADImageViewScaledChangedNotification @"ADImageViewScaledChangedNotification"
#define ADImageViewOriginChangedNotification @"ADImageViewOriginChangedNotification"
#define ADImageViewLayerAddedNotification @"ADImageViewLayerAddedNotification"
#define ADImageViewLayerDeletedNotification @"ADImageViewLayerDeletedNotification"
#define ADImageViewLayerVisibilityChangedNotification @"ADImageViewLayerVisibilityChangedNotification"


#define ADImageViewOriginalOrigin @"ADImageViewOriginalOrigin"
#define ADImageViewNewOrigin @"ADImageViewNewOrigin"
#define ADImageViewOriginalScale @"ADImageViewOriginalScale"
#define ADImageViewNewScale @"ADImageViewNewScale"
#define ADImageViewLayer @"ADImageViewLayer"



@interface ADImageView : NSView {
    ADImage *image;
    NSColor *backgroundColor;
    double scale;
    NSPoint origin;
    NSMutableArray *layers;
    NSUInteger activeLayer;
}

@property (readwrite) ADImage *image;
@property (readwrite) NSColor *backgroundColor;
@property (readwrite) double scale;
@property (readwrite) NSPoint origin;

- (NSRect) visibleViewRect;
- (NSRect) visibleImageRect;
- (NSRect) imageRectFromViewRect:(NSRect)viewRect;
- (NSRect) viewRectFromImageRect:(NSRect)imageRect;
- (NSPoint) imageLocationFromViewLocation:(NSPoint)location;
- (NSPoint) viewLocationFromImageLocation:(NSPoint)location;

- (void) addLayer:(id<ADImageLayer>)layer;
- (void) insertLayer:(id<ADImageLayer>)layer atIndex:(NSUInteger)index;
- (NSUInteger) layerCount;
- (id<ADImageLayer>) layerAtIndex:(NSUInteger)index;
- (void) removeLayerAtIndex:(NSUInteger)index;
- (void) removeLayer:(id<ADImageLayer>)layer;
- (BOOL) layerIsVisibleAtIndex:(NSUInteger)index;
- (void) setLayerAtIndex:(NSUInteger)index isVisible:(BOOL)visible;

@end
