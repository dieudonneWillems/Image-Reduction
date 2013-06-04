//
//  FITSHeaderRecord.m
// 	This file is part of Image Reduction.
//
//    Image Reduction is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Image Reduction is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Image Reduction.  If not, see <http://www.gnu.org/licenses/>.
//
//  Copyright (c) 2013 Dieudonné Willems. All rights reserved.
//
//  Created by Don Willems on 27-03-13.
//
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
