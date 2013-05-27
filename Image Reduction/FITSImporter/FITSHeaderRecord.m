//
//  FITSHeaderRecord.m
//  ObjCFITSIO
//
//  Created by Don Willems on 27-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "FITSHeaderRecord.h"

@interface FITSHeaderRecord (private)
- (id) initWithIdentifier:(NSString*)ident value:(NSString*)val andName:(NSString*)descr;
@end

@implementation FITSHeaderRecord

+ (FITSHeaderRecord*) recordWithIdentifier:(NSString*)ident value:(NSString*)val andName:(NSString*)descr
{
    return [[FITSHeaderRecord alloc] initWithIdentifier:ident value:val andName:descr];
}

- (id) initWithIdentifier:(NSString*)ident value:(NSString*)val andName:(NSString*)descr
{
    self = [super init];
    value = val;
    name = descr;
    identifier = ident;
    return self;
}

- (NSString*) identifier
{
    return identifier;
}

- (NSString*) name
{
    if(!name) return identifier;
    return name;
}

- (int) intValue
{
    return [value intValue];
}

- (NSInteger) integerValue
{
    return [value integerValue];
}

- (float) floatValue
{
    return [value floatValue];
}

- (double) doubleValue
{
    return [value doubleValue];
}

- (long long) longLongValue
{
    return [value longLongValue];
}

- (BOOL) boolValue
{
    return [value boolValue];
}

- (NSString*) stringValue
{
    return value;
}

- (NSDate*) dateValue
{
    return nil;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ = %@   [%@]",name,value,identifier];
}
@end
