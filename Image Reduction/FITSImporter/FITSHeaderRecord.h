//
//  FITSHeaderRecord.h
//  ObjCFITSIO
//
//  Created by Don Willems on 27-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FITSHeaderRecord : NSObject{
    NSString *identifier;
    NSString *name;
    NSString *value;
}

+ (FITSHeaderRecord*) recordWithIdentifier:(NSString*)ident value:(NSString*)val andName:(NSString*)descr;

- (NSString*) identifier;
- (NSString*) name;

- (int) intValue;
- (NSInteger) integerValue;
- (float) floatValue;
- (double) doubleValue;
- (long long) longLongValue;
- (BOOL) boolValue;
- (NSString*) stringValue;
- (NSDate*) dateValue;
@end
