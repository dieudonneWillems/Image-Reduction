//
//  ADPluginController.m
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
//  Created by Don Willems on 24-05-13.
//
//

#import "ADPluginController.h"

static ADPluginController* pluginController;
static NSString *ext = @"plugin";
static NSString *appSupportSubpath = @"Application Support/Image Reduction/PlugIns";

@interface ADPluginController (private)
- (void) loadAllPlugins;
- (NSMutableArray*) allBundles;
- (BOOL) plugInClassIsValid:(Class)plugInClass;
@end

@implementation ADPluginController

+ (ADPluginController*) defaultPluginController
{
    if(!pluginController){
        pluginController = [[ADPluginController alloc] init];
    }
    return pluginController;
}

- (id) init
{
    self = [super init];
    if(self){
        plugins = [NSMutableArray array];
        [self loadAllPlugins];
    }
    return self;
}

- (NSArray*) importers
{
    return [self pluginsConformingToProtocol:@protocol(ADImporter)];
}

- (NSArray*) viewPlugins
{
    return [self pluginsConformingToProtocol:@protocol(ADViewPlugin)];
}

- (NSArray*) viewPluginsWithPreferredViewArea:(ADViewArea)area
{
    NSArray *views = [self viewPlugins];
    NSMutableArray *prefviews = [NSMutableArray array];
    for(id<ADViewPlugin> vp in views){
        if([[vp viewController] preferredViewArea]==area){
            [prefviews addObject:vp];
        }
    }
    return prefviews;
}

- (NSArray*) pluginsConformingToProtocol:(Protocol *)aProtocol
{
    NSMutableArray *array = [NSMutableArray array];
    for(id plugin in plugins){
        if([plugin conformsToProtocol:aProtocol]){
            [array addObject:plugin];
        }
    }
    return array;
}

- (void) loadAllPlugins
{
    NSMutableArray *bundlePaths;
    NSEnumerator *pathEnum;
    NSString *currPath;
    NSBundle *currBundle;
    Class currPrincipalClass;
    id currInstance;
    bundlePaths = [NSMutableArray array];
    [bundlePaths addObjectsFromArray:[self allBundles]];
    pathEnum = [bundlePaths objectEnumerator];
    while(currPath = [pathEnum nextObject]){
        NSLog(@"current path=%@",currPath);
        currBundle = [NSBundle bundleWithPath:currPath];
        if(currBundle){
            currPrincipalClass = [currBundle principalClass];
            if(currPrincipalClass && [self plugInClassIsValid:currPrincipalClass]){
                currInstance = [[currPrincipalClass alloc] init];
                if(currInstance){
                    [plugins addObject:currInstance];
                    [currInstance initialize];
                }
            }
        }
    }
}

- (NSMutableArray*) allBundles
{
    NSArray *librarySearchPaths;
    NSEnumerator *searchPathEnum;
    NSString *currPath;
    NSMutableArray *bundleSearchPaths = [NSMutableArray array];
    NSMutableArray *allBundles = [NSMutableArray array];
    librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
    searchPathEnum = [librarySearchPaths objectEnumerator];
    while(currPath = [searchPathEnum nextObject]){
        [bundleSearchPaths addObject:[currPath stringByAppendingPathComponent:appSupportSubpath]];
    }
    [bundleSearchPaths addObject:[[NSBundle mainBundle] builtInPlugInsPath]];
    searchPathEnum = [bundleSearchPaths objectEnumerator];
    while(currPath = [searchPathEnum nextObject]){
        NSDirectoryEnumerator *bundleEnum;
        NSString *currBundlePath;
        bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
        if(bundleEnum) {
            while(currBundlePath = [bundleEnum nextObject]){
                if([[currBundlePath pathExtension] isEqualToString:ext]){
                    [allBundles addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
                }
            }
        }
    }
    return allBundles;
}

- (BOOL) plugInClassIsValid:(Class)plugInClass
{
    if([plugInClass conformsToProtocol:@protocol(ADImageReductionPlugin)]){
        return YES;
    }
    return NO;
}
@end
