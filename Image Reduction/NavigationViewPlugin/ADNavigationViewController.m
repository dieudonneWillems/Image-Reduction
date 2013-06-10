//
//  ADNavigationViewController.m
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
//  Created by Don Willems on 06-06-13.
//

#import "ADNavigationViewController.h"

@interface ADNavigationViewController (private)
- (NSDictionary*) createGroupWithPath:(NSString*)path;
- (void) createItemWithDataWrapper:(ADDataObjectWrapper*)wrapper addToGroup:(NSString*)grouppath;
- (void) createItem:(NSDictionary*)item addToGroup:(NSString*)grouppath;
- (NSDictionary*) groupWithPath:(NSString*)grouppath;
- (NSDictionary*) groupWithPath:(NSString *)grouppath inParentGroup:(NSDictionary*)parent atPath:(NSString*)parentpath;
@end

@implementation ADNavigationViewController

- (id)init
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self = [self initWithNibName:@"ADNavigationViewPlugin" bundle:bundle];
    if (self) {
        // Initialization code here.
        NSLog(@"1 Loading navigation view plugin");
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        NSLog(@"2 Loading navigation view plugin");
    }
    return self;
}


- (void) setProjectStructureItems:(NSArray*)nitems
{
    [navOutline setDataSource:self];
    if(!items){
        items = [NSMutableArray array];
    }else{
        [items removeAllObjects];
    }
    for(id item in nitems){
        if([item isKindOfClass:[ADDataObjectWrapper class]]){
            ADDataObjectWrapper *wrapper = (ADDataObjectWrapper*)item;
            if([[wrapper type] isEqualToString:ADPropertyTypeImage]){
                NSString *group = nil;
                ADProperty *prop = [wrapper propertyForKey:ADPropertyImageType];
                if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeBias]){
                    group = @"Bias images";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeCalibrated]){
                    group = @"Calibrated images";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeDark]){
                    group = @"Dark fields";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeFlat]){
                    group = @"Flat fields";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeMasterFlat]){
                    group = @"Flat fields";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeStacked]){
                    group = @"Stacked images";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeRaw]){
                    group = @"Science images";
                }
                [self createItemWithDataWrapper:wrapper addToGroup:group];
            }
        }
    }
    NSLog(@"items: %@",items);
    [navOutline reloadData];
    [navOutline needsDisplay];
}

- (NSDictionary*) createGroupWithPath:(NSString*)path
{
    NSLog(@"Create group: %@",path);
    NSMutableDictionary *grp = [NSMutableDictionary dictionary];
    [grp setObject:[path lastPathComponent] forKey:@"ADName"];
    [grp setObject:path forKey:@"ADPath"];
    [grp setObject:[NSMutableArray array] forKey:@"ADChildren"];
    NSString *parent = [path stringByDeletingLastPathComponent];
    NSDictionary *parentd = [self groupWithPath:parent];
    if(!parentd && [parent length]>0){
        parentd = [self createGroupWithPath:parent];
    }
    if(parentd){
        NSMutableArray *children = [parentd objectForKey:@"ADChildren"];
        [children addObject:grp];
    }else {
        [items addObject:grp];
    }
    return grp;
}

- (void) createItemWithDataWrapper:(ADDataObjectWrapper*)wrapper addToGroup:(NSString*)grouppath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *name = [wrapper filename];
    [dict setObject:name forKey:@"ADName"];
    [dict setObject:[grouppath stringByAppendingPathComponent:name] forKey:@"ADPath"];
    [dict setObject:[wrapper thumbnail] forKey:@"ADThumbnail"];
    [dict setObject:wrapper forKey:@"ADDataObjectWrapper"];
    [self createItem:dict addToGroup:grouppath];
}

- (void) createItem:(NSDictionary*)item addToGroup:(NSString*)grouppath
{
    if(grouppath){
        NSDictionary *groupd = [self groupWithPath:grouppath];
        if(!groupd){
            groupd = [self createGroupWithPath:grouppath];
        }
        NSMutableArray *children = [groupd objectForKey:@"ADChildren"];
        [children addObject:item];
    }else{
        [items addObject:item];
    }
}

