//
//  ADDocument.m
//  Reduction
//
//  Created by Don Willems on 23-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADDocument.h"
#import "ADPluginController.h"
#import "ADImportController.h"

@interface ADDocument (private)
- (void) importNotificationRecieved:(NSNotification*)not;
- (void) updateNotificationRecieved:(NSNotification*)not;
- (void) addToChangedSet:(ADDataObjectWrapper*)wrapper;
@end

@implementation ADDocument

- (id)init
{
    self = [super init];
    if (self) {
        seed = 1;
        dataObjectWrappers = [NSMutableArray array];
        changedDataObjectWrappers = [NSMutableArray array];
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"ADDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(importNotificationRecieved:) name:nil object:[ADImportController sharedImportController]];
    [nc addObserver:self selector:@selector(updateNotificationRecieved:) name:ADDataObjectUpdatedNotification object:nil];
    NSLog(@"Start loading plugins.");
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)dirWrapper ofType:(NSString *)typeName error:(NSError **)outError
{ 
    NSFileWrapper *wrapper;
    wrapper = [[dirWrapper fileWrappers] objectForKey:@"document-properties.plist"];
    NSData* propertyList = [wrapper regularFileContents];
    NSMutableDictionary *properties = [NSPropertyListSerialization propertyListWithData:propertyList options:NSPropertyListMutableContainersAndLeaves format:nil error:outError];
    NSNumber *seednr = [properties objectForKey:ADDataObjectCount];
    NSArray *objectslist = [properties objectForKey:ADObjectListKey];
    for(NSDictionary *wdict in objectslist){
        ADDataObjectWrapper *wrapper = [[ADDataObjectWrapper alloc] initFromDictionary:wdict];
        [dataObjectWrappers addObject:wrapper];
    }
    NSLog(@"Read data object wrappers: %@",dataObjectWrappers);
    seed = [seednr unsignedIntegerValue]+1;
    NSLog(@"File bundle with properties: %@",properties);
    NSLog(@"1 - seed= %ld",seed);
    return YES;
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outError
{
    NSLog(@"writeToURL operation");
    return [super writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outError];
}

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"fileWrapperOfType operation");
    NSFileWrapper *dirWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    NSString *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] description];
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [properties setObject:[NSNumber numberWithUnsignedInteger:seed-1] forKey:ADDataObjectCount];
    [properties setObject:version forKey:ADApplicationVersionKey];
    NSMutableArray *objectlist = [NSMutableArray array];
    [properties setObject:objectlist forKey:ADObjectListKey];
    NSUInteger i;
    for(i=0;i<[dataObjectWrappers count];i++){
        ADDataObjectWrapper *wrapper = [dataObjectWrappers objectAtIndex:i];
        [objectlist addObject:[wrapper serializeToDictionary]];
    }
    NSData* propertyList = [NSPropertyListSerialization dataWithPropertyList:properties format:NSPropertyListXMLFormat_v1_0 options:0 error:outError];
    [dirWrapper addRegularFileWithContents:propertyList preferredFilename:@"document-properties.plist"];
    return dirWrapper;
}

#pragma mark Import and Export
- (IBAction) import:(id)sender
{
    NSLog(@"Start Import");
    NSOpenPanel *openpanel = [NSOpenPanel openPanel];
    [openpanel setAllowsMultipleSelection:YES];
    [openpanel setCanChooseDirectories:YES];
    ADImportController *ic = [ADImportController sharedImportController];
    NSArray *types = [ic supportedFileTypes];
    if([types count]>0){
        [openpanel setAllowedFileTypes:types];
        [openpanel beginSheetModalForWindow:mainDocumentWindow completionHandler:^(NSInteger returnCode) {
            if (returnCode == NSOKButton){
                NSArray *files = [openpanel URLs];
                for(NSURL *url in files){
                    NSLog(@"2 - seed= %ld",seed);
                    [ic addFileToStack:[url path] withSeed:seed];
                    seed++;
                }
            }
        }];
    }
}

- (IBAction) export:(id)sender
{
    
}

#pragma mark Notifications received methods
- (void) importNotificationRecieved:(NSNotification*)not
{
    NSLog(@"Notification recieved: %@",not);
    if([[not name] isEqualToString:ADImportFileFinishedNotification]){
        NSArray *wrappers = [[not userInfo] objectForKey:ADImportFileObject];
        for(ADDataObjectWrapper* dataobjectwrapper in wrappers){
            [self addDataObjectWrapper:dataobjectwrapper];
        }
    }
}

- (void) updateNotificationRecieved:(NSNotification*)not
{
    NSLog(@"Notification recieved: %@",not);
    ADDataObjectWrapper * dataobject = [[not userInfo] objectForKey:ADUpdatedDataObject];
    [self addToChangedSet:dataobject];
    NSLog(@"changed data wrappers: %@",changedDataObjectWrappers);
}

#pragma mark Data Objects
- (void) addDataObjectWrapper:(ADDataObjectWrapper*)wrapper
{
    [dataObjectWrappers addObject:wrapper];
    [self addToChangedSet:wrapper];
}

- (void) addToChangedSet:(ADDataObjectWrapper*)wrapper
{
    if(![changedDataObjectWrappers containsObject:wrapper]){
        [changedDataObjectWrappers addObject:wrapper];
    }
}

@end
