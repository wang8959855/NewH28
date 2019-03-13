//
//  RegisterViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/6.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "RegisterViewController.h"
#import "XXUserInformation.h"
#import "LoginViewController1.h"
#import "UserInfoViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{

    BOOL isNetworking;
}

/**
 * 菊花控件
 */

/**
 *  导航标签
 */

/**
 *  背景视图
 */
@property (weak, nonatomic)  UIView *backgroudView;

/**
 *  昵称输入框
 */


/**
 *  邮箱输入框
 */
@property (weak, nonatomic)  UITextField *emailTF;

/**
 *  第一次输入密码输入框
 */
@property (weak, nonatomic)  UITextField *firstPasswordTF;

/**
 *  再次输入密码输入框
 */
@property (weak, nonatomic)  UITextField *secondPasswordTF;

/**
 *  注册按钮
 */
@property (weak, nonatomic)  UIButton *registerBtn;

@end

@implementation RegisterViewController

#pragma mark - 懒加载



#pragma mark - viewDidLoad入口
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = KCOLOR(42, 167, 155);
    [self loadUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
/**
 *  返回到选择页面
 *
 *  @param sender
 */
- (void)back:(id)sender {
    
    [self cancelFiled];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  注册
 *
 *  @param sender <#sender description#>
 */
- (void)registers:(id)sender {

    //1、退出键盘
    [self cancelFiled];
    //2、判断输入框
    if (self.firstPasswordTF.text.length < 6 || self.firstPasswordTF.text.length > 20 || self.secondPasswordTF.text.length < 6 || self.secondPasswordTF.text.length > 20) {
        
        [self.view makeToast:NSLocalizedString(@"密码长度为6～20，请核对", nil) duration:1 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    //3、判断邮箱是否合理
    
    if ([_emailTF.text containsString:@"@"])
    {
        if (![Common validateEmail:self.emailTF.text]) {
            
            [self.view makeToast:NSLocalizedString(@"请输入正确的邮箱账号", nil) duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
    }else{
        if (![Common validatePhoneNumber:self.emailTF.text])
        {
            [self.view makeToast:NSLocalizedString(@"请输入正确的邮箱或手机号码",nil) duration:2.5f position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
    }
    

    //4 、判断两次密码是否一致
    if (![self judgePassword]) {
        return;
    }
    [self.activityView startAnimating];

    //4、将信息发送给服务器
    NSDictionary *dict = @{@"pwd":[UnityTool md5ForString:self.firstPasswordTF.text],@"name":self.emailTF.text};
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(appDelegate.isNetworking){
        [self networking:dict];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view makeToast:@"网络不可用" duration:1.0 position:@"center"];
            [self.activityView stopAnimating];
        });
    }
}

#pragma mark - 界面布局
/**
 *  初始化界面
 */
- (void)loadUI
{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"注册",nil);
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.topSpaceToView(self.view, 30)
    .centerXIs(ScreenW / 2.0)
    .heightIs(30);
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton.sd_layout.topSpaceToView(self.view, 30)
    .leftSpaceToView(self.view, 12)
    .widthIs(60)
    .heightIs(30);
    
    [self backgroudView];
    [self emailTF];
    [self firstPasswordTF];
    
    self.registerBtn.layer.cornerRadius = 5;
    
   
    
    self.secondPasswordTF.placeholder = NSLocalizedString(@"请再次输入密码", nil);
    self.secondPasswordTF.delegate = self;
    [self configTextField:self.secondPasswordTF];

    [self.registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
}

/**
 *  成功注册的界面
 */
- (void)loadSuccessUI
{
    UserInfoViewController *personVC = [[UserInfoViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:personVC];
    personVC.navigationController.navigationBar.hidden = YES;
    personVC.isRegist = YES;
    [self presentViewController:nav animated:YES completion:nil];
    return;
}

#pragma mark - private


- (void)networking:(NSDictionary *)dict{
    

    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_GET RequestURL:@"register" ParametersDictionary:dict Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        adaLog(@"%@",responseObject);
        [self.activityView stopAnimating];
        
        if(responseObject){
            
            NSDictionary *data = responseObject[@"data"];
            kHCH.userInfoModel.uid = data[@"uid"];
            kHCH.userInfoModel.name = self.emailTF.text;
            [kHCH userInfoModelChanged];

            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]] ;
            if ([code isEqualToString:@"0"])
            {
                //1、如果成功，保存信息
                //                [XXUserInformation setUserName:self.userNameTF.text];
                [XXUserInformation setEmail:self.emailTF.text];
                
                kHCH.userInfoModel.name = self.emailTF.text;
                //2、移除重置密码界面，显示已经成功界面
                [self loadSuccessUI];
            }else
            {
                [self.view makeToast:NSLocalizedString(@"用户已存在",nil) duration:2 position:[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.height - 100)]];
            }
        }else
        {
            adaLog(@"%@",error);
            [self.view makeToast:[NSString stringWithFormat:@"%@",error] duration:2 position:[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.height - 100)]];
        }
    }];
}

