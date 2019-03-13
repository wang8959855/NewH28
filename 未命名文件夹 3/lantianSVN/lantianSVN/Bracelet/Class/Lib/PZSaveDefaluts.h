//
//  PZSaveDefaluts.h
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/3/4.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZSaveDefaluts : NSObject

/**
 *  保存值到UserDefaults
 *
 *  @param obj 值
 *  @param key key
 */
+ (void)setObject:(id)obj forKey:(NSString *)key;
/**
 *  从偏好设置中取出值
 *
 *  @param key
 *
 *  @return
 */
+ (id)objectForKey:(NSString *)key;

+ (void)remobeObjectForKey:(NSString *)key;

@end
