//
//  DataModelController.m
//  Quiz
//
//  Created by Dmitry Fedorov on 21.08.13.
//  Copyright (c) 2013 Mobintegro. All rights reserved.
//

#import "DFDataModelController.h"
@interface DFDataModelController ()
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
- (NSString *)documentsDirectory;
@end

@implementation DFDataModelController
@synthesize mainContext = _mainContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fetchedResultsController = _fetchedResultsController;
+ (id)sharedInstance {
    static DFDataModelController *__instance = nil;
    if (__instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __instance = [[DFDataModelController alloc] init];
        });
    }
    return __instance;
}

- (NSString *)modelName {
    return @"DFDataModel";
}

- (NSString *)pathToModel {
    return [[NSBundle mainBundle] pathForResource:[self modelName]
                                           ofType:@"momd"];
}

- (NSString *)storeFilename {
    return [@"DataStorage" stringByAppendingPathExtension:@"sqlite"];
}

- (NSString *)pathToLocalStore {
    return [[self documentsDirectory] stringByAppendingPathComponent:[self storeFilename]];
}

- (NSString *)documentsDirectory {
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSManagedObjectContext *)mainContext {
    if (_mainContext == nil) {
        _mainContext = [[NSManagedObjectContext alloc] init];
        _mainContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    
    return _mainContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *storeURL = [NSURL fileURLWithPath:[self pathToModel]];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSLog(@"SQLITE STORE PATH: %@", [self pathToLocalStore]);
        NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                             initWithManagedObjectModel:[self managedObjectModel]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *e = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:options
                                       error:&e]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:e forKey:NSUnderlyingErrorKey];
            NSString *reason = @"Could not create persistent store.";
            NSException *exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                                       reason:reason
                                                     userInfo:userInfo];
            @throw exc;
        }
        
        _persistentStoreCoordinator = psc;
    }
    
    return _persistentStoreCoordinator;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[DFPlayer entityName]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName"
                                                                     ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setFetchBatchSize:12];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.mainContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    _fetchedResultsController = theFetchedResultsController;
    return _fetchedResultsController;
}

@end
