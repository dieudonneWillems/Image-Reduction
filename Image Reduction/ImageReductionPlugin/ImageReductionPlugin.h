//
//  ImageReductionPlugin.h
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
//  Copyright (c) 2013 Dieudonné Willems. All rights reserved.Plugin
//
//
//  Created by Don Willems on 23-05-13.
//
//

#ifndef ReductionPlugin_ReductionPlugin_h
#define ReductionPlugin_ReductionPlugin_h

#import "ADImageReductionPlugin.h"
#import "ADDataObjectWrapper.h"
#import "ADDataObject.h"
#import "ADImage.h"
#import "ADImporter.h"
#import "ADExporter.h"
#import "ADProcessor.h"
#import "ADScalingFunction.h"
#import "ADDataObject.h"
#import "ADImage.h"
#import "ADProperty.h"
#import "NSNotificationCenter+main_thread.h"
#import "ADViewController.h"
#import "ADViewPlugin.h"
#import "ADDataViewController.h"
#import "ADProjectStructureViewPlugin.h"
#import "ADProjectStructureItemViewPlugin.h"
#import "ADProjectStructureViewController.h"



#pragma mark Import notifications
#define ADImportFileAddedNotification @"ADImportFileAddedNotification"
#define ADImportFileStartedNotification @"ADImportFileStartedNotification"
#define ADImportFileFinishedNotification @"ADImportFileFinishedNotification"
#define ADImportFileCanceledNotification @"ADImportFileCanceledNotification"
#define ADImportStartedNotification @"ADImportStartedNotification"
#define ADImportFinishedNotification @"ADImportFinishedNotification"

#define ADImportFilePath @"ADImportFilePath"
#define ADImportFileObject @"ADImportFileObject" 


#pragma mark Update notifications
#define ADDataObjectUpdatedNotification @"ADDataObjectUpdatedNotification"

#define ADUpdatedDataObject @"ADUpdatedDataObject"



#pragma mark View notifications
#define ADViewChangedDataObjectNotification @"ADViewChangedDataObjectNotification"

#define ADPreviousDataObject @"ADPreviousDataObject"
#define ADCurrentDataObject @"ADCurrentDataObject"
#define ADDataView @"ADDataView"


#endif
