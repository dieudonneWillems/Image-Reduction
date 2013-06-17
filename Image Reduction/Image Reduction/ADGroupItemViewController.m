//
//  ADGroupItemViewController.m
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
//  Created by Don Willems on 11-06-13.
//

#import "ADGroupItemViewController.h"

@interface ADGroupItemViewController ()

@end

@implementation ADGroupItemViewController

- (id) init
{
    NSString *nibname = @"ADGroupItemViewFactory";
    NSBundle *bundle = [NSBundle bundleForClass:[ADGroupItemViewController class]];
    self = [super initWithNibName:nibname bundle:bundle];
    if (self) {
        iconview = [[self view] viewWithTag:0];
        titleview = [[self view] viewWithTag:1];
        countview = [[self view] viewWithTag:2];
    }
    return self;
}

- (void) setTitle:(NSString*) title
{
    [titleview setStringValue:title];
}

- (void) setIcon:(NSImage*) icon
{
    [iconview setImage:icon];
}

- (void) setObjectCount:(NSUInteger)count
{
    [countview setStringValue:[NSString stringWithFormat:@"%ld",count]];
}

@end
