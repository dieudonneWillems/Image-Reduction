//
//  ADGroupItemViewController.m
//  Image Reduction
//
//  Created by Don Willems on 11-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
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
