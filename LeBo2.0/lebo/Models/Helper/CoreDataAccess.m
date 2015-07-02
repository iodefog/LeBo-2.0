//
//  CoreDataAccess.m
//  YKiPad
//
//  Created by zjs on 11-5-5.
//  Copyright 2011年 lb. All rights reserved.
//

#import "CoreDataAccess.h"


@implementation CoreDataAccess

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataAccess *)sharedInstance {
    static CoreDataAccess *instance = nil;
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}



- (id)copyWithZone:(NSZone *)zone {
    return self;
}


- (void)saveContext {
    NSError *error = nil;
    [self saveContext:&error];
}

- (void)saveContext:(NSError **)error {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
        {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:error])
            {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            if (*error) {
               DLog(@"Unresolved error %@, %@", *error, [*error userInfo]);                 
                //DLog(@"Unresolved error %@, %@", *error, [*error userInfo]);                
            }
            //            abort();
            } 
        }
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
    
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		_managedObjectContext = [[NSManagedObjectContext alloc] init];
		[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
    
	NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CoreDate.sqlite"]];
    
	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:dict error:&error]) {
		/*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
		 * The persistent store is not accessible;
		 * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
		 * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
		 * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
		 */
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
	return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
}

- (NSArray *)getRecordsFromTable:(NSString *)table withFaulting:(BOOL)faulting {
    NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    // needed to prevent faults being returned
    [fetchRequest setReturnsObjectsAsFaults:faulting];
    [fetchRequest setIncludesPendingChanges:NO];
    [fetchRequest setEntity:entity];
    
    NSArray *records = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return records;
}

- (NSArray *)getRecordsFromTable:(NSString *)table withPredicate:(NSPredicate *)pre withFaulting:(BOOL)faulting {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
	
	// needed to prevent faults being returned
	[fetchRequest setReturnsObjectsAsFaults:faulting];
	
	[fetchRequest setEntity:entity];
	
	[fetchRequest setPredicate:pre];
	
	NSArray *records = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
	return records;
}

- (NSArray *)getRecordsFromTable:(NSString *)table withPredicate:(NSPredicate *)pre onColumn:(NSString *)column Ascending:(BOOL)order withFaulting:(BOOL)faulting {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
	
	// needed to prevent faults being returned
	[fetchRequest setReturnsObjectsAsFaults:faulting];
	
	[fetchRequest setEntity:entity];
	
	[fetchRequest setPredicate:pre];
	
	NSArray *records = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:column ascending:order];
	
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	
	NSArray* sortedReadings = [NSArray arrayWithArray:[records sortedArrayUsingDescriptors:descriptors]];
	
	return sortedReadings;
	return records;
}

- (NSArray *)getRecordsFromTable:(NSString *)table withStringPredicate:(NSString *)pre withFaulting:(BOOL)faulting {
    NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	
	// needed to prevent faults being returned
	[fetchRequest setReturnsObjectsAsFaults:faulting];
	
	[fetchRequest setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:pre];
	
	[fetchRequest setPredicate:predicate];
	
	NSArray *records = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
	return records;
}

- (void)deleteRecord:(NSManagedObject *)object {
	[self.managedObjectContext deleteObject:object];
	[self saveContext];
}

- (void)addRecordWithCallback:(CoreDataCallback) callback inEntity:(NSString *)entityName
{
    NSManagedObject * object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    callback(object);
    [self saveContext];
}


- (void)deleteAllRecordsInTable:(NSString*)table {
    // Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
    
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	
	// needed to prevent faults being returned
	[fetchRequest setReturnsObjectsAsFaults:NO];
	
	[fetchRequest setEntity:entity];
	
	NSArray* resultsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	for (NSManagedObject *managedObject in resultsArray) {
        [self.managedObjectContext deleteObject:managedObject];
    }
	
	[self saveContext];
}

- (NSArray *)getRecordsForTable:(NSString*)table OnColumn:(NSString*)column Ascending:(Boolean)order {
	NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
	
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	
	[fetchRequest setEntity:entity];
	
	NSArray *records = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
		
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:column ascending:order];
	
	NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
	
	NSArray* sortedReadings = [NSArray arrayWithArray:[records sortedArrayUsingDescriptors:descriptors]];
	
	return sortedReadings;
	
}

@end
