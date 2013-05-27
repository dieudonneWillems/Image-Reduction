//
//  FITSObject.m
//  ObjCFITSIO
//
//  Created by Don Willems on 27-03-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
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
