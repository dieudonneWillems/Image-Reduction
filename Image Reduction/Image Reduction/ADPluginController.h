//
//  ADPluginController.h
//  Reduction
//
//  Created by Don Willems on 24-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageReductionPlugin/ImageReductionPlugin.h>

@interface ADPluginController : NSObject {
    NSMutableArray *plugins;
}

+ (ADPluginController*) defaultPluginController;

- (NSArray*) importers;
- (NSArray*) pluginsConformingToProtocol:(Protocol *)aProtocol;
@end
