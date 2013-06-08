//
//  ADNormalImageItemViewController.m
//  Image Reduction
//
//  Created by Don Willems on 08-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADImageItemViewController.h"

@interface ADImageItemViewController (private)

@end

@implementation ADImageItemViewController

- (id) initWithDisplaySize:(ADProjectStructureItemSize)size
{
    NSString *nibNameOrNil = @"ADNormalImageItemView";
    NSBundle *nibBundleOrNil = [NSBundle bundleForClass:[ADImageItemViewController class]];
    displaySize = size;
    switch (displaySize) {
        case ADProjectStructureItemSizeLarge:
            nibNameOrNil = @"ADLargeImageItemView";
            break;
        case ADProjectStructureItemSizeSmall:
            nibNameOrNil = @"ADSmallImageItemView";
            break;
            
        default:
            break;
    }
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"Nib: %@   View: %@",[self nibBundle],[self view] );
        namelabel = [[self view] viewWithTag:1];
        thumbnailview = [[self view] viewWithTag:0];
        NSLog(@"name label: %@",namelabel);
    }
    return self;
}

- (ADProjectStructureItemSize) displaySize
{
    return displaySize;
}

- (void) setItem:(id)nitem
{
    [super setItem:nitem];
    if([item isKindOfClass:[ADDataObjectWrapper class]]){
        ADDataObjectWrapper *wrapper = (ADDataObjectWrapper*) item;
        [namelabel setStringValue:[[wrapper filename] stringByDeletingPathExtension]];
        [thumbnailview setImage:[wrapper thumbnail]];
    }
}

@end
