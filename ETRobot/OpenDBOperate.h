//
//  OpenDBOperate.h
//  XPBLEDevice
//
//  Created by IHOME on 15/10/26.
//  Copyright (c) 2015年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenDBOperate : NSObject
{
    NSManagedObjectContext *contextDB;
}

- (NSManagedObjectContext *)openDB;

@end
