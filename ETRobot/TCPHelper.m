//
//  TCPHelper.m
//  XiangJiaBao
//
//  Created by admin on 15-6-10.
//  Copyright (c) 2015年 青芒科技. All rights reserved.
//

#import "TCPHelper.h"
#import <arpa/inet.h>
#import <netdb.h>
#import "CommonDefine.h"

@implementation TCPHelper

-(id)init
{
    if(self = [super init])
    {
        // Class-specific initializations
        
        socketFileDescriptor = -1;
    }
    return self;
}

-(BOOL)isConnected
{
    if(socketFileDescriptor == -1)
    {
        return false;
    }
    else
    {
        return true;
    }
}

-(BOOL)connectWithIP:(NSString*)ip Port:(int)port IsHeartBeat:(BOOL)isHeartBeat
{
    socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (-1 == socketFileDescriptor)
    {
        NSLog(@"创建Socket失败!");
        
        return false;
    }
    
    // Get IP address
    //
    struct in_addr remoteInAddr;
    inet_aton([ip UTF8String], &remoteInAddr);
    
    // Set the socket parameters
    //
    //设置读写超时
    struct timeval timeo = {TCP_READ_TIMEOUT, 0};
    socklen_t len = sizeof(timeo);
    setsockopt(socketFileDescriptor, SOL_SOCKET, SO_SNDTIMEO, &timeo, len);
    if(isHeartBeat == false)
    {
        setsockopt(socketFileDescriptor, SOL_SOCKET, SO_RCVTIMEO, &timeo, len);
    }
    
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr = remoteInAddr;
    socketParameters.sin_port = htons(port);
    
    // Connect the socket
    //
    int ret = connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
    if (-1 == ret)
    {
        close(socketFileDescriptor);
        socketFileDescriptor = -1;
        
        NSLog(@"连接%@:%d失败!", ip, port);
        
        return false;
    }
    
    NSLog(@"连接%@:%d成功!", ip, port);
    
    return true;
}

-(BOOL)writeValue:(NSString *)value
{
    NSData *wData = [[NSString stringWithFormat:@"%@\n",value] dataUsingEncoding:NSUTF8StringEncoding];
    return [self writeData:wData];
}

-(BOOL)writeData:(NSData*) data
{
    Byte *buf = (Byte *)[data bytes];
    unsigned long length = [data length];
    
    int byteWrite = 0;
    
    while(byteWrite < length)
    {
        ssize_t ret = send(socketFileDescriptor,buf+byteWrite,length-byteWrite,0);
        
        if(ret > 0)
        {
            byteWrite += ret;
        }
        else
        {
            close(socketFileDescriptor);
            socketFileDescriptor = -1;
            
            NSLog(@"发送数据失败！");
            
            return false;
        }
    }
    
    return true;
}

-(BOOL)readData:(str_cs_msg_t*)msg
{
    Byte temp[4];
    int byteRead = 0;
    while(byteRead < 4)
    {
        ssize_t ret = recv(socketFileDescriptor, temp+byteRead, 4-byteRead, 0);
        if(ret > 0)
        {
            byteRead += ret;
        }
        else
        {
            close(socketFileDescriptor);
            socketFileDescriptor = -1;
            
            NSLog(@"读取消息头失败！");
            
            return false;
        }
    }
    uint32_t msg_head = ntohl(*((uint32_t*)temp));
    
    byteRead = 0;
    while(byteRead < 4)
    {
        ssize_t ret = recv(socketFileDescriptor,temp+byteRead, 4-byteRead, 0);
        if(ret > 0)
        {
            byteRead += ret;
        }
        else
        {
            close(socketFileDescriptor);
            socketFileDescriptor = -1;
            
            NSLog(@"读取消息体长度失败！");
            
            return  false;
        }
    }
    uint32_t msg_length = ntohl(*((uint32_t*)temp));
    
    uint8_t msg_body[msg_length];
    byteRead = 0;
    while(byteRead < msg_length)
    {
        ssize_t ret = recv(socketFileDescriptor,msg_body+byteRead,msg_length-byteRead,0);
        if(ret > 0)
        {
            byteRead += ret;
        }
        else
        {
            close(socketFileDescriptor);
            socketFileDescriptor = -1;
            
            NSLog(@"读取消息体失败！");
            
            return false;
        }
    }
    
    msg->msg_head = msg_head;
    msg->msg_length = msg_length;
    memcpy(msg->msg_body, msg_body,msg_length);
    
    return true;
}

-(BOOL)close
{
    close(socketFileDescriptor);
    socketFileDescriptor = -1;
    
    return true;
}

@end
