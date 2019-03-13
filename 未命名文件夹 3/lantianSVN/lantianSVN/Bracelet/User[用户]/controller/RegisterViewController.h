//
//  RegisterViewController.h
//  Bracelet
//
//  Created by SZCE on 16/1/6.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController

/**
 *  判断是否是刚刚注册完进入个人信息界面，如果是，本地的个人信息全部置为默认值。
 */
@property (nonatomic) BOOL *isJustRegister;

@end
