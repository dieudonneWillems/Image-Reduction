//
//  ADViewController.h
//  Image Reduction
//
//  Created by Don Willems on 03-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ADDataObjectWrapper;

typedef enum __ADViewArea {
    ADNavigationSideViewArea,
    ADMainViewArea,
    ADInformationSideViewArea
} ADViewArea;

@interface ADViewController : NSViewController

- (ADViewArea) preferredViewArea;
@end
