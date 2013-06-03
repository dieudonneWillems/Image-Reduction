//
//  ADViewPlugin.h
//  Image Reduction
//
//  Created by Don Willems on 03-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADImageReductionPlugin.h"
#import "ADViewController.h"

@protocol ADViewPlugin <ADImageReductionPlugin>

- (ADViewController*) viewController;

@end
