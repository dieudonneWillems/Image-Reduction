//
//  ADDataViewController.m
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
//
//  Created by Don Willems on 03-06-13.
//
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
        //Connect to any selection of a data object.
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
