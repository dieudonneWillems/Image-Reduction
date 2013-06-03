//
//  ADViewController.m
//  Image Reduction
//
//  Created by Don Willems on 03-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADViewController.h"
#import "ADDataObjectWrapper.h"

@interface ADViewController (private)

@end

@implementation ADViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (ADViewArea) preferredViewArea
{
    return ADMainViewArea;
}

@end
