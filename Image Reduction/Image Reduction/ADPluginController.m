//
//  ADPluginController.m
//  Reduction
//
//  Created by Don Willems on 24-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
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
