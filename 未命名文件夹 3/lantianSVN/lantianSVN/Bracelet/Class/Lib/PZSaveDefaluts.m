//
//  PZSaveDefaluts.m
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/3/4.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "PZSaveDefaluts.h"

@implementation PZSaveDefaluts


+ (void)setObject:(id)obj forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)remobeObjectForKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end
