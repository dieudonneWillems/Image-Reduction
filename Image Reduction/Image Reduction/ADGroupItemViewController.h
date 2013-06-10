//
//  ADGroupItemViewController.h
//  Image Reduction
//
//  Created by Don Willems on 11-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <ImageReductionPlugin/ImageReductionPlugin.h>

@interface ADGroupItemViewController : ADProjectStructureGroupViewController {
    IBOutlet NSTextField *titleview;
    IBOutlet NSImageView *iconview;
    IBOutlet NSTextField *countview;
}

@end
