//
//  FITSImage.h
//  ObjCFITSIO
//
//  Created by Don Willems on 22-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ImageReductionPlugin/ImageReductionPlugin.h>

@class FITSData,FITSHeader;

@interface FITSImage : ADImage {
}

+ (FITSImage*) createImageFromData:(FITSData*)data atPlaneIndex:(NSUInteger)plane withHeader:(FITSHeader*)header;

@end
