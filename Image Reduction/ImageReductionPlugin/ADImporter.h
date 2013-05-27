//
//  ADImporter.h
//  ReductionPlugin
//
//  Created by Don Willems on 23-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADImageReductionPlugin.h"

@protocol ADImporter <ADImageReductionPlugin>

- (NSArray*) supportedFileTypes;

- (NSArray*) importFileAtPath:(NSString*)path;

@end
