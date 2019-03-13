//
//  AFAppDotNetAPIClient.h
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/3/6.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NSAFRequest_GET = 0,
    NSAFRequest_POST,
}NSAFRequestType_Enum;

@interface AFAppDotNetAPIClient : NSObject

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)globalRequestWithRequestSerializerType:(AFHTTPRequestSerializer *) requestSerializer
                                           ResponseSerializeType:(AFHTTPResponseSerializer *) responseSerializer
                                                     RequestType:(NSAFRequestType_Enum) requestType
                                                      RequestURL:(NSString *) requestURL
                                            ParametersDictionary:(NSDictionary *) parameterDictionary
                                                           Block:(void (^)(id responseObject, NSError *error,NSURLSessionDataTask*task))block;

- (void)globalmultiPartUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath params:(NSDictionary *)params
                               Block:(void (^)(id responseObject,NSError *error))block;
- (void)globalUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath
                      Block:(void (^)(id responseObject,NSError *error))block;

- (void)globalDownloadWithUrl:(NSString *)urlStr
                        Block:(void (^)(id responseObject, NSURL *filePath,NSError *error))block;
@end
