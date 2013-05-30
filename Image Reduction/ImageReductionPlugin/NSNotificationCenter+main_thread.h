//
//  NSNotificationCenter+main_thread.h
//  Image Reduction
//
//  Created by Don Willems on 29-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (main_thread)

- (void) postOnMainThreadNotification:(NSNotification*)notification;
@end
