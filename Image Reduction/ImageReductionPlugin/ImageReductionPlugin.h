//
//  ImageReductionPlugin.h
//  ImageReductionPlugin
//
//  Created by Don Willems on 23-05-13.
//  Copyright (c) 2013 Lapsed Pacifist. All rights reserved.
//

#ifndef ReductionPlugin_ReductionPlugin_h
#define ReductionPlugin_ReductionPlugin_h

#import "ADImageReductionPlugin.h"
#import "ADDataObject.h"
#import "ADImage.h"
#import "ADImporter.h"
#import "ADExporter.h"
#import "ADProcessor.h"
#import "ADScalingFunction.h"
#import "ADDataObject.h"
#import "ADImage.h"

#define ADImportFileAddedNotification @"ADImportFileAddedNotification"
#define ADImportFileStartedNotification @"ADImportFileStartedNotification"
#define ADImportFileFinishedNotification @"ADImportFileFinishedNotification"
#define ADImportFileCanceledNotification @"ADImportFileCanceledNotification"
#define ADImportStartedNotification @"ADImportStartedNotification"
#define ADImportFinishedNotification @"ADImportFinishedNotification"

#define ADImportFilePath @"ADImportFilePath"
#define ADImportFileObject @"ADImportFileObject" 

#endif
