//
//  AFAppDotNetAPIClient.m
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/3/6.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

static NSString *baseURL = @"http://api.lantianfangzhou.com/api";


@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient
{
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] init];
    });
    return _sharedClient;
}

- (NSURLSessionDataTask *)globalRequestWithRequestSerializerType:(AFHTTPRequestSerializer *) requestSerializer
                                    ResponseSerializeType:(AFHTTPResponseSerializer *) responseSerializer
                                                     RequestType:(NSAFRequestType_Enum) requestType
                                                      RequestURL:(NSString *) requestURL
                                            ParametersDictionary:(NSDictionary *) parameterDictionary
                                                           Block:(void (^)(id responseObject, NSError *error,NSURLSessionDataTask* task))block
{

    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    
//    session.securityPolicy = [self getSecurityPolicy];
    
    session.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//    session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (requestType == NSAFRequest_POST)
    {
        if (requestSerializer) {
            session.requestSerializer = requestSerializer;
        
        }
        if (responseSerializer) {
            session.responseSerializer = responseSerializer;
        }
        
        return [session POST:requestURL parameters:parameterDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (block)
            {
                block(responseObject,nil,task);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block)
            {
                block(nil,error,task);
            }
        }];

    }else
    {

        if (requestSerializer)
        {
            session.requestSerializer = requestSerializer;
        }
        if (responseSerializer) {
            session.responseSerializer = responseSerializer;
        }

        [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        session.requestSerializer.timeoutInterval = 15.f;
        [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        return [session GET:requestURL parameters:parameterDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (block) {
                block(responseObject,nil,task);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                block(nil,error,task);
            }
        }];
    }
}

- (AFSecurityPolicy *)getSecurityPolicy
{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"www.czjk1" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *cerSet = [[NSSet alloc] initWithObjects:cerData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName=NO;
    securityPolicy.pinnedCertificates = cerSet;
    return securityPolicy;
}

- (void)globalUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath
                      Block:(void (^)(id responseObject,NSError *error))block{
    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    session.securityPolicy = [self getSecurityPolicy];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromFile:filePathURL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (block) {
            block(responseObject, error);
        }
    }];
    [uploadTask resume];
}

- (void)globalmultiPartUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath params:(NSDictionary *)params
                               Block:(void (^)(id responseObject,NSError *error))block
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:baseURL]];
    
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 60;
    if (!filePath) {
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"multipart/form-data", nil];
    }
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (filePath) {
            [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:@"file" error:nil];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

- (void)globalDownloadWithUrl:(NSString *)urlStr Block:(void (^)(id responseObject, NSURL *filePath,NSError *error))block {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.czjk888.com"]];
    
    
    manager.securityPolicy = [self getSecurityPolicy];

    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        // adaLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        // NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        //adaLog(@"== %@ |||| %@", fileURL1, fileURL);
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (block) {
            block(response,filePath,error);
        }
    }];
    
    [task resume];
}


@end