/**
 *  取消输入框的第一响应，收回键盘
 */
- (void)cancelFiled
{
    [self.view endEditing:YES];
}

/**
 *  配置输入框的文字颜色和大小
 *
 *  @param textFiled 需要配置的输入框
 */


- (BOOL)judgePassword
{
    NSString *firstString = self.firstPasswordTF.text;
    NSString *secondString = self.secondPasswordTF.text;
    
    if (![firstString isEqualToString:@""] && ![secondString isEqualToString:@""] && ![firstString isEqualToString: secondString]) {
        
        [self.view makeToast:NSLocalizedString(@"两次密码输入不一致", nil) duration:1 position:[NSValue valueWithCGPoint:self.view.center]];
        return NO;
        
    }
    return YES;
}

#pragma mark -- GET方法

- (UIView *)backgroudView
{
    if (!_backgroudView)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = KCOLOR(35, 145, 136);
        backView.frame = [self setCGRectWithX:35 Y:151 Width:375 - 70 Heigth:335];
        _backgroudView = backView;
        _backgroudView.layer.cornerRadius = 5;
        [self.view addSubview:_backgroudView];
    }
    return _backgroudView;
}

- (UITextField *)emailTF
{
    if (!_emailTF)
    {
        UITextField *nameTextField = [[UITextField alloc] init];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.frame = [self setCGRectWithX:25 Y:20 Width:252 Heigth:40];
        nameTextField.textAlignment = NSTextAlignmentCenter;
        nameTextField.textColor = [UIColor whiteColor];
        _emailTF = nameTextField;
        [self.backgroudView addSubview:_emailTF];
        _emailTF.delegate = self;
        _emailTF.placeholder = NSLocalizedString(@"手机/邮箱", nil);
        
        [self configTextField:_emailTF];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroudView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(nameTextField, 0)
        .leftEqualToView(nameTextField)
        .rightEqualToView(nameTextField)
        .heightIs(1);
    }
    return _emailTF;
}

- (UITextField *)firstPasswordTF
{
    if(!_firstPasswordTF)
    {
        UITextField *passTF = [[UITextField alloc] init];
        passTF.borderStyle = UITextBorderStyleNone;
        passTF.frame = [self setCGRectWithX:25 Y:80 Width:252 Heigth:40];
        passTF.textAlignment = NSTextAlignmentCenter;
        passTF.textColor = [UIColor whiteColor];
        passTF.delegate = self;
        passTF.placeholder = NSLocalizedString(@"请输入密码",nil);
        passTF.secureTextEntry = YES;
        [self configTextField:passTF];
        _firstPasswordTF = passTF;
        [self.backgroudView addSubview:_firstPasswordTF];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroudView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(passTF, 0)
        .leftEqualToView(passTF)
        .rightEqualToView(passTF)
        .heightIs(1);
        
    }
    return _firstPasswordTF;
}

- (UITextField *)secondPasswordTF
{
    if(!_secondPasswordTF)
    {
        UITextField *passTF = [[UITextField alloc] init];
        passTF.borderStyle = UITextBorderStyleNone;
        passTF.frame = [self setCGRectWithX:25 Y:140 Width:252 Heigth:40];
        passTF.textAlignment = NSTextAlignmentCenter;
        passTF.textColor = [UIColor whiteColor];
        passTF.delegate = self;
        passTF.placeholder = NSLocalizedString(@"请再次输入密码",nil);
        passTF.secureTextEntry = YES;
        [self configTextField:passTF];
        _secondPasswordTF = passTF;
        [self.backgroudView addSubview:_secondPasswordTF];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroudView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(passTF, 0)
        .leftEqualToView(passTF)
        .rightEqualToView(passTF)
        .heightIs(1);
        
    }
    return _secondPasswordTF;
}

- (UIButton *)registerBtn
{
    if (!_registerBtn)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:KCOLOR(0, 164, 152) forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"登录",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(registers:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = [self setCGRectWithX:60 Y:235 Width:302-120 Heigth:39];
        button.layer.cornerRadius = 5;
        _registerBtn = button;
        [self.backgroudView addSubview:_registerBtn];
    }
    return _registerBtn;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
