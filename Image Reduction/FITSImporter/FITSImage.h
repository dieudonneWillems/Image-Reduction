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

@interface FITSImage : NSImage <ADImage> {
    double **pixels;
    FITSHeader *fitsheader;
    double averageValue;
    double medianValue;
    double minimumValue;
    double maximumValue;
    double standardDeviationValue;
    ADScalingFunction *defaultScaling;
    NSString *type;
}

+ (FITSImage*) createImageFromData:(FITSData*)data atPlaneIndex:(NSUInteger)plane;

@end
