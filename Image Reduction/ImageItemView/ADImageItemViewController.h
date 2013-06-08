//
//  ADNormalImageItemViewController.h
//  Image Reduction
//
//  Created by Don Willems on 08-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ImageReductionPlugin/ImageReductionPlugin.h>

@interface ADImageItemViewController : ADProjectStructureItemViewController {
    ADProjectStructureItemSize displaySize;
    NSTextField *namelabel;
}

- (id) initWithDisplaySize:(ADProjectStructureItemSize)size;
@end
