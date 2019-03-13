//
//  UserInfoModel.h
//  Bracelet
//
//  Created by panzheng on 2017/3/14.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *headimg;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *gender;

@property (nonatomic, strong) NSString *birthday;

@property (nonatomic, strong) NSString *height;

@property (nonatomic, strong) NSString *weight;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSString *age;

@property (nonatomic, assign) BOOL isThird;
//@property (nonatomic, strong) NSString *stepTarget;
//
//@property (nonatomic, strong) NSString *sleepTarget;



@end
