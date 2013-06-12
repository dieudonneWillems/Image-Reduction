//
//  ADImageViewController.m
//  Image Reduction
//
//  Created by Don Willems on 12-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADImageViewController.h"
#import "ADImageView.h"

@interface ADImageViewController ()

@end

@implementation ADImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void) setDataObjectWrapper:(ADDataObjectWrapper *)ndataObjectWrapper
{
    if([ndataObjectWrapper dataObject] && [[ndataObjectWrapper dataObject] isKindOfClass:[ADImage class]]){
        [(ADImageView*) [self view] setImage:(ADImage*)[ndataObjectWrapper dataObject]];
        [super setDataObjectWrapper:ndataObjectWrapper];
    }
}

- (ADViewArea) preferredViewArea
{
    return ADMainViewArea;
}
@end
