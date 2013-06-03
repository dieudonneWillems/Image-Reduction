//
//  ADDataViewController.h
//  Image Reduction
//
//  Created by Don Willems on 03-06-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#import <ImageReductionPlugin/ImageReductionPlugin.h>

@interface ADDataViewController : ADViewController {
    ADDataObjectWrapper *dataObjectWrapper;
}

@property (readwrite) ADDataObjectWrapper *dataObjectWrapper;

- (BOOL) canBeUsedAsViewerForDataObjectWrapper:(ADDataObjectWrapper*)wrapper;

- (BOOL) canBeUsedAsEditorForDataObjectWrapper:(ADDataObjectWrapper*)wrapper;

@end
