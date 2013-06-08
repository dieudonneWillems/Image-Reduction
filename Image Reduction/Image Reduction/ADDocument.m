//
//  ADDocument.m
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
//  Created by Don Willems on 23-05-13.
//
//

#import "ADDocument.h"
#import "ADPluginController.h"
#import "ADImportController.h"

@interface ADDocument (private)
- (void) importNotificationRecieved:(NSNotification*)not;
- (void) updateNotificationRecieved:(NSNotification*)not;
- (void) addToChangedSet:(ADDataObjectWrapper*)wrapper;
- (BOOL) createDirectoriesInBundleAtPath:(NSString*)path;
- (void) handleError:(NSError*)error;
- (BOOL) writeDataObjectOfWrapper:(ADDataObjectWrapper*)wrapper intoBundleAtDataPath:(NSString*)path originalPath:(NSString*)opath;
- (BOOL) writeThumbnailOfWrapper:(ADDataObjectWrapper*)wrapper intoBundleAtThumbnailPath:(NSString*)path originalPath:(NSString*)opath;
- (void) addViewsFromPlugins;
- (void) setProjectStructureItemsInViews;
@end

@implementation ADDocument

- (id)init
{
    self = [super init];
    if (self) {
        seed = 1;
        dataObjectWrappers = [NSMutableArray array];
        changedDataObjectWrappers = [NSMutableArray array];
        viewControllers = [NSMutableArray array];
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
    [self addViewsFromPlugins];
    [self setProjectStructureItemsInViews];
    NSArray * vipl = [[ADPluginController defaultPluginController] pluginsConformingToProtocol:@protocol(ADProjectStructureItemViewPlugin)];
    for(id<ADProjectStructureItemViewPlugin> pl in vipl){
        ADProjectStructureItemViewController *vc = [pl createItemViewWithDisplaySize:ADProjectStructureItemSizeLarge];
    }
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
        // [wrapper loadDataObjectFromBundleAtPath:[[self fileURL] path]];
        NSString* thumbpath = [[[[[self fileURL] path]stringByAppendingPathComponent:@"thumbnails"] stringByAppendingPathComponent:[wrapper filename]] stringByAppendingPathExtension:@"tiff"];
        NSImage *tmb = [[NSImage alloc] initWithContentsOfFile:thumbpath];
        [wrapper setThumbnail:tmb];
    }
    seed = [seednr unsignedIntegerValue]+1;
    return YES;
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outError
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Non-incremental parts of the file bundle are saved normally
    BOOL ret = [super writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outError];
    if(!ret) return NO;
    
    
    BOOL ok = [self createDirectoriesInBundleAtPath:[absoluteURL path]];
    if(!ok) return NO;
    NSUInteger i;
    NSString* datapath = [[absoluteURL path] stringByAppendingPathComponent:@"data"];
    NSString* odatapath = [[absoluteOriginalContentsURL path] stringByAppendingPathComponent:@"data"];
    NSString* thumbpath = [[absoluteURL path] stringByAppendingPathComponent:@"thumbnails"];
    NSString* othumbpath = [[absoluteOriginalContentsURL path] stringByAppendingPathComponent:@"thumbnails"];
    
    // test if the operation is a simple Save operation and not Save as only normal save operations can be done incrementaly
    if(saveOperation==NSSaveOperation && ![self keepBackupFile] && absoluteOriginalContentsURL!=nil && [fm fileExistsAtPath:[absoluteOriginalContentsURL path]]){
        for(i=0;i<[dataObjectWrappers count];i++){
            ADDataObjectWrapper *wrapper = [dataObjectWrappers objectAtIndex:i];
            if([changedDataObjectWrappers containsObject:wrapper]){
                // the data object has changed and should be saved
                [self writeDataObjectOfWrapper:wrapper intoBundleAtDataPath:datapath originalPath:[absoluteOriginalContentsURL path]];
                [self writeThumbnailOfWrapper:wrapper intoBundleAtThumbnailPath:thumbpath originalPath:[absoluteOriginalContentsURL path]];
            }else{
                NSString *dpath = [datapath stringByAppendingPathComponent:[wrapper filename]];
                NSString *opath = [odatapath stringByAppendingPathComponent:[wrapper filename]];
                NSString *dtpath = [[thumbpath stringByAppendingPathComponent:[wrapper filename]] stringByAppendingPathExtension:@"tiff"];
                NSString *otpath = [[othumbpath stringByAppendingPathComponent:[wrapper filename]] stringByAppendingPathExtension:@"tiff"];
                // the data object has not changed, the data file from the original location is moved into the new location
                NSLog(@"Moving data object from %@ to %@",opath,dpath);
                [fm moveItemAtPath:opath toPath:dpath error:outError];
                if(*outError){
                    NSLog(@"error: %@",*outError);
                    [self handleError:*outError];
                    return NO;
                }
                [fm moveItemAtPath:otpath toPath:dtpath error:outError];
                if(*outError){
                    NSLog(@"error: %@",*outError);
                    [self handleError:*outError];
                    return NO;
                }
            }
        }
    }else{
        // the whole file bundle is (non-incrementally) saved
        for(i=0;i<[dataObjectWrappers count];i++){
            NSString *opath = [[self fileURL] path]; // might be wrong in a save as operation
            if(absoluteOriginalContentsURL){
                opath = [absoluteOriginalContentsURL path];
            }
            ADDataObjectWrapper *wrapper = [dataObjectWrappers objectAtIndex:i];
            BOOL suc = [self writeDataObjectOfWrapper:wrapper intoBundleAtDataPath:datapath originalPath:[opath stringByAppendingPathComponent:@"data"]];
            suc = [self writeThumbnailOfWrapper:wrapper intoBundleAtThumbnailPath:thumbpath originalPath:[opath stringByAppendingPathComponent:@"data"]];
            if(!suc){
                NSLog(@"Could not write data object to %@",datapath);
                *outError = [NSError errorWithDomain:@"Image Reduction" code:0 userInfo:nil];
                [self handleError:*outError];
            }
        }
    }
    [changedDataObjectWrappers removeAllObjects];
    return ret;
}

