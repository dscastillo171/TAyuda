//
//  ContextProvider.m
//  TAyuda
//
//  Created by Santiago Castillo on 11/16/15.
//  Copyright © 2015 tayuda. All rights reserved.
//

//
//  ContextProvider.m
//  Twnel
//
//  Created by Santiago Castillo on 2/23/14.
//  Copyright (c) 2014 Twnel Inc. All rights reserved.
//

#import "ContextProvider.h"

@interface ContextProvider()
// Root managed object context.
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
// Main managed object context.
@property (strong, nonatomic) NSManagedObjectContext *mainContext;
// Serial queue.
@property (strong, nonatomic) dispatch_queue_t serialQueue;
@end

@implementation ContextProvider

- (id)init{
    self = [super init];
    if(self){
        [self setUp];
    }
    return self;
}

// Setup the store and contexts.
- (void)setUp{
    // Make sure this method is called on the main queue.
    if(![NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(setUp) withObject:nil waitUntilDone:YES];
        return;
    }
    
    // First setup the managed object model.
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TAyuda" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Set up the persistent store coordinator.
    // Options are used to make lightweight migration between data model versions.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TAyuda.sqlite"];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Check if the store matches the model.
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:nil]){
        // Delete the store and try again creating a fresh new one.
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]){
            NSLog(@"Error deleting the persistent store coordinator. %@", error);
        }
    }
    
    // Setup the root context used to manage the persistent store.
    _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_privateContext performBlockAndWait:^{
        [_privateContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_privateContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        [[_privateContext userInfo] setValue:@"com.tayuda.privateQueue" forKey:@"mocIdentifier"];
    }];
    
    // Set up the main context, used for UI operations. Set it as a child of the master context.
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    _mainContext.parentContext = _privateContext;
    [[_mainContext userInfo] setValue:@"com.tayuda.mainThread" forKey:@"mocIdentifier"];
    
    // Subscribe to context notifications.
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(privateContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:_privateContext];
    [notificationCenter addObserver:self selector:@selector(privateContextDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:_privateContext];
    [notificationCenter addObserver:self selector:@selector(mainContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:_mainContext];
    
    // Create the serial queue used to dispatch save blocks.
    _serialQueue = dispatch_queue_create("com.tayuda.contextProvider", DISPATCH_QUEUE_SERIAL);
}

// Refresh objects from the main context.
-(void)privateContextDidChangeNotification:(NSNotification *)notification{
    dispatch_async(_serialQueue, ^{
        // Get the changed object ids.
        NSMutableSet *objectIds = [NSMutableSet set];
        [self.privateContext performBlockAndWait:^{
            for(NSManagedObject *object in notification.userInfo[NSUpdatedObjectsKey]){
                [objectIds addObject:object.objectID];
            }
            for(NSManagedObject *object in notification.userInfo[NSInsertedObjectsKey]){
                [objectIds addObject:object.objectID];
            }
            for(NSManagedObject *object in notification.userInfo[NSDeletedObjectsKey]){
                [objectIds addObject:object.objectID];
            }
        }];
        
        // Refresh the main context.
        [self.mainContext performBlockAndWait:^{
            for(NSManagedObjectID *objectId in objectIds){
                NSManagedObject *object = [self.mainContext objectRegisteredForID:objectId];
                if(object){
                    [self.mainContext refreshObject:object mergeChanges:YES];
                } else{
                    object = [self.mainContext existingObjectWithID:objectId error:nil];
                    [self.mainContext refreshObject:object mergeChanges:NO];
                }
            }
        }];
    });
}

// Merge changes from the private into the main thread.
- (void)privateContextDidSaveNotification:(NSNotification *)notification{
    dispatch_async(_serialQueue, ^{
        [self.mainContext performBlockAndWait:^{
            [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    });
}

// Save the private context.
- (void)mainContextDidSaveNotification:(NSNotification *)notification{
    dispatch_async(_serialQueue, ^{
        [self.privateContext performBlockAndWait:^{
            if([self.privateContext hasChanges]){
                [self.privateContext save:nil];
            }
        }];
    });
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end