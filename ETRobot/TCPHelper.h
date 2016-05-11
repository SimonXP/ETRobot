//
//  TCPHelper.h
//  XiangJiaBao
//
//  Created by admin on 15-6-10.
//  Copyright (c) 2015年 青芒科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "message.h"

@interface TCPHelper : NSObject
{
    int socketFileDescriptor;
}

-(BOOL)isConnected;

-(BOOL)connectWithIP:(NSString*)ip Port:(int)port IsHeartBeat:(BOOL)isHeartBeat;

-(BOOL)writeData:(NSData*) data;

-(BOOL)writeValue:(NSString *)value;

-(BOOL)readData:(str_cs_msg_t*)msg;

-(BOOL)close;

@end