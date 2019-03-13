//
//  LoginViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/5.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "LoginViewController1.h"
#import "XXTabBarController.h"
#import "XXUserInformation.h"
#import "RegisterViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UserInfoViewController.h"
#import "ChoseAcountRestPasswordViewController.h"

@interface LoginViewController1 ()<UITextFieldDelegate>
{
    BOOL isLoading;
}
/**
 *  导航登录标签
 */

/**
 *  背景视图
 */
@property (weak, nonatomic)  UIView *backgroudView;

/**
 *  登录按钮
 */
@property (weak, nonatomic)  UIButton *loginBtn;

/**
 *  登录帐号输入框
 */
@property (weak, nonatomic)  UITextField *loginNameTF;

/**
 *  密码输入框
 */
@property (weak, nonatomic)  UITextField *passwordTF;

/**
 *  保存密码提示标签
 */

/**
 *  忘记密码按钮
 */
@property (weak, nonatomic)  UIButton *forgetBtn;
/**
 *  清除输入框内容按钮
 */
@end

@implementation LoginViewController1

#pragma mark -  懒加载

#pragma mark - viewDidLoad入口
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kmainBackgroundColor;
    [self loadUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action


- (void)facebookLogin
{
    [self getUserInfoForPlatform:UMSocialPlatformType_Facebook];
}

- (void)qqLogin
{
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];

}

- (void)twitterLogin{
    [self getUserInfoForPlatform:UMSocialPlatformType_Twitter];

}

- (void)wechatLogin
{
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        if (error)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"授权失败",nil) deleyTime:1.5f];
        }else
        {
            [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在登录",nil) detailLabel:nil];

            UMSocialUserInfoResponse *resp = result;

            NSLog(@" uid: %@", resp.uid);
            NSLog(@" openid: %@", resp.openid);
            NSLog(@" accessToken: %@", resp.accessToken);
            NSLog(@" refreshToken: %@", resp.refreshToken);
            NSLog(@" expiration: %@", resp.expiration);
            // 用户数据
            NSLog(@" name: %@", resp.name);
            NSLog(@" iconurl: %@", resp.iconurl);
            NSLog(@" gender: %@", resp.gender);
            // 第三方平台SDK原始数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
            
            adaLog(@"%@",resp.uid);
            NSDictionary *loginDic = @{@"uid":resp.uid};
            kWEAKSELF
            [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_GET RequestURL:@"loginQuser" ParametersDictionary:loginDic Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
                adaLog(@"%@",responseObject);
                [weakSelf removeActityIndicatorFromView:weakSelf.view];
                if (responseObject)
                {
                    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    if ([code isEqualToString:@"0"])
                    {
                        NSDictionary *data = responseObject[@"data"];
                        kHCH.userInfoModel = [UserInfoModel mj_objectWithKeyValues:data];
                        kHCH.userInfoModel.name =resp.name;
                        kHCH.userInfoModel.headimg =resp.iconurl;
                        kHCH.userInfoModel.isThird = YES;
                        [kHCH userInfoModelChanged];
                        if (kHCH.userInfoModel.birthday && kHCH.userInfoModel.birthday.length > 2)
                        {
                            [weakSelf succusedLogin];
                        }
                        else
                        {
                            [weakSelf loadSuccessUI];
                        }
                    }else
                    {
                        kHCH.userInfoModel.name =resp.name;
                        kHCH.userInfoModel.headimg =resp.iconurl;
                        kHCH.userInfoModel.isThird = YES;
                        kHCH.userInfoModel.uid = resp.uid;
                        [kHCH userInfoModelChanged];
                        [weakSelf loadSuccessUI];
                    }
                }else{
                    [self addActityTextInView:self.view text:NSLocalizedString(@"登录失败",nil) deleyTime:1.5f];
                }
            }];
        }
    }];
}

- (void)loadSuccessUI
{
    UserInfoViewController *personVC = [[UserInfoViewController alloc]init];
    personVC.isRegist = YES;
    personVC.navigationController.navigationBarHidden = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:personVC];
    [self presentViewController:nav animated:YES completion:nil];
    return;
}

/**
 *  选择是否保存密码
 *
 *  @param button 选择是否保存密码的按钮
 */
- (IBAction)saveSelect:(UIButton *)button {
    
    button.selected = !button.selected;
}

/**
 *  删除密码输入框的所有数据
 *
 *  @param sender <#sender description#>
 */
- (void)clear:(UIButton *)button {
    
    switch (button.tag) {
        case 0:
            [self.loginNameTF setText:@""];
            break;
        case 41:
            [self.passwordTF setText:@""];
            break;
        default:
            break;
    }
   
}

