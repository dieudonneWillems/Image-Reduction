//
//  FITSObject.m
//
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

#import "FITSFile.h"
#import "FITSImage.h"
#import "FITSHeader.h"
#import "FITSData.h"
#import "BinaryDataScanner.h"
#import "FITSHeaderAndDataUnit.h"

@interface FITSFile (private)
+ (FITSHeader*) readHUDFrom:(BinaryDataScanner*)scanner position:(NSInteger*)position;
- (id) initWithPath:(NSString*)path;
@end

@implementation FITSFile

+ (FITSHeader*) readHeaderFrom:(BinaryDataScanner*)scanner position:(NSInteger*)position
{
    int i;
    NSMutableString *hud = [NSMutableString string];
    BOOL cont = YES;
    while(cont && [scanner remainingBytes]>2880){
        NSString *block=[scanner readStringOfLength:2880 handleNullTerminatorAfter:NO];
        for(i=0;i<36;i++){
            NSString *sblock = [block substringWithRange:NSMakeRange(i*80, 80)];
            //NSLog(@"%@",sblock);
            if([sblock rangeOfString:@"END"].location==0)cont = NO;
        }
        [hud appendString:block];
        (*position) = (*position)+2880;
    }
    FITSHeader *header = [[FITSHeader alloc] initWithHeaderString:hud];
    return header;
}


+ (FITSFile*) FITSFileAtPath:(NSString*)path
{
    FITSFile *file = [[FITSFile alloc] initWithPath:path];
    return file;
}

- (id) initWithPath:(NSString*)fpath
{
    self = [super init];
    path = fpath;
    return self;
}

@synthesize path;

- (NSArray*) headerAndDataUnits
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    BinaryDataScanner *scanner = [BinaryDataScanner binaryDataScannerWithData:data littleEndian:NO defaultEncoding:NSASCIIStringEncoding];
    NSInteger position = 0;
    NSMutableArray *huds = [NSMutableArray array];
    while(position+2880<[data length]){
        NSLog(@"*********************************************************************************************");
        FITSHeader *header = [FITSFile readHeaderFrom:scanner position:&position];
        NSData *sdata = [data subdataWithRange:NSMakeRange(position, [data length]-position)];
        NSUInteger flength=0;
        FITSData *fdata = [FITSData createFITSDataFromData:sdata withHeader:header numberOfBytes:&flength];
        FITSHeaderAndDataUnit *hud = [fdata headerAndDataUnit];
        if(hud) [huds addObject:hud];
        position = position + flength;
        [scanner skipBytes:flength];
        // [scanner currentPointer];
    }
    return huds;
}

@end
