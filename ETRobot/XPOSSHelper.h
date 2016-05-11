//
//  XPOSSHelper.h
//  图片存储
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPOSSHelperDelegate <NSObject>

- (void)downImageSuccess:(UIImage *)image;

@end

@interface XPOSSHelper : NSObject

@property (nonatomic,weak)id<XPOSSHelperDelegate> delegate;

#pragma mark 初始化工具类
- (void)initOSSClient;

#pragma mark 创建Bucket
- (void)createBucketWithBucketName:(NSString *)bucketName;

#pragma mark 删除Bucket
- (void)deleteBucketWithBucketName:(NSString *)bucketName;

#pragma mark 在指定的Bucket里面的object
- (void)listObjectsInBucketWithBucketName:(NSString *)bucketName;


#pragma mark 上传文件
// 异步上传
- (void)asyncUploadObjectAsyncWithUpLoadData:(NSData *)data fileName:(NSString *)fileName;

// 同步上传
- (void)syncUploadObjectSyncWithUpLoadData:(NSData *)data fileName:(NSString *)fileName;


#pragma mark 下载文件
// 流式下载
- (void)flowAsyncDownloadObjectWithFileName:(NSString *)fileName;

// 异步下载
- (void)asyncDownloadObjectWithFileName:(NSString *)fileName;

// 同步下载
- (void)downloadObjectSyncWithFileName:(NSString *)fileName;





// 获取meta
- (void)headObjectWithFileName:(NSString *)fileName;

// 删除Object
- (void)deleteObjectWithObjectName:(NSString *)objectName;

// 复制Object
- (void)copyObjectAsyncWithObjectName:(NSString *)objectName newObjectName:(NSString *)netObjectName;

// 签名URL授予第三方访问
- (void)signAccessObjectURLWithObjectName:(NSString *)objectName;

// 分块上传
- (void)multipartUploadWithUpLoadData:(NSData *)upLoadData fileName:(NSString *)fileName;

// 罗列分块
- (void)listPartsWithObjectName:(NSString *)objectName;

@end