/**
 *  点击登录按钮
 *
 *  @param sender <#sender description#>
 */
- (void)login:(id)sender {
    
    //1、退出键盘
    [self cancelFiled];
    
    //2、判断输入框
    NSString *nameString = self.loginNameTF.text;

    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 20) {
        
        [self.view makeToast:NSLocalizedString(@"密码长度为6～20，请核对", nil) duration:1 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    if (!isLoading) {
        [self.view makeToast:NSLocalizedString(@"请稍候...", nil) duration:1.0f position:[NSValue valueWithCGPoint:self.view.center]];
        isLoading = YES;
    }
    
    //3、将用户名／邮箱 和密码发送给服务器端，根据服务器端返回的结果
    kHCH.userInfoModel.name = self.loginNameTF.text;
    
    NSDictionary *parameters;
    
    if ([nameString containsString:@"@"])
    {
        if (![Common validateEmail:nameString]) {
            
            [self.view makeToast:NSLocalizedString(@"请输入正确的邮箱账号", nil) duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
    }else{
        if (![Common validatePhoneNumber:nameString])
        {
            [self.view makeToast:NSLocalizedString(@"请输入正确的邮箱或手机号码",nil) duration:2.5f position:[NSValue valueWithCGPoint:self.view.center]];
            return;
        }
    }

        parameters = @{@"name":nameString,@"pwd":[UnityTool md5ForString:self.passwordTF.text]};
    
    if (isLoading) {
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(appDelegate.isNetworking){
            
        [self netWorking:parameters];
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view makeToast:@"网络不可用" duration:1.0 position:@"center"];
            });
        }
    }
}


- (void)forgetPassword:(id)sender {
    ChoseAcountRestPasswordViewController *choseVC = [ChoseAcountRestPasswordViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:choseVC];
    choseVC.navigationController.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate


#pragma mark -- GET方法
- (UIView *)backgroudView
{
    if (!_backgroudView)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor =kmainDarkColor;
        backView.frame = [self setCGRectWithX:35 Y:151 Width:375 - 70 Heigth:257];
        _backgroudView = backView;
        _backgroudView.layer.cornerRadius = 5;
        [self.view addSubview:_backgroudView];
    }
    return _backgroudView;
}


- (UITextField *)loginNameTF
{
    if (!_loginNameTF)
    {
        UITextField *nameTextField = [[UITextField alloc] init];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.frame = [self setCGRectWithX:25 Y:20 Width:252 Heigth:40];
        nameTextField.textAlignment = NSTextAlignmentCenter;
        nameTextField.textColor = [UIColor whiteColor];
        _loginNameTF = nameTextField;
        [self.backgroudView addSubview:_loginNameTF];
        _loginNameTF.delegate = self;
        _loginNameTF.placeholder = NSLocalizedString(@"手机/邮箱", nil);
        
        [self configTextField:_loginNameTF];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroudView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(nameTextField, 0)
        .leftEqualToView(nameTextField)
        .rightEqualToView(nameTextField)
        .heightIs(1);
    }
    return _loginNameTF;
}

- (UITextField *)passwordTF
{
    if(!_passwordTF)
    {
        UITextField *passTF = [[UITextField alloc] init];
        passTF.borderStyle = UITextBorderStyleNone;
        passTF.frame = [self setCGRectWithX:25 Y:80 Width:252 Heigth:40];
        passTF.textAlignment = NSTextAlignmentCenter;
        passTF.textColor = [UIColor whiteColor];
        passTF.delegate = self;
        passTF.placeholder = NSLocalizedString(@"密码",nil);
        passTF.secureTextEntry = YES;
        [self configTextField:passTF];
        _passwordTF = passTF;
        [self.backgroudView addSubview:_passwordTF];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroudView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(passTF, 0)
        .leftEqualToView(passTF)
        .rightEqualToView(passTF)
        .heightIs(1);

    }
    return _passwordTF;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:KCOLOR(0, 164, 152) forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"登录",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = [self setCGRectWithX:60 Y:155 Width:302-120 Heigth:39];
        button.layer.cornerRadius = 5;
        _loginBtn = button;
        [self.backgroudView addSubview:_loginBtn];
    }
    return _loginBtn;
}

- (UIButton *)forgetBtn
{
    if (!_forgetBtn)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"忘记密码?",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.frame = [self setCGRectWithX:302-button.width Y:220 Width:button.width Heigth:30];
        _forgetBtn = button;
        [self.backgroudView addSubview:_forgetBtn];
    }
    return _forgetBtn;
}

#pragma mark - private
/**
 *  初始化界面
 */
