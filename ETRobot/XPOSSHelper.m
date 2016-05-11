//
//  XPOSSHelper.m
//  图片存储
//
//  Created by IHOME on 16/5/10.
//  Copyright © 2016年 IHOME. All rights reserved.
//

#import "XPOSSHelper.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>

NSString * const AccessKey = @"Qw95mbTHLrpUCXik";
NSString * const SecretKey = @"iabdj9mCegCauvQO9rN3oFrzNZtIoz";
NSString * const endPoint = @"http://oss-cn-shanghai.aliyuncs.com";
NSString * const bucketName = @"xiangping";


OSSClient * client;
static dispatch_queue_t queue4demo;

@implementation XPOSSHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        [OSSLog enableLog];
        [self initOSSClient];
        
    }
    return self;
}

#pragma mark 初始化工具类
- (void)initOSSClient {
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey secretKey:SecretKey];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
}


#pragma mark 创建Bucket
- (void)createBucketWithBucketName:(NSString *)bucketName
{
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = bucketName;
    create.xOssACL = @"public-read";
    create.location = @"oss-cn-hangzhou";
    
    OSSTask * createTask = [client createBucket:create];
    
    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"create bucket success!");
        } else {
            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

#pragma mark 删除Bucket
- (void)deleteBucketWithBucketName:(NSString *)bucketName
{
    OSSDeleteBucketRequest * delete = [OSSDeleteBucketRequest new];
    delete.bucketName = bucketName;
    
    OSSTask * deleteTask = [client deleteBucket:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete bucket success!");
        } else {
            NSLog(@"delete bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

#pragma mark 在指定的Bucket里面的object
- (void)listObjectsInBucketWithBucketName:(NSString *)bucketName
{
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = bucketName;
    getBucket.delimiter = @"";
    getBucket.prefix = @"";
    
    OSSTask * getBucketTask = [client getBucket:getBucket];
    
    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"get bucket success!");
            for (NSDictionary * objectInfo in result.contents) {
                NSLog(@"list object: %@", objectInfo);
            }
        } else {
            NSLog(@"get bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

#pragma mark 上传文件
// 异步上传
- (void)asyncUploadObjectAsyncWithUpLoadData:(NSData *)data fileName:(NSString *)fileName
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = bucketName;
    put.objectKey = fileName;
    put.uploadingData = data; // 直接上传NSData
    
    put.contentMd5 = [OSSUtil base64Md5ForData:data]; // 如果是二进制数据
    put.contentType = @"application/octet-stream";

    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

// 同步上传
- (void)syncUploadObjectSyncWithUpLoadData:(NSData *)data fileName:(NSString *)fileName
{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = bucketName;
    put.objectKey = fileName;
    put.uploadingData = data; // 直接上传NSData
    
    put.contentMd5 = [OSSUtil base64Md5ForData:data]; // 如果是二进制数据
    put.contentType = @"application/octet-stream";
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
        NSLog(@"upload object success!");
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
    }
}



#pragma mark 下载文件
// 流式下载
- (void)flowAsyncDownloadObjectWithFileName:(NSString *)fileName
{
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = bucketName;
    request.objectKey = fileName;
    
    // 分段回调函数
    request.onRecieveData = ^(NSData * data) {
        NSLog(@"Recieve data, length: %ld", [data length]);
    };
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
            UIImage *image = [[UIImage alloc]initWithData:getResult.downloadedData];
            [self.delegate downImageSuccess:image];
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}

// 异步下载
- (void)asyncDownloadObjectWithFileName:(NSString *)fileName
{
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = bucketName;
    request.objectKey = fileName;
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
            UIImage *image = [[UIImage alloc]initWithData:getResult.downloadedData];
            [self.delegate downImageSuccess:image];
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}

// 同步下载
- (void)downloadObjectSyncWithFileName:(NSString *)fileName
{
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = bucketName;
    request.objectKey = fileName;
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask waitUntilFinished];
    
    if (!getTask.error) {
        OSSGetObjectResult * result = getTask.result;
        UIImage *image = [[UIImage alloc]initWithData:result.downloadedData];
        [self.delegate downImageSuccess:image];
        NSLog(@"download data length: %lu", [result.downloadedData length]);
    } else {
        NSLog(@"download data error: %@", getTask.error);
    }
}





// 获取meta
- (void)headObjectWithFileName:(NSString *)fileName
{
    OSSHeadObjectRequest * head = [OSSHeadObjectRequest new];
    head.bucketName = bucketName;
    head.objectKey = fileName;
    
    OSSTask * headTask = [client headObject:head];
    
    [headTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSHeadObjectResult * headResult = task.result;
            NSLog(@"all response header: %@", headResult.httpResponseHeaderFields);
            
            // some object properties include the 'x-oss-meta-*'s
            NSLog(@"head object result: %@", headResult.objectMeta);
        } else {
            NSLog(@"head object error: %@", task.error);
        }
        return nil;
    }];
}

// 删除Object
- (void)deleteObjectWithObjectName:(NSString *)objectName
{
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = bucketName;
    delete.objectKey = objectName;
    
    OSSTask * deleteTask = [client deleteObject:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete success !");
        } else {
            NSLog(@"delete erorr, error: %@", task.error);
        }
        return nil;
    }];
}

