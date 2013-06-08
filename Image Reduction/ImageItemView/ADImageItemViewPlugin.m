//
//  ADImageItemViewPlugin.m
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
//  Created by Don Willems on 08-06-13.
//

#import "ADImageItemViewPlugin.h"
#import "ADImageItemViewController.h"

@implementation ADImageItemViewPlugin

- (NSString*) name
{
    return @"Image";
}

- (void) initialize
{
    
}

@synthesize isProcessing;

- (ADPreferencePane*) preferencePane
{
    return nil;
}

- (ADProjectStructureItemViewController*) createItemViewWithDisplaySize:(ADProjectStructureItemSize) displaySize
{
    return [[ADImageItemViewController alloc] initWithDisplaySize:displaySize];
}

- (BOOL) canDisplayItem:(id)item
{
    if([item isKindOfClass:[ADDataObjectWrapper class]]){
        ADDataObjectWrapper *wrapper = (ADDataObjectWrapper*)item;
        NSString *type = [wrapper type];
        if([type isEqualToString:ADPropertyTypeImage]){
            return YES;
        }
    }
    return NO;
}

@end
