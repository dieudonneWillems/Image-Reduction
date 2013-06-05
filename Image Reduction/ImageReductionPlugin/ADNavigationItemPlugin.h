//
//  ADNavigationItemPlugin.h
//  Image Reduction
//
//  Created by Don Willems on 05-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADImageReductionPlugin.h"
#import "ADDataObjectWrapper.h"

@protocol ADNavigationItemPlugin <ADImageReductionPlugin>

@property (readwrite) ADDataObjectWrapper* dataObjectWrapper;

- (NSView*) itemView;
- (void) setIsProcessingItem:(BOOL)proc;

- (BOOL) canDisplayItem:(ADDataObjectWrapper*)wrapper;

@end
