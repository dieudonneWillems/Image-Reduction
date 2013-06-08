//
//  ADLargeImageItemViewController.m
//  Image Reduction
//
//  Created by Don Willems on 08-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADLargeImageItemViewController.h"

@interface ADLargeImageItemViewController ()

@end

@implementation ADLargeImageItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (ADProjectStructureItemSize) displaySize
{
    return ADProjectStructureItemSizeLarge;
}


@end