- (NSDictionary*) groupWithPath:(NSString*)grouppath
{
    if(!grouppath || [grouppath length]<=0) return nil;
    NSArray *pc = [grouppath pathComponents];
    for(NSDictionary* item in items){
        NSString *path = [item objectForKey:@"ADPath"];
        if([path isEqualToString:[pc objectAtIndex:0]]){
            return [self groupWithPath:grouppath inParentGroup:item atPath:path];
            break;
        }
    }
    return nil;
}

- (NSDictionary*) groupWithPath:(NSString *)grouppath inParentGroup:(NSDictionary*)parent atPath:(NSString*)parentpath
{
    if([parentpath isEqualToString:grouppath]) return parent;
    NSArray *gpc = [grouppath pathComponents];
    NSArray *ppc = [parentpath pathComponents];
    if([gpc count] <= [ppc count]) return nil;
    NSString *newpath = [parentpath stringByAppendingPathComponent:[gpc objectAtIndex:[ppc count]]];
    NSArray *children = [parent objectForKey:@"ADChildren"];
    for(NSDictionary* item in children){
        NSString *path = [item objectForKey:@"ADPath"];
        if([path isEqualToString:newpath]){
            NSDictionary *nd = [self groupWithPath:grouppath inParentGroup:item atPath:newpath];
            return nd;
        }
    }
    return nil;
}

- (ADPreferencePane*) preferencePane
{
    return nil;
}


- (ADViewArea) preferredViewArea
{
    return ADNavigationSideViewArea;
}

#pragma mark Data source methods

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if(!item) return [items objectAtIndex:index];
    if([item isKindOfClass:[NSDictionary class]]){
        NSArray *children = [(NSDictionary*)item objectForKey:@"ADChildren"];
        if(index<0 || !children || index>=[children count]) return nil;
        return [children objectAtIndex:index];
    }
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if(!item) return ([items count]>0);
    if([item isKindOfClass:[NSDictionary class]]){
        NSArray *children = [(NSDictionary*)item objectForKey:@"ADChildren"];
        return (children && [children count]>0);
    }
    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if(!item) return [items count];
    if([item isKindOfClass:[NSDictionary class]]){
        NSArray *children = [(NSDictionary*)item objectForKey:@"ADChildren"];
        if(!children) return 0;
        return [children count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if([item isKindOfClass:[NSDictionary class]]){
        NSString *name = [(NSDictionary*)item objectForKey:@"ADName"];
        if(name) return [name stringByDeletingPathExtension];
    }
    return @"TEST";
}


#pragma mark Delegate methods

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    /*
    if([item isKindOfClass:[NSDictionary class]]){
        NSArray *children = [(NSDictionary*)item objectForKey:@"ADChildren"];
        NSString *path = [item objectForKey:@"ADPath"];
        NSArray *pcs = [path pathComponents];
        if(children && [children count]>0 && [pcs count]==1) return YES;
    }*/
    return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if([item isKindOfClass:[NSDictionary class]]){
        ADDataObjectWrapper *wrapper = [(NSDictionary*)item objectForKey:@"ADDataObjectWrapper"];
        if(wrapper){
            id<ADProjectStructureItemViewPlugin> ipl = [[self plugin] itemViewPluginForItem:wrapper];
            ADProjectStructureItemViewController *vc = [ipl createItemViewWithDisplaySize:ADProjectStructureItemSizeLarge];
            [vc setItem:wrapper];
            return [vc view];
        }else{
            NSArray *children = [(NSDictionary*)item objectForKey:@"ADChildren"];
            if([children count]>0){
                ADProjectStructureGroupViewController* gvc = [[self plugin] createGroupViewController];
                NSString *name = [(NSDictionary*)item objectForKey:@"ADName"];
                [gvc setTitle:name];
                [gvc setObjectCount:[children count]];
                return [gvc view];
            }
        }
    }
    return nil;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    NSView *view = [self outlineView:outlineView viewForTableColumn:nil item:item];
    if(view) return [view frame].size.height;
    return 12.;
}
@end
