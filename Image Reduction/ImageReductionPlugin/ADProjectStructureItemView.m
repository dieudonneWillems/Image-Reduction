//
//  ADProjectStructureItemView.m
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
//  Created by Don Willems on 08-06-13.
//

#import "ADProjectStructureItemView.h"
#import "ADDataObjectWrapper.h"

@implementation ADProjectStructureItemView

- (id)initWithFrame:(NSRect)frame displaySize:(ADProjectStructureItemSize) size;
{
    self = [super initWithFrame:frame];
    if (self) {
        displaySize = size;
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@synthesize displaySize;

- (ADDataObjectWrapper*) dataObjectWrapper
{
    return dataObjectWrapper;
}

- (void) setDataObjectWrapper:(ADDataObjectWrapper *)ndataObjectWrapper
{
    dataObjectWrapper = ndataObjectWrapper;
}

@end