// 复制Object
- (void)copyObjectAsyncWithObjectName:(NSString *)objectName newObjectName:(NSString *)netObjectName
{
    OSSCopyObjectRequest * copy = [OSSCopyObjectRequest new];
    copy.bucketName = bucketName; // 复制到哪个bucket
    copy.objectKey = objectName; // 复制为哪个object
    copy.sourceCopyFrom = [NSString stringWithFormat:@"/%@/%@", bucketName, netObjectName]; // 从哪里复制
    
    OSSTask * copyTask = [client copyObject:copy];
    
    [copyTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"copy success!");
        } else {
            NSLog(@"copy error, error: %@", task.error);
        }
        return nil;
    }];
}

// 签名URL授予第三方访问
- (void)signAccessObjectURLWithObjectName:(NSString *)objectName
{
    NSString * constrainURL = nil;
    NSString * publicURL = nil;
    
    // sign constrain url
    OSSTask * task = [client presignConstrainURLWithBucketName:bucketName
                                                 withObjectKey:objectName
                                        withExpirationInterval:60 * 30];
    if (!task.error) {
        constrainURL = task.result;
    } else {
        NSLog(@"error: %@", task.error);
    }
    
    // sign public url
    task = [client presignPublicURLWithBucketName:bucketName
                                    withObjectKey:objectName];
    if (!task.error) {
        publicURL = task.result;
    } else {
        NSLog(@"sign url error: %@", task.error);
    }
}

// 分块上传
- (void)multipartUploadWithUpLoadData:(NSData *)upLoadData fileName:(NSString *)fileName
{
    
    __block NSString * uploadId = nil;
    __block NSMutableArray * partInfos = [NSMutableArray new];
    
    NSString * uploadToBucket = bucketName;
    NSString * uploadObjectkey = fileName;
    
    OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
    init.bucketName = uploadToBucket;
    init.objectKey = uploadObjectkey;
    init.contentType = @"application/octet-stream";
    init.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    
    OSSTask * initTask = [client multipartUploadInit:init];
    
    [initTask waitUntilFinished];
    
    if (!initTask.error) {
        OSSInitMultipartUploadResult * result = initTask.result;
        uploadId = result.uploadId;
        NSLog(@"init multipart upload success: %@", result.uploadId);
    } else {
        NSLog(@"multipart upload failed, error: %@", initTask.error);
        return;
    }
    
    for (int i = 1; i <= 3; i++) {
        OSSUploadPartRequest * uploadPart = [OSSUploadPartRequest new];
        uploadPart.bucketName = uploadToBucket;
        uploadPart.objectkey = uploadObjectkey;
        uploadPart.uploadId = uploadId;
        uploadPart.partNumber = i; // part number start from 1
        
        uploadPart.uploadPartData = upLoadData;
        
        OSSTask * uploadPartTask = [client uploadPart:uploadPart];
        
        [uploadPartTask waitUntilFinished];
        
        if (!uploadPartTask.error) {
            OSSUploadPartResult * result = uploadPartTask.result;
            uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:uploadPart.uploadPartFileURL.absoluteString error:nil] fileSize];
            [partInfos addObject:[OSSPartInfo partInfoWithPartNum:i eTag:result.eTag size:fileSize]];
        } else {
            NSLog(@"upload part error: %@", uploadPartTask.error);
            return;
        }
    }
    
    OSSCompleteMultipartUploadRequest * complete = [OSSCompleteMultipartUploadRequest new];
    complete.bucketName = uploadToBucket;
    complete.objectKey = uploadObjectkey;
    complete.uploadId = uploadId;
    complete.partInfos = partInfos;
    
    OSSTask * completeTask = [client completeMultipartUpload:complete];
    
    [completeTask waitUntilFinished];
    
    if (!completeTask.error) {
        NSLog(@"multipart upload success!");
    } else {
        NSLog(@"multipart upload failed, error: %@", completeTask.error);
        return;
    }
}

// 罗列分块
- (void)listPartsWithObjectName:(NSString *)objectName
{
    OSSListPartsRequest * listParts = [OSSListPartsRequest new];
    listParts.bucketName = bucketName;
    listParts.objectKey = objectName;
    listParts.uploadId = @"265B84D863B64C80BA552959B8B207F0";
    
    OSSTask * listPartTask = [client listParts:listParts];
    
    [listPartTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"list part result success!");
            OSSListPartsResult * listPartResult = task.result;
            for (NSDictionary * partInfo in listPartResult.parts) {
                NSLog(@"each part: %@", partInfo);
            }
        } else {
            NSLog(@"list part result error: %@", task.error);
        }
        return nil;
    }];
}

@end
