//
//  SYCoreDataManager.m
//  CoreDataManager
//
//  Created by mac1 on 16/8/19.
//  Copyright © 2016年 fuxi. All rights reserved.
//

#import "SYCoreDataManager.h"
static SYCoreDataManager *instance = nil;

@implementation SYCoreDataManager

+(instancetype) shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[SYCoreDataManager alloc] init];
    });
    
    return instance;
}

@synthesize managerObjectModel = _managerObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;

//1 模型文件对象
- (NSManagedObjectModel *) managerObjectModel {
    
    if (_managerObjectModel != nil) {
        
        return _managerObjectModel;
    }
    
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    _managerObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    return _managerObjectModel;
}

//2 协调器
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managerObjectModel];//一定要使用点语法方式获取该对象
    
    //数据库的存储路径
    NSURL *storeUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/Database.sqlite"]];
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    //给协调器添加一个可持久化对象
    NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
    
    if (!persistentStore) {
        //有错误
        //Report any error we got.
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort()会是app退出,然后生成一个崩溃日志
        //在开发阶段使用ok,但是发布的时候要注释掉.
        abort();
        
        //        return nil;
        

    }
    return _persistentStoreCoordinator;
}

//3 操作MO对象的context
- (NSManagedObjectContext *) managedObjectContext {
    
    if (_managedObjectContext != nil) {
        
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = coordinator;
    
    return _managedObjectContext;
}

- (void) saveContext {
    
//    [self.managerObjectContext save:<#(NSError * _Nullable __autoreleasing * _Nullable)#>];
    NSManagedObjectContext *managerObjectContext = self.managedObjectContext;
    if (managerObjectContext != nil) {
        
        NSError *error = nil;
        if ([managerObjectContext hasChanges] && ![managerObjectContext save:&error]) {
            //如果context发生变化，并且保存失败-->
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //如果context没有发生变化,不会进入...
    }
}

// 添加
- (NSManagedObject *) insertManagerObjectWithEntityName:(NSString *)entityName {
    
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    return mo;
}

//查找
//查找
-(NSArray*)fetchEntityName:(NSString*)entityName predicate:(NSPredicate*)predicate orderBy:(NSArray*)sortDescriptors{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
        NSLog(@"%@",error);
    }
    
    
    return fetchedObjects;
}@end
