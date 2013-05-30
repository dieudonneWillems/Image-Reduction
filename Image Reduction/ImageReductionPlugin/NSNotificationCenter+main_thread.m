//
//  NSNotificationCenter+main_thread.m
//  Image Reduction
//
//  Created by Don Willems on 29-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "NSNotificationCenter+main_thread.h"

@implementation NSNotificationCenter (main_thread)

- (void) postOnMainThreadNotification:(NSNotification*)notification
{
    [self performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];
}

@end