- (BOOL) writeDataObjectOfWrapper:(ADDataObjectWrapper*)wrapper intoBundleAtDataPath:(NSString*)path originalPath:(NSString*)opath
{
    BOOL suc = NO;
    NSString *file = [path stringByAppendingPathComponent:[wrapper filename]];
    // if the dataobject is not yet loaded, load it so that it can be written to the new file
    if(![wrapper dataObjectIsLoaded]) [wrapper loadDataObjectFromBundleAtPath:opath];
    id<ADDataObject> object = [wrapper dataObject];
    if(object){
        NSData *data = [object dataRepresentation];
        NSLog(@"data size: %ld",[data length]);
        NSLog(@"Writing dataobject to %@",file);
        suc = [data writeToFile:file atomically:NO];
    }else{
        NSLog(@"Could not load data object. path=%@",opath);
        suc = YES;
    }
    return suc;
}

- (BOOL) writeThumbnailOfWrapper:(ADDataObjectWrapper*)wrapper intoBundleAtThumbnailPath:(NSString*)path originalPath:(NSString*)opath;
{
    BOOL suc = NO;
    NSString *file = [[path stringByAppendingPathComponent:[wrapper filename]] stringByAppendingPathExtension:@"tiff"];
    NSImage *thumbnail = [wrapper thumbnail];
    if(!thumbnail){
        // if the dataobject is not yet loaded, load it so that it can be written to the new file
        if(![wrapper dataObjectIsLoaded]) [wrapper loadDataObjectFromBundleAtPath:opath];
        [wrapper createThumbnail];
    }
    if(thumbnail){
        NSData *data = [thumbnail TIFFRepresentation];
        suc = [data writeToFile:file atomically:NO];
    }else{
        NSLog(@"Could not load thumbnail. path=%@",opath);
        suc = YES;
    }
    return suc;
}

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError
{
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

- (BOOL) createDirectoriesInBundleAtPath:(NSString*)path
{
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* datapath = [path stringByAppendingPathComponent:@"data"];
    if(![fm fileExistsAtPath:datapath]){
        [fm createDirectoryAtPath:datapath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error) {
            [self handleError:error];
            return NO;
        }
    }
    NSString* thumbnailpath = [path stringByAppendingPathComponent:@"thumbnails"];
    if(![fm fileExistsAtPath:thumbnailpath]){
        [fm createDirectoryAtPath:thumbnailpath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error) {
            [self handleError:error];
            return NO;
        }
    }
    return YES;
}

- (BOOL) keepBackupFile
{
    return NO;
}

- (NSDocument *)duplicateAndReturnError:(NSError **)outError
{
    // This is a hack, I could not get the dataobjects to be saved when a duplicate was created (could not find a reference to the original file). Apparently when duplicating the document, the data objects were not duplicated.
    // Creates the duplicate (but without the data objects)
    ADDocument *duplicate = (ADDocument*)[super duplicateAndReturnError:outError];
    NSArray *dupwrappers = [duplicate dataObjectWrappers];
    for(ADDataObjectWrapper *dwrap in dupwrappers){
        if([self fileURL]){
            // Loads the data objects in the duplicate file from the original file
            [dwrap loadDataObjectFromBundleAtPath:[[self fileURL] path]];
        }else{
            // The original data is not yet on file!
            for(ADDataObjectWrapper *wrap in dataObjectWrappers){
                if([[wrap filename] isEqualToString:[dwrap filename]]){
                    // Needs to copy the actual data to the duplicate
                    if([wrap dataObjectIsLoaded]){
                        NSData *odat = [[wrap dataObject] dataRepresentation];
                        Class dc = [[wrap dataObject] class];
                        id<ADDataObject> ndo = [[dc alloc] initWithData:odat];
                        [dwrap setDataObject:ndo];
                    }
                    break;
                }
            }
        }
        if(![dwrap thumbnail]){
            [dwrap createThumbnail];
        }
    }
    return duplicate;
}

- (BOOL) isDocumentEdited
{
    BOOL ed = [super isDocumentEdited];
    if(ed)return ed;
    return ([changedDataObjectWrappers count]>0);
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

#pragma mark Views handling

- (void) addViewsFromPlugins
{
    NSArray *vplugs = [[ADPluginController defaultPluginController] viewPlugins];
    for(id<ADViewPlugin> vplug in vplugs){
        ADViewController *viewContr = [vplug createViewController];
        if([viewContr preferredViewArea] == ADNavigationSideViewArea){
            NSView *view = [viewContr view];
            NSTabViewItem *tabviewitem = [[NSTabViewItem alloc] initWithIdentifier:[[vplug class] description]];
            [tabviewitem setView:view];
            [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            [tabview addTabViewItem:tabviewitem];
            [viewControllers addObject:viewContr];
        }else{
            //TODO
        }
    }
}

- (void) setProjectStructureItemsInViews
{
    for(ADViewController *vc in viewControllers){
        if([vc isKindOfClass:[ADProjectStructureViewController class]]){
            [(ADProjectStructureViewController*)vc setProjectStructureItems:dataObjectWrappers];
        }// TODO add only to visible views
    }
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

- (NSArray*) dataObjectWrappers
{
    return dataObjectWrappers;
}

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
    if([self isDocumentEdited]) [mainDocumentWindow setDocumentEdited:YES];
}

#pragma mark Error handling

- (void) handleError:(NSError*)error
{
    [NSAlert alertWithError:error];
    NSLog(@"Error: %@",error);
}

@end
