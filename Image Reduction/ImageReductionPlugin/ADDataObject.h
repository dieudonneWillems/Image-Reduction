//
//  ADDataObject.h
//  ReductionPlugin
//
//  Created by Don Willems on 26-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADProperty.h"

@protocol ADDataObject <NSObject>

@required
@property (readwrite) NSString *type;
- (NSArray*) properties;
- (ADProperty*) propertyForKey:(NSString*)propertyKey;
@end
