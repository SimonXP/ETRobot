//
//  OpenDBOperate.m
//  XPBLEDevice
//
//  Created by IHOME on 15/10/26.
//  Copyright (c) 2015年 IHOME. All rights reserved.
//

#import "OpenDBOperate.h"

@implementation OpenDBOperate

- (NSManagedObjectContext *)openDB
{
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docs[0] stringByAppendingPathComponent:@"ETRobot2.db"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSLog(@"DB文件路径:%@",url);
    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    if (error) {
        NSLog(@"打开数据库出错! %@", error.localizedDescription);
    } else {
        NSLog(@"打开数据库成功!");
        contextDB = [[NSManagedObjectContext alloc] init];
        contextDB.persistentStoreCoordinator = coordinator;
    }
    return contextDB;
}

@end
