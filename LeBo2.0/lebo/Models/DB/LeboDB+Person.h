//
//  LeboDB+Person.h
//  LeBo
//
//  Created by Li Hongli on 13-3-11.
//
//

#import "LeboDB.h"
#import "LeboDTO.h"
@interface LeboDB (Person)
- (BOOL)createTable_Person:(sqlite3*)db;
+ (BOOL)savePerson:(LeboDTO *)dto;
+ (BOOL)getPersons:(NSMutableArray *)array;
+ (BOOL)clearPersons;

- (BOOL)clearPersons;
- (BOOL)getPersons:(NSMutableArray *)array;

@end
