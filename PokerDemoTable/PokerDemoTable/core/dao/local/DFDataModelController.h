//
//  DataModelController.h
//  Quiz
//
//  Created by Dmitry Fedorov on 21.08.13.
//  Copyright (c) 2013 Mobintegro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DFPlayer.h"
@import CoreData;
@interface DFDataModelController : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;

+ (id)sharedInstance;
- (NSString *)modelName;
- (NSString *)pathToModel;
- (NSString *)storeFilename;
- (NSString *)pathToLocalStore;

@end