-(void)loadUI
{

    [self backgroudView];
    [self loginNameTF];
    [self passwordTF];
    [self loginBtn];
    [self forgetBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"登录",nil);
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    titleLabel.sd_layout.topSpaceToView(self.view, 30)
    .centerXIs(ScreenW / 2.0)
    .heightIs(30);
    
    
    UIButton *RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [RegisterBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegisterBtn.backgroundColor = kmainDarkColor;
    RegisterBtn.layer.cornerRadius = 5;
    RegisterBtn.layer.masksToBounds = YES;
    RegisterBtn.frame = [self setCGRectWithX:35 Y:463 Width:375-70 Heigth:46];
    [self.view addSubview: RegisterBtn];
    [RegisterBtn addTarget:self action:@selector(gotoRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *fastLoginLabel = [[UILabel alloc] init];
    fastLoginLabel.text = NSLocalizedString(@"第三方快速登录",nil);
    fastLoginLabel.textColor = KCOLOR(134, 211, 205);
    fastLoginLabel.font =[UIFont systemFontOfSize:15];
    fastLoginLabel.backgroundColor = KCOLOR(42, 167, 155);
    [fastLoginLabel sizeToFit];
    [self.view addSubview:fastLoginLabel];
    fastLoginLabel.frame = CGRectMake(0, 0, fastLoginLabel.width, 18);
    fastLoginLabel.center = CGPointMake(ScreenW/2.0, 570*kX);

    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = KCOLOR(134, 211, 205);
    [self.view addSubview:leftLineView];
    leftLineView.sd_layout.leftSpaceToView(self.view, 35*kX)
    .rightSpaceToView(fastLoginLabel, 3)
    .centerYIs(570 * kX)
    .heightIs(1);
    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor =  KCOLOR(134, 211, 205);
    [self.view addSubview:rightLineView];
    rightLineView.sd_layout.leftSpaceToView(fastLoginLabel, 3)
    .centerYIs(570 * kX)
    .heightIs(1)
    .rightSpaceToView(self.view, 35 * kX);

    NSArray *buttonArray =  @[@"wechatLogin",@"wechat_login",@"qqLogin",@"qq_login",@"facebookLogin",@"facebook_login",@"twitterLogin",@"twitter_login"];
    for (int i = 0 ; i < 4; i ++)
    {
        float width = ScreenW / 4.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, fastLoginLabel.bottom, width, ScreenH - fastLoginLabel.bottom);
        [button setImage:[UIImage imageNamed:buttonArray[i * 2 +1]] forState:UIControlStateNormal];
        [button addTarget:self action:NSSelectorFromString(buttonArray[i * 2]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}
//注册
-(void)gotoRegisterVC
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}
/**
 *  取消输入框的第一响应，收回键盘
 */
- (void)cancelFiled
{
    [self.loginNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

/**
 *  配置输入框的文字颜色和大小
 *
 *  @param textFiled 需要配置的输入框
 */

/**
 *  网络请求
 *
 *  @param parameters 网络请求的参数
 */
- (void)netWorking:(NSDictionary *)parameters{
    
    kWEAKSELF;
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_GET RequestURL:@"login" ParametersDictionary:parameters Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        
        adaLog(@"%@",responseObject);
        if(responseObject)
        {
            
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]] ;
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *data = responseObject[@"data"];
                [PZSaveDefaluts setObject:data forKey:@"userData"];
                kHCH.userInfoModel = [UserInfoModel mj_objectWithKeyValues:data];
                if (kHCH.userInfoModel.birthday && kHCH.userInfoModel.birthday.length > 2)
                {
                    [weakSelf succusedLogin];
                }
                else
                {
                    [weakSelf loadSuccessUI];
                }

            }else
            {
                [weakSelf.view makeToast:NSLocalizedString(@"登录失败", nil) duration:2 position:[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.height - 100)]];
            }
        }
        else
        {
            [weakSelf.view makeToast:[NSString stringWithFormat:@"%@",error] duration:2 position:[NSValue valueWithCGPoint:CGPointMake(weakSelf.view.center.x, self.view.height - 100)]];
        }
    }];
}

//判断是否是在白名单中
//登录成功后的操作
- (void)succusedLogin
{
    //1、如果成功，保存信息
    kHCH.userInfoModel.name = self.loginNameTF.text;
    [kHCH userInfoModelChanged];
    
    //2、修改登录状态
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];

    XXTabBarController *tabbar = [[XXTabBarController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CATransition *animation = [CATransition  animation ];
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.3;
    animation.type = kCATransitionPush;
    [window.layer addAnimation:animation forKey:nil];
    window.rootViewController = tabbar;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
