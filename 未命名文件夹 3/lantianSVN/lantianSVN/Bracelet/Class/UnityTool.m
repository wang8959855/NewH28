//
//  UnityTool.m
//  LingQianGuan
//
//  Created by wtjr on 16/6/12.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#import "UnityTool.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>


@interface UnityTool ()
{
    NSUserDefaults *_userDefaults;
    
    //uuid
   
}

@end

@implementation UnityTool

+ (instancetype)shareInstance
{
    static UnityTool *manager = nil;
    @synchronized(self) {
        if (!manager) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        //保存UUID到keychain中
      
    }
    return self;
}






#pragma mark - 使用公钥字符串加密

static NSString *base64_encode_data(NSData *data)
{
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str)
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}



#pragma mark - MD5加密
//加密字符串
+ (NSString *)md5ForString:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *md5 = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    return [md5 lowercaseString];
}
//加密data
+ (NSString *)md5ForData:(NSData *)data
{
    if( !data || ![data length] )
    {
        return nil;
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - 控制器相关

@end
