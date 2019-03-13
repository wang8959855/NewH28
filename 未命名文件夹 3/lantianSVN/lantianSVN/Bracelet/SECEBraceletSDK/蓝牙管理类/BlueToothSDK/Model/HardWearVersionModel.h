//
//  HardWearVersionModel.h
//  Bracelet
//
//  Created by panzheng on 2017/3/24.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HardWearVersionModel : NSObject


/**
 硬件固件name字符串,此name用来区别版本检查更新
 */
@property (nonatomic, strong) NSString *nameString;


/**
 硬件固件软件版本
 */
//@property (nonatomic, assign) int mainSoftVersion;


@end
