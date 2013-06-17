//
//  ADSmallToolbarView.m
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
//  Created by Don Willems on 17-06-13.
//

#import "ADSmallToolbarView.h"

@implementation ADSmallToolbarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@synthesize indexOfSelectedItem;

- (void) addTabViewItemWithIdentifier:(id)identifier icon:(NSImage*)icon andView:(NSView*)view
{
    if(!icons){
        icons = [NSMutableDictionary dictionary];
        indexOfSelectedItem = 0;
    }
    if(icon) [icons setObject:icon forKey:identifier];
    NSTabViewItem *tabviewitem = [[NSTabViewItem alloc] initWithIdentifier:identifier];
    [tabviewitem setView:view];
    [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [tabView addTabViewItem:tabviewitem];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSUInteger count = [icons count];
    NSArray *ids = [icons allKeys];
    NSRect iconsrect;
    iconsrect.size.height = [self frame].size.height;
    iconsrect.size.width = count * 24;
    iconsrect.origin.y = [self frame].origin.y;
    iconsrect.origin.x = [self frame].origin.x+([self frame].size.width-iconsrect.size.width)/2;
    if(NSIntersectsRect(dirtyRect, iconsrect)){
        CGFloat dx = dirtyRect.origin.x-iconsrect.origin.x;
        NSUInteger startindex = 0;
        if(dx>0) startindex = dx/24;
        NSUInteger endindex = count;
        endindex = (dirtyRect.origin.x+dirtyRect.size.width-iconsrect.origin.x)+1;
        if(endindex>count) endindex = count;
        NSUInteger i;
        for(i=startindex;i<endindex;i++){
            if(i==indexOfSelectedItem){
                if(!selectionBackground){
                    selectionBackground = [NSImage imageNamed:@"selectedbgr"];
                }
                
            }
            id ident = [ids objectAtIndex:i];
            NSImage *icon = [icons objectForKey:ident];
            NSRect imgrect = iconsrect;
            imgrect.size = NSMakeSize(12, 12);
            imgrect.origin.x += i*24+6;
            imgrect.origin.y += iconsrect.size.height/2-6;
            NSRect sourcerect = NSMakeRect(0, 0, [icon size].width, [icon size].height);
            CGFloat fraction = 1.0;
            if(![[self window] isKeyWindow]) fraction = 0.5;
            if(i==indexOfSelectedItem){
                NSRect bgrrect = iconsrect;
                bgrrect.size = [selectionBackground size];
                bgrrect.origin.x = (CGFloat)(NSInteger)(bgrrect.origin.x+i*24.0 - 3.0);
                bgrrect.origin.y = 1;
                NSRect bgrsourcerect = NSMakeRect(0, 0, [selectionBackground size].width, [selectionBackground size].height);
                [selectionBackground drawInRect:bgrrect fromRect:bgrsourcerect operation:NSCompositeSourceOver fraction:fraction];
            }
            [icon drawInRect:imgrect fromRect:sourcerect operation:NSCompositeSourceOver fraction:fraction];
        }
    }
}

@end
