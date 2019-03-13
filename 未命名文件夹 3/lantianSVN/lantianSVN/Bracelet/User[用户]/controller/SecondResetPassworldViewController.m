//
//  SecondxiaozhaResetPassworldViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/8.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "SecondResetPassworldViewController.h"
#import "LoginViewController.h"

@interface SecondResetPassworldViewController ()

@property (nonatomic, weak) UIView *backgroundView;

@property (nonatomic, weak) UITextField *codeTF;

@property (nonatomic, weak) UITextField *firstPSWTF;

@property (nonatomic, weak) UITextField *secondPSWTF;

@end

@implementation SecondResetPassworldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KCOLOR(42, 167, 155);
    [self loadUI];
}

- (void)loadUI
{
    [self backgroundView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"找回密码",nil);
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
    
    UIButton *RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [RegisterBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegisterBtn.backgroundColor = KCOLOR(35, 145, 136);
    RegisterBtn.layer.cornerRadius = 5;
    RegisterBtn.layer.masksToBounds = YES;
    RegisterBtn.frame = [self setCGRectWithX:35 Y:463 Width:375-70 Heigth:46];
    [self.view addSubview: RegisterBtn];
    [RegisterBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    
    [self codeTF];
    [self firstPSWTF];
    [self secondPSWTF];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self cancelFiled];
}

- (void)cancelFiled
{
    [self.view endEditing:YES];
}

- (void)clickSure
{
    //1、退出键盘
    [self cancelFiled];
    //2、判断输入框
    if (_codeTF.text.length == 0)
    {
        [self.view makeToast:NSLocalizedString(@"请输入验证码", nil) duration:1 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    
    if (self.firstPSWTF.text.length < 6 || self.firstPSWTF.text.length > 20 || self.firstPSWTF.text.length < 6 || self.firstPSWTF.text.length > 20) {
        [self.view makeToast:NSLocalizedString(@"密码长度为6～20，请核对", nil) duration:1 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }

    //4 、判断两次密码是否一致
    if (![self judgePassword]) {
        return;
    }
    [self.activityView startAnimating];
    NSDictionary *param = @{@"name":self.nameString,
                            @"code": self.codeTF.text,
                            @"pwd":[UnityTool md5ForString:self.firstPSWTF.text]};
    NSString *url = @"alter";
    if ([Common validateEmail:self.nameString])
    {
        url = @"mail/post";
    }
    
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_GET RequestURL:url ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self.activityView stopAnimating];
        adaLog(@"%@",responseObject);
        if (responseObject)
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"密码重置成功,请重新登录",nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }else
            {
                [self.view makeToast:NSLocalizedString(@"修改失败",nil) duration:2.5f position:[NSValue valueWithCGPoint:self.view.center]];
            }
        }else
        {
            [self.view makeToast:NSLocalizedString(@"修改失败",nil) duration:2.5f position:[NSValue valueWithCGPoint:self.view.center]];
        }
    }];
}
    


- (BOOL)judgePassword
{
    NSString *firstString = self.firstPSWTF.text;
    NSString *secondString = self.secondPSWTF.text;
    
    if (![firstString isEqualToString:@""] && ![secondString isEqualToString:@""] && ![firstString isEqualToString: secondString]) {
        
        [self.view makeToast:NSLocalizedString(@"两次密码输入不一致", nil) duration:1 position:[NSValue valueWithCGPoint:self.view.center]];
        return NO;
        
    }
    return YES;
}
#pragma mark -- GET方法

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = KCOLOR(35, 145, 136);
        backView.frame = [self setCGRectWithX:35 Y:151 Width:375 - 70 Heigth:257];
        _backgroundView = backView;
        _backgroundView.layer.cornerRadius = 5;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;

}

- (UITextField *)codeTF
{
    if (!_codeTF)
    {
        UITextField *nameTextField = [[UITextField alloc] init];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.frame = [self setCGRectWithX:25 Y:20 Width:252 Heigth:40];
        nameTextField.textAlignment = NSTextAlignmentCenter;
        nameTextField.textColor = [UIColor whiteColor];
        _codeTF = nameTextField;
        [self.backgroundView addSubview:_codeTF];
        _codeTF.placeholder = NSLocalizedString(@"验证码", nil);
        
        [self configTextField:_codeTF];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroundView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(nameTextField, 0)
        .leftEqualToView(nameTextField)
        .rightEqualToView(nameTextField)
        .heightIs(1);
    }
    return _codeTF;
}

- (UITextField *)firstPSWTF
{
    if(!_firstPSWTF)
    {
        UITextField *passTF = [[UITextField alloc] init];
        passTF.borderStyle = UITextBorderStyleNone;
        passTF.frame = [self setCGRectWithX:25 Y:80 Width:252 Heigth:40];
        passTF.textAlignment = NSTextAlignmentCenter;
        passTF.textColor = [UIColor whiteColor];
        passTF.placeholder = NSLocalizedString(@"请输入密码",nil);
        passTF.secureTextEntry = YES;
        [self configTextField:passTF];
        _firstPSWTF = passTF;
        [self.backgroundView addSubview:_firstPSWTF];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroundView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(passTF, 0)
        .leftEqualToView(passTF)
        .rightEqualToView(passTF)
        .heightIs(1);
        
    }
    return _firstPSWTF;
}

- (UITextField *)secondPSWTF
{
    if(!_secondPSWTF)
    {
        UITextField *passTF = [[UITextField alloc] init];
        passTF.borderStyle = UITextBorderStyleNone;
        passTF.frame = [self setCGRectWithX:25 Y:140 Width:252 Heigth:40];
        passTF.textAlignment = NSTextAlignmentCenter;
        passTF.textColor = [UIColor whiteColor];
        passTF.placeholder = NSLocalizedString(@"请再次输入密码",nil);
        passTF.secureTextEntry = YES;
        [self configTextField:passTF];
        _secondPSWTF = passTF;
        [self.backgroundView addSubview:_secondPSWTF];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = KCOLOR(122, 175, 166);
        [self.backgroundView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(passTF, 0)
        .leftEqualToView(passTF)
        .rightEqualToView(passTF)
        .heightIs(1);
        
    }
    return _secondPSWTF;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
