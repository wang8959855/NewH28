//
//  userDataModel.h
//  Bracelet
//
//  Created by 潘峥的MacBook on 2017/2/21.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userDataModel : NSObject

@property (strong, nonatomic) NSString *name;

@property (assign, nonatomic) int lastUpdate;

@property (assign, nonatomic) int timeSeconds;

@property (strong, nonatomic) NSData *userData;

@property (assign, nonatomic) int totalSteps;

+ (NSString *)VERSION;

@end
