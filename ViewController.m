//
//  ViewController.m
//  CoreDataManager
//
//  Created by mac1 on 16/8/19.
//  Copyright © 2016年 fuxi. All rights reserved.
//

#import "ViewController.h"
#import "SYCoreDataManager.h"
#import "Hero.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@", NSHomeDirectory());
    
    SYCoreDataManager *manager = [SYCoreDataManager shareManager];
    
    
    //添加
    Hero *h1 = (Hero*)[manager insertManagerObjectWithEntityName:@"Hero"];//多态
    
    h1.heroId = 1;
    h1.nama = @"唐僧";
    
    [manager saveContext];
    
    //查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"height < %f", 10.0];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    
    
    NSArray *mos = [manager fetchEntityName:@"Hero" predicate:predicate orderBy:@[sort]];
    
    
    for (Hero *h in mos) {
        
        NSLog(@"%@", h.nama);
    }

    //更新
    Hero *h2 = [mos lastObject];
    h2.nama = @"如来";
    h2.height = 1000;
    [manager saveContext];
    
    //    //删除
    Hero *h3 = [mos firstObject];
    [manager.managedObjectContext deleteObject:h3];
    [manager saveContext];
}


@end
