//
//  ADDocument.h
//  Reduction
//
//  Created by Don Willems on 23-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ImageReductionPlugin/ImageReductionPlugin.h>
#import "ADKeys.h"

@interface ADDocument : NSDocument {
    NSMutableDictionary *properties;
    IBOutlet NSWindow* mainDocumentWindow;
    NSMutableArray *dataObjects;
}

- (void) addDataObject:(id<ADDataObject>)object;

- (IBAction) import:(id)sender;
- (IBAction) export:(id)sender;

@end
