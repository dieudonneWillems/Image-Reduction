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
@end

@implementation ADDocument

- (id)init
{
    self = [super init];
    if (self) {
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
    NSLog(@"Start loading plugins.");
    properties = [NSMutableDictionary dictionary];
    dataObjects = [NSMutableArray array];
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
    properties = [NSPropertyListSerialization propertyListWithData:propertyList options:NSPropertyListMutableContainersAndLeaves format:nil error:outError];
    NSLog(@"File bundle with properties: %@",properties);
    return YES;
}

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError
{
    NSFileWrapper *dirWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    NSString *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] description];
    [properties setObject:version forKey:ADApplicationVersionKey];
    NSData* propertyList = [NSPropertyListSerialization dataWithPropertyList:properties format:NSPropertyListXMLFormat_v1_0 options:0 error:outError];
    [dirWrapper addRegularFileWithContents:propertyList preferredFilename:@"document-properties.plist"];
    return dirWrapper;
}


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
                    [ic addFileToStack:[url path]];
                }
            }
        }];
    }
}

- (IBAction) export:(id)sender
{
    
}

- (void) importNotificationRecieved:(NSNotification*)not
{
    NSLog(@"Notification recieved: %@",not);
}

- (void) addDataObject:(id<ADDataObject>)object
{
    
}

@end
