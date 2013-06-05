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
    self = [self initWithNibName:@"ADNavigationViewPlugin" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    self = [super initWithNibName:nibNameOrNil bundle:bundle];
    if (self) {
        // Initialization code here.
        NSLog(@"Loading navigation view plugin");
    }
    
    return self;
}

- (NSString*) name
{
    return @"Project Navigator";
}

- (void) initialize
{
    
}

- (void) setProjectStructureItems:(NSArray*)nitems
{
    if(!items){
        items = [NSMutableArray array];
    }else{
        [items removeAllObjects];
    }
    for(id item in nitems){
        if([item isKindOfClass:[ADDataObjectWrapper class]]){
            ADDataObjectWrapper *wrapper = (ADDataObjectWrapper*)item;
            if([[wrapper type] isEqualToString:ADPropertyTypeImage]){
                NSString *group = @"Images";
                ADProperty *prop = [wrapper propertyForKey:ADPropertyImageType];
                if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeBias]){
                    group = @"Images/Bias images";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeCalibrated]){
                    group = @"Images/Calibrated images";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeDark]){
                    group = @"Images/Dark fields";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeFlat]){
                    group = @"Images/Flat fields";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeMasterFlat]){
                    group = @"Images/Flat fields";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeStacked]){
                    group = @"Images/Stacked images";
                }else if([[prop propertyValueKey] isEqualToString:ADPropertyImageTypeRaw]){
                    group = @"Images/Science images";
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
    [self createItem:dict addToGroup:grouppath];
}

- (void) createItem:(NSDictionary*)item addToGroup:(NSString*)grouppath
{
    NSDictionary *groupd = [self groupWithPath:grouppath];
    if(!groupd){
        groupd = [self createGroupWithPath:grouppath];
    }
    NSMutableArray *children = [groupd objectForKey:@"ADChildren"];
    [children addObject:item];
}

- (NSDictionary*) groupWithPath:(NSString*)grouppath
{
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
    if([gpc count] >= [ppc count]) return nil;
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

- (ADViewController*) viewController
{
    return self;
}

- (ADViewArea) preferredViewArea
{
    return ADNavigationSideViewArea;
}

#pragma mark Data source methods
- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index
{
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if([item isKindOfClass:[NSDictionary class]]){
        NSArray *children = [(NSDictionary*)item objectForKey:@"ADChildren"];
        if(index<0 || !children || index>=[children count]) return nil;
        return [children objectAtIndex:index];
    }
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if([item isKindOfClass:[NSDictionary class]]){
        NSArray *children = [(NSDictionary*)item objectForKey:@"ADChildren"];
        return (children && [children count]>0);
    }
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView itemForPersistentObject:(id)object
{
    return nil;
}

- (NSArray *)outlineView:(NSOutlineView *)outlineView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedItems:(NSArray *)items
{
    return [NSArray array];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
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
        if(name) return name;
    }
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView persistentObjectForItem:(id)item
{
    return nil;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    
}

- (void)outlineView:(NSOutlineView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    return NSDragOperationEvery;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
    return NO;
}
@end
