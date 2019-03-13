//
//  EditPhoneViewController.h
//  Bracelet
//
//  Created by panzheng on 2017/5/20.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^phoneNumberBlock)(NSString *phoneNumber);

@interface EditPhoneViewController : BaseViewController

@property (nonatomic, copy) phoneNumberBlock block;

@property (nonatomic, strong) NSString * numberString;

@property (nonatomic, strong) NSString *labelString;

@end
