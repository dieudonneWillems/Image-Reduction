//
//  ADReductionPlugin.h
//  ReductionPlugin
//
//  Created by Don Willems on 23-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADPreferencePane.h"

@protocol ADImageReductionPlugin <NSObject>

- (NSString*) name;
- (void) initialize;
- (ADPreferencePane*) preferencePane;

@end
