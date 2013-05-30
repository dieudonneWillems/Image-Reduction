//
//  ADImportController.m
//  Reduction
//
//  Created by Don Willems on 24-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADImportController.h"
#import "ADPluginController.h"

static ADImportController *controller;

@interface ADImportController (private)
- (void) startImportingFileWithUserInfo:(NSDictionary*)ui;
- (void) finishedImporting:(NSString*)path;
- (void) performImport:(NSDictionary*)userinfo;
- (void) postNotificationOnMainThreadWithName:(NSString*)name userObject:(id)uobject andKey:(NSString*)key;
- (void) postNotificationOnMainThread:(NSNotification*)not;
- (void) postNotificationWithName:(NSString*)name userObject:(id)uobject andKey:(NSString*)key;
- (void) postNotification:(NSNotification*)not;
@end

@implementation ADImportController

+ (ADImportController*) sharedImportController
{
    if(!controller){
        controller = [[ADImportController alloc] init];
    }
    return controller;
}

- (id) init
{
    self = [super init];
    if(self){
        importers = [NSMutableArray array];
        stack = [NSMutableArray array];
        running = NO;
        [self reloadImporters];
    }
    return self;
}

- (void) reloadImporters
{
    ADPluginController *pluginContr = [ADPluginController defaultPluginController];
    [importers removeAllObjects];
    [importers addObjectsFromArray:[pluginContr importers]];
}

- (NSArray*) supportedFileTypes
{
    NSMutableArray *array = [NSMutableArray array];
    for(id<ADImporter> importer in importers){
        [array addObjectsFromArray:[importer supportedFileTypes]];
    }
    return array;
}

- (id<ADImporter>) importerForFile:(NSString*)path
{
    NSString *extension = [path pathExtension];
    for(id<ADImporter> importer in importers){
        NSArray *exts = [importer supportedFileTypes];
        if([exts containsObject:extension]){
            return importer;
        }
    }
    return nil;
}

- (void) addFileToStack:(NSString*)path withSeed:(NSUInteger)seed
{
    NSDictionary *ui = [NSDictionary dictionaryWithObjectsAndKeys:path,@"PATH",[NSNumber numberWithUnsignedInteger:seed],@"SEED", nil];
    [stack addObject:ui];
    NSLog(@"Adding file: %@",path);
    [self postNotificationWithName:ADImportFileAddedNotification userObject:path andKey:ADImportFilePath];
    if(!running){
        [self startImportingFileWithUserInfo:[stack objectAtIndex:0]];
    }
}

- (BOOL) running
{
    return running;
}

- (void) startImportingFileWithUserInfo:(NSDictionary*)ui
{
    if(!running){
        [self postNotification:[NSNotification notificationWithName:ADImportStartedNotification object:self]];
    }
    running = YES;
    [stack removeObject:ui];
    NSString *path = [ui objectForKey:@"PATH"];
    [self postNotificationWithName:ADImportFileStartedNotification userObject:path andKey:ADImportFilePath];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(performImport:) object:ui];
    [thread start];
}

- (void) performImport:(NSDictionary*)userinfo
{
    NSString *path = [userinfo objectForKey:@"PATH"];
    NSUInteger seed = [[userinfo objectForKey:@"SEED"] unsignedIntegerValue];
    NSLog(@"Perform importing %@",path);
    id<ADImporter> importer = [self importerForFile:path];
    id object = [importer importFileAtPath:path withSeed:seed];
    NSLog(@"object: %@",object);
    NSDictionary *userinfo2 = [NSDictionary dictionaryWithObjectsAndKeys:path,ADImportFilePath,object,ADImportFileObject, nil];
    [self postNotificationOnMainThread:[NSNotification notificationWithName:ADImportFileFinishedNotification object:self userInfo:userinfo2]];
    [self performSelectorOnMainThread:@selector(finishedImporting:) withObject:path waitUntilDone:YES];
}

- (void) finishedImporting:(NSString*)path
{
    NSLog(@"Finished importing %@",path);
    if([stack count]>0){
        NSDictionary *nextpath = [stack objectAtIndex:0];
        [self startImportingFileWithUserInfo:nextpath];
    }else{
        running = NO;
        [self postNotification:[NSNotification notificationWithName:ADImportFinishedNotification object:self]];
        NSLog(@"Finished importing all files.");
    }
}

- (void) postNotificationOnMainThreadWithName:(NSString*)name userObject:(id)uobject andKey:(NSString*)key
{
    NSNotification *not = [NSNotification notificationWithName:name object:self userInfo:[NSDictionary dictionaryWithObject:uobject forKey:key]];
    [self postNotificationOnMainThread:not];
}

- (void) postNotificationOnMainThread:(NSNotification*)not
{
    [self performSelectorOnMainThread:@selector(postNotification:) withObject:not waitUntilDone:YES];
}

- (void) postNotificationWithName:(NSString*)name userObject:(id)uobject andKey:(NSString*)key
{
    NSNotification *not = [NSNotification notificationWithName:name object:self userInfo:[NSDictionary dictionaryWithObject:uobject forKey:key]];
    [self postNotification:not];
}

- (void) postNotification:(NSNotification*)not
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotification:not];
}

@end
