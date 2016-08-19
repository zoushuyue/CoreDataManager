//
//  SYCoreDataManager.h
//  CoreDataManager
//
//  Created by mac1 on 16/8/19.
//  Copyright © 2016年 fuxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SYCoreDataManager : NSObject


//创建单例
+(instancetype) shareManager;

@property (readonly , strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managerObjectModel;
@property (readonly , strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) saveContext;

//增删改查
//添加
- (NSManagedObject *) insertManagerObjectWithEntityName:(NSString *) entityName;

//查找
-(NSArray*)fetchEntityName:(NSString*)entityName predicate:(NSPredicate*)predicate orderBy:(NSArray*)sortDescriptors;

//删除

//修改


@end
