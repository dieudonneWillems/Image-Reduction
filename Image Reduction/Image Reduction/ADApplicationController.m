//
//  ADApplicationController.m
//  Reduction
//
//  Created by Don Willems on 25-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADApplicationController.h"
#import "ADPluginController.h"

@implementation ADApplicationController

- (void) awakeFromNib
{
    [ADPluginController defaultPluginController];
}

@end
