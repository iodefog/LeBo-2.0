//
//  CoreDataAccess.h
//  YKiPad
//
//  Created by zjs on 11-5-5.
//  Copyright 2011年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
typedef void (^CoreDataCallback) (NSManagedObject * object);
@interface CoreDataAccess : NSObject {
    
}

+ (CoreDataAccess *)sharedInstance;
- (void)saveContext;
- (void)saveContext:(NSError **)error;
- (NSString *)applicationDocumentsDirectory;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSArray *)getRecordsFromTable:(NSString *)table withFaulting:(BOOL)faulting;

- (NSArray *)getRecordsFromTable:(NSString *)table withPredicate:(NSPredicate *)pre withFaulting:(BOOL)faulting;

- (NSArray *)getRecordsFromTable:(NSString *)table withStringPredicate:(NSString *)pre withFaulting:(BOOL)faulting;

- (void)deleteRecord:(NSManagedObject *)object;

- (void)deleteAllRecordsInTable:(NSString*)table;

- (void)addRecordWithCallback:(CoreDataCallback) callback inEntity:(NSString *)entityName;

- (NSArray *)getRecordsForTable:(NSString*)table OnColumn:(NSString*)column Ascending:(Boolean)order;
- (NSArray *)getRecordsFromTable:(NSString *)table withPredicate:(NSPredicate *)pre onColumn:(NSString *)column Ascending:(BOOL)order withFaulting:(BOOL)faulting;
@end
