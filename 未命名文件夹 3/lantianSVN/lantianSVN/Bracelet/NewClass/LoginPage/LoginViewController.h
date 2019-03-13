//
//  LoginViewController.h
//  keyband
//
//  Created by 迈诺科技 on 15/10/27.
//  Copyright © 2015年 mainuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutocompletionTableView.h"

@interface LoginViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *passWordTF;



@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (weak, nonatomic) IBOutlet UIButton *verificationButton;


@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) AutocompletionTableView * completionTableView;

@property (weak, nonatomic) IBOutlet UIImageView *eyeImageView;

@property (weak, nonatomic) IBOutlet UILabel *thirdPartLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;


@end
