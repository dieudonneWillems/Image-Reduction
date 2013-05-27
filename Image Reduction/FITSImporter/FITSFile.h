//
//  FITSObject.h
//  ObjCFITSIO
//
//  Created by Don Willems on 27-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FITSHeader;

@interface FITSFile : NSObject {
    NSString *path;
}

+ (FITSFile*) FITSFileAtPath:(NSString*)path;

@property (readonly) NSString *path;
- (NSArray*) headerAndDataUnits;

@end
