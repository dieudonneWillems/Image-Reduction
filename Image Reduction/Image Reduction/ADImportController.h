//
//  ADImportController.h
//  Reduction
//
//  Created by Don Willems on 24-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageReductionPlugin/ImageReductionPlugin.h>

@interface ADImportController : NSObject {
    NSMutableArray *importers;
    NSMutableArray *stack;
    BOOL running;
}

+ (ADImportController*) sharedImportController;

- (void) reloadImporters;

- (NSArray*) supportedFileTypes;
- (id<ADImporter>) importerForFile:(NSString*)path;

- (void) addFileToStack:(NSString*)path;

- (BOOL) running;
@end
