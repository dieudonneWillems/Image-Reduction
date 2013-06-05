//
//  ADNavigationViewPluginViewController.m
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

//  Created by Don Willems on 05-06-13.
//

#import "ADNavigationViewPlugin.h"

@interface ADNavigationViewPlugin (private)

@end

@implementation ADNavigationViewPlugin

- (id) init
{
    self = [self initWithNibName:@"ADNavigationViewPlugin" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self = [super initWithNibName:nibNameOrNil bundle:bundle];
    if (self) {
        // Initialization code here.
        NSLog(@"Loading navigation view plugin");
    }
    
    return self;
}

- (NSString*) name
{
    return @"Project Navigator";
}

- (void) initialize
{
    
}

- (ADPreferencePane*) preferencePane
{
    return nil;
}

- (ADViewController*) viewController
{
    return self;
}

- (ADViewArea) preferredViewArea
{
    return ADNavigationSideViewArea;
}

@end
