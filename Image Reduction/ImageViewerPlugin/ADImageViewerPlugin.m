//
//  ADImageViewerPlugin.m
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
//
//  Created by Don Willems on 12-06-13.
//


#import "ADImageViewerPlugin.h"
#import "ADImageViewController.h"
#import <ImageViewLayerPlugin/ImageViewLayerPlugin.h>

static ADDataViewController *__dataviewcontroller;

@interface ADImageViewerPlugin (private)
- (void) selectionNotificationReceived:(NSNotification*)not;
- (void) updateNotificationRecieved:(NSNotification*)not;
@end

@implementation ADImageViewerPlugin


- (NSString*) name
{
    return @"Image";
}

- (void) initialize
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateNotificationRecieved:) name:ADDataObjectUpdatedNotification object:nil];
    [nc addObserver:self selector:@selector(selectionNotificationReceived:) name:ADDataObjectSelectionChangedNotification object:nil];
    //[nc addObserver:self selector:@selector(selectionNotificationReceived:) name:ADDataObjectSelectionWillChangeNotification object:nil];
}

- (ADPreferencePane*) preferencePane
{
    return nil;
}

- (ADViewController*) createViewController
{
    if(__dataviewcontroller) return __dataviewcontroller;
    NSString* nibname = @"ADImageView";
    NSBundle* bundle = [NSBundle bundleForClass:[ADImageViewerPlugin class]];
    __dataviewcontroller = [[ADImageViewController alloc] initWithNibName:nibname bundle:bundle];
    return __dataviewcontroller;
}


- (void) selectionNotificationReceived:(NSNotification*)not
{
    ADDataObjectWrapper *dow = (ADDataObjectWrapper*)[[not userInfo] objectForKey:ADCurrentDataObject];
    if(dow){
        [__dataviewcontroller setDataObjectWrapper:dow];
    }
}

- (void) updateNotificationRecieved:(NSNotification*)not
{
    ADDataObjectWrapper *dow = (ADDataObjectWrapper*)[[not userInfo] objectForKey:ADUpdatedDataObject];
    if([dow isEqual:[__dataviewcontroller dataObjectWrapper]]){
        [__dataviewcontroller setDataObjectWrapper:dow];
    }
}
@end
