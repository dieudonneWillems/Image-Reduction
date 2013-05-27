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
- (void) startImportingFile:(NSString*)path;
- (void) finishedImporting:(NSString*)path;
- (void) performImport:(NSString*)path;
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

- (void) addFileToStack:(NSString*)path
{
    [stack addObject:path];
    NSLog(@"Adding file: %@",path);
    [self postNotificationWithName:ADImportFileAddedNotification userObject:path andKey:ADImportFilePath];
    if(!running){
        [self startImportingFile:[stack objectAtIndex:0]];
    }
}

- (BOOL) running
{
    return running;
}

- (void) startImportingFile:(NSString*)path
{
    NSLog(@"Start importing %@",path);
    if(!running){
        [self postNotification:[NSNotification notificationWithName:ADImportStartedNotification object:self]];
    }
    running = YES;
    [stack removeObject:path];
    [self postNotificationWithName:ADImportFileStartedNotification userObject:path andKey:ADImportFilePath];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(performImport:) object:path];
    [thread start];
}

- (void) performImport:(NSString*)path
{
    NSLog(@"Perform importing %@",path);
    id<ADImporter> importer = [self importerForFile:path];
    id object = [importer importFileAtPath:path];
    NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:path,ADImportFilePath,object,ADImportFileObject, nil];
    [self postNotificationOnMainThread:[NSNotification notificationWithName:ADImportFileFinishedNotification object:self userInfo:userinfo]];
    [self performSelectorOnMainThread:@selector(finishedImporting:) withObject:path waitUntilDone:YES];
}

- (void) finishedImporting:(NSString*)path
{
    NSLog(@"Finished importing %@",path);
    if([stack count]>0){
        NSString *nextpath = [stack objectAtIndex:0];
        [self startImportingFile:nextpath];
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
