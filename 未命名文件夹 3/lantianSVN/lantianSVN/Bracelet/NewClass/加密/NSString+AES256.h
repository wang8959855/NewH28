//
//  NSString+AES256.h
//  Bracelet
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES256)

+ (NSString *)encrypyAES:(NSString *)content key:(NSString *)key;

@end
