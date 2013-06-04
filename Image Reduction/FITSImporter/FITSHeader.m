//
//  FITSHeader.m
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

#import "FITSHeader.h"
#import "FITSHeaderRecord.h"

@interface FITSHeader (private)
- (void) parseHeader:(NSString*)hstr;
- (NSRange) lastRangeOfString:(NSString*)substring inString:(NSString*)string;
- (FITSHeaderRecord*) recordForIdentifier:(NSString*)ident;
@end

@implementation FITSHeader

- (id) initWithHeaderString:(NSString*)hstr
{
    self = [super init];
    [self parseHeader:hstr];
    return self;
}

#pragma mark Access to records

- (NSArray*) recordIdentifiers
{
    NSMutableArray *rids = [NSMutableArray array];
    for(FITSHeaderRecord *record in records){
        [rids addObject:[record identifier]];
    }
    return rids;
}

- (FITSHeaderRecord*) recordForIdentifier:(NSString*)ident
{
    for(FITSHeaderRecord *record in records){
        if([[record identifier] isEqualToString:ident]){
            return record;
        }
    }
    return nil;
}

- (NSString*) nameForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record name];
}

- (NSString*) stringValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record stringValue];
}

- (int) intValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record intValue];
}

- (NSInteger) integerValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record integerValue];
}

- (float) floatValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record floatValue];
}

- (double) doubleValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record doubleValue];
}

- (long long) longLongValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record longLongValue];
}

- (BOOL) booleanValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record boolValue];
}

- (NSDate*) dateValueForRecordWithIdentifier:(NSString*)ident
{
    FITSHeaderRecord *record = [self recordForIdentifier:ident];
    return [record dateValue];
}


#pragma mark Private methods

- (void) parseHeader:(NSString*)hstr
{
    if(!records){
        records = [NSMutableArray array];
    }
    [records removeAllObjects];
    NSCharacterSet *punct = [NSCharacterSet characterSetWithCharactersInString:@"'\"` \t"];
    int i = 0;
    while(i*80<[hstr length]){
        NSString *substr = [hstr substringWithRange:NSMakeRange(i*80, 80)];
        substr = [substr stringByTrimmingCharactersInSet:punct];
        if([substr length]>0){
            NSRange isposr = [substr rangeOfString:@"="];
            if(isposr.location!=NSNotFound){
                NSString *ident = [substr substringToIndex:isposr.location];
                ident = [ident stringByTrimmingCharactersInSet:punct];
                NSString *part2 = [substr substringFromIndex:isposr.location+1];
                NSRange slposr = [self lastRangeOfString:@"/" inString:part2];
                NSString *value=nil;
                NSString *descr=nil;
                if(slposr.location!=NSNotFound){
                    value = [part2 substringToIndex:slposr.location];
                    value = [value stringByTrimmingCharactersInSet:punct];
                    descr = [part2 substringFromIndex:slposr.location+1];
                    descr = [descr stringByTrimmingCharactersInSet:punct];
                }else{
                    value = [part2 stringByTrimmingCharactersInSet:punct];
                }
                if([descr length]<=0) descr = nil;
                FITSHeaderRecord *record = [FITSHeaderRecord recordWithIdentifier:ident value:value andName:descr];
                NSLog(@"ident = '%@'  value = '%@'  descr = '%@'",ident,value,descr);
                [records addObject:record];
            }
        }
        i++;
    }
}

- (NSRange) lastRangeOfString:(NSString*)substring inString:(NSString*)string
{
    NSRange last = NSMakeRange(NSNotFound,0);
    NSRange slposr = [string rangeOfString:substring];
    while(slposr.location!=NSNotFound){
        last = slposr;
        slposr = [string rangeOfString:substring options:NSLiteralSearch range:NSMakeRange(slposr.location+1, [string length]-(slposr.location+1))];
    }
    return last;
}

- (NSString*) description
{
    NSMutableString *descr = [NSMutableString string];
    for(FITSHeaderRecord *record in records){
        [descr appendString:[record description]];
        [descr appendString:@"\n"];
    }
    return descr;
}
@end
