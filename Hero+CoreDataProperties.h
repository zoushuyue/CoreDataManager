//
//  Hero+CoreDataProperties.h
//  CoreDataManager
//
//  Created by mac1 on 16/8/19.
//  Copyright © 2016年 fuxi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Hero.h"

NS_ASSUME_NONNULL_BEGIN

@interface Hero (CoreDataProperties)

@property (nonatomic) float height;
@property (nonatomic) int64_t heroId;
@property (nullable, nonatomic, retain) NSString *nama;
@property (nullable, nonatomic, retain) NSString *team;

@end

NS_ASSUME_NONNULL_END
