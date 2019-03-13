// AFAppDotNetAPIClient.h
//http://www.heweather.com/documents  和风api的文档
#define WEBWEATHER @"https://api.heweather.com/v5/weather?city="
#define KEYWEATHER @"&key="

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL NO
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#define certificate @"certificate-https"

#define certificateBendi @"server-192.168.6.166"

//#define KONEDAYSECONDS 86400

#import "AFAppDotNetAPIClient1.h"
#import <CoreLocation/CoreLocation.h>

@implementation AFAppDotNetAPIClient1

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc]init];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)globalRequestWithRequestSerializerType:(AFHTTPRequestSerializer *) requestSerializer
                                           ResponseSerializeType:(AFHTTPResponseSerializer *) responseSerializer
                                                     RequestType:(NSAFRequestType_Enum) requestType
                                                      RequestURL:(NSString *) requestURL
                                            ParametersDictionary:(NSDictionary *) parameterDictionary
                                                           Block:(void (^)(id responseObject, NSError *error,NSURLSessionDataTask*task))block
{
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:
    //                                    [NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:
                                     [NSURL URLWithString:ROOT_URL]];
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 60;
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    if (requestType == NSAFRequest_POST) {
        if (requestSerializer) {
            manager.requestSerializer = requestSerializer;
            
        }
        if (responseSerializer) {
            manager.responseSerializer = responseSerializer;
        }
        return [manager POST:requestURL parameters:parameterDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (block) {
                block(responseObject, nil,task);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                block(nil, error,task);
            }
        }];
        
    }else {
        if (requestSerializer) {
            manager.requestSerializer = requestSerializer;
        }
        if (responseSerializer) {
            manager.responseSerializer = responseSerializer;
        }
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 60.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        return [manager GET:requestURL parameters:parameterDictionary progress:nil
                    success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                        if (block) {
                            NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                            string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                            [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
                            NSDictionary *newDic = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:nil];
                            block(newDic, nil,task);
                        }
                    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                        if (block) {
                            block(nil, error,task);
                        }
                    }];
    }
}


- (void)globalDownloadWithUrl:(NSString *)urlStr Block:(void (^)(id responseObject, NSURL *filePath,NSError *error))block
{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        // //adaLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        // NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        ////adaLog(@"== %@ |||| %@", fileURL1, fileURL);
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (block) {
            block(response,filePath,error);
        }
    }];
    
    [task resume];
}

- (void)globalUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath
                      Block:(void (^)(id responseObject,NSError *error))block
{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePathURL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (block) {
            block(responseObject, error);
        }
    }];
    [uploadTask resume];
}

+ (void)netWorkStatusWithBlock:(void (^)(AFNetworkReachabilityStatus status))block
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (block) {
            block(status);
        }
    }];
}
+(void)startMonitor
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // 未知网络
                //adaLog(@"未知网络");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:// 没有网络(断网)
                //adaLog(@"没有网络(断网)");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:// 手机自带网络
                //adaLog(@"手机自带网络");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // WIFI
                //adaLog(@"WIFI");
                //                kHCH.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                break;
        }
    }];
    // 3.开始监控
    [manager startMonitoring];
    
}

- (void)globalmultiPartUploadWithUrl:(NSString *)urlStr fileUrl:(NSString *)filePath params:(NSDictionary *)params Block:(void (^)(id responseObject,NSError *error))block
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ROOT_URL]];
    
    // 3.设置超时时间为10s
    manager.requestSerializer.timeoutInterval = 60;
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (filePath)
        {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:nil];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(responseObject,nil);
        }
        int code = [[responseObject objectForKey:@"code"] intValue];
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1001"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:changeLoginNofication object:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
    }];
}

#pragma mark  - - 请求的的数据处理
#pragma mark  - - 请求的的数据处理 -- 处理国外数据
//请求某天数据。某天是今天时  -- 国外天气
#pragma mark   - -- - https 的验证

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书  certificate     certificateBendi
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeNone: 代表客户端无条件地信任服务器端返回的证书。
    //AFSSLPinningModePublicKey: 代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行。
    //AFSSLPinningModeCertificate: 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    securityPolicy.pinnedCertificates = (NSSet *)@[certData];
    
    return securityPolicy;
}

@end
