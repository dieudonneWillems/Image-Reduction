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
#import "ADNavigationViewController.h"

@interface ADNavigationViewPlugin (private)
- (NSDictionary*) createGroupWithPath:(NSString*)path;
- (void) createItemWithDataWrapper:(ADDataObjectWrapper*)wrapper addToGroup:(NSString*)grouppath;
- (void) createItem:(NSDictionary*)item addToGroup:(NSString*)grouppath;
- (NSDictionary*) groupWithPath:(NSString*)grouppath;
- (NSDictionary*) groupWithPath:(NSString *)grouppath inParentGroup:(NSDictionary*)parent atPath:(NSString*)parentpath;
@end

@implementation ADNavigationViewPlugin

- (id) init
{
    self = [super init];
    return self;
}

- (NSString*) name
{
    return @"Project Navigator";
}

- (void) initialize
{
    
}

- (ADViewController*) createViewController
{
    ADNavigationViewController *vc = [[ADNavigationViewController alloc] init];
    [vc setPlugin:self];
    return vc;
}

- (ADPreferencePane*) preferencePane
{
    return nil;
}

- (id<ADProjectStructureItemViewPlugin>) itemViewPluginForItem:(id)item
{
    for(id<ADProjectStructureItemViewPlugin> itempi in itemViewPlugins){
        if([itempi canDisplayItem:item]){
            return itempi;
        }
    }
    return nil;
}

- (void) setItemViewPlugins:(NSArray*)itemviewpis
{
    itemViewPlugins = itemviewpis;
}
@end
