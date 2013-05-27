//
//  FITSHeader.h
//  ObjCFITSIO
//
//  Created by Don Willems on 27-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FITSHeader : NSObject <NSOutlineViewDataSource>{
    NSMutableArray *records;
}

- (id) initWithHeaderString:(NSString*)hstr;

- (NSArray*) recordIdentifiers;

- (NSString*) nameForRecordWithIdentifier:(NSString*)ident;
- (NSString*) stringValueForRecordWithIdentifier:(NSString*)ident;
- (int) intValueForRecordWithIdentifier:(NSString*)ident;
- (NSInteger) integerValueForRecordWithIdentifier:(NSString*)ident;
- (float) floatValueForRecordWithIdentifier:(NSString*)ident;
- (double) doubleValueForRecordWithIdentifier:(NSString*)ident;
- (long long) longLongValueForRecordWithIdentifier:(NSString*)ident;
- (BOOL) booleanValueForRecordWithIdentifier:(NSString*)ident;
- (NSDate*) dateValueForRecordWithIdentifier:(NSString*)ident;
@end
