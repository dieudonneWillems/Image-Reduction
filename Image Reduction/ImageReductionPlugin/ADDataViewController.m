//
//  ADDataViewController.m
//  Image Reduction
//
//  Created by Don Willems on 03-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import "ADDataViewController.h"

@interface ADDataViewController (private)
- (void) postViewChangedDataObjectNotificationWithCurrentDataObject:(ADDataObjectWrapper*)current andPreviousDataObject:(ADDataObjectWrapper*)previous;
@end

@implementation ADDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (ADDataObjectWrapper*) dataObjectWrapper
{
    return dataObjectWrapper;
}

- (void) setDataObjectWrapper:(ADDataObjectWrapper *)ndataObjectWrapper
{
    ADDataObjectWrapper *old = dataObjectWrapper;
    dataObjectWrapper = ndataObjectWrapper;
    [self postViewChangedDataObjectNotificationWithCurrentDataObject:dataObjectWrapper andPreviousDataObject:old];
}

- (BOOL) canBeUsedAsViewerForDataObjectWrapper:(ADDataObjectWrapper*)wrapper
{
    return NO;
}

- (BOOL) canBeUsedAsEditorForDataObjectWrapper:(ADDataObjectWrapper*)wrapper
{
    return NO;
}

- (void) postViewChangedDataObjectNotificationWithCurrentDataObject:(ADDataObjectWrapper*)current andPreviousDataObject:(ADDataObjectWrapper*)previous
{
    NSDictionary *ui = [NSDictionary dictionaryWithObjectsAndKeys:current, ADCurrentDataObject, previous, ADPreviousDataObject,self, ADDataView, nil];
    NSNotification *not = [NSNotification notificationWithName:ADViewChangedDataObjectNotification object:self userInfo:ui];
    [[NSNotificationCenter defaultCenter] postOnMainThreadNotification:not];
}

@end
