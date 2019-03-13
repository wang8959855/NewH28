//
//  ResetPasswordViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "EmailResetPasswordViewController.h"
#import "UIView+ViewFrameExt.h"
#import "XXUserInformation.h"
#import "LoginViewController.h"
#import "SecondResetPassworldViewController.h"

@interface EmailResetPasswordViewController ()<UITextFieldDelegate>
{

}


/**
 *  背景视图
 */
@property (weak, nonatomic)  UIView *backgroudView;


@property (weak, nonatomic)  UITextField *emailTF;

/**
 *  下一步按钮
 */
@property (weak, nonatomic)  UIButton *nextBtn;

@end

@implementation EmailResetPasswordViewController


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
 *  @param sender <#sender description#>
 */
- (void)back:(id)sender {
    [self cancelFiled];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  下一步
 *
 *  @param sender <#sender description#>
 */
- (void)next:(id)sender {
    [self cancelFiled];

    if(![Common validateEmail:self.emailTF.text])
    {
        [self.view makeToast:NSLocalizedString(@"请输入正确的邮箱账号", nil) duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
        return;
    }
    kWEAKSELF;
    NSDictionary *param = @{@"name":_emailTF.text};
    [self.activityView startAnimating];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_GET RequestURL:@"mail/update" ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        adaLog(@"%@",responseObject);
        [weakSelf.activityView stopAnimating];
        if (responseObject)
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]] ;
            if ([code isEqualToString:@"0"])
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"验证码已发送至您的手机,请注意查收",nil) preferredStyle:UIAlertControllerStyleAlert];
                
                kWEAKSELF;
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SecondResetPassworldViewController *secondVC = [SecondResetPassworldViewController new];
                    secondVC.nameString =weakSelf.emailTF.text;
                    [weakSelf.navigationController pushViewController:secondVC animated:YES];
                }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self.view makeToast:@"发送失败" duration:2. position:[NSValue valueWithCGPoint:self.view.center]];
            }
        }else
        {
            [self.view makeToast:@"发送失败" duration:2. position:[NSValue valueWithCGPoint:self.view.center]];
        }
    }];
}



#pragma mark - 界面布局
/**
 *  初始化界面
 */
- (void)loadUI
{
    [self backgroudView];
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
    
    [self emailTF];
    [self nextBtn];
}
/**
 *  成功重置的界面
 */
#pragma mark - private

/**
 *  取消输入框的第一响应，收回键盘
 */
- (void)cancelFiled
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -- UIAlertViewDelegate


#pragma mark -- GET方法
- (UIView *)backgroudView
{
    if (!_backgroudView)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = KCOLOR(35, 145, 136);
        backView.frame = [self setCGRectWithX:35 Y:151 Width:375 - 70 Heigth:138];
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
        nameTextField.frame = [self setCGRectWithX:25 Y:45 Width:252 Heigth:40];
        nameTextField.textAlignment = NSTextAlignmentCenter;
        nameTextField.textColor = [UIColor whiteColor];
        _emailTF = nameTextField;
        [self.backgroudView addSubview:_emailTF];
        _emailTF.delegate = self;
        _emailTF.placeholder = NSLocalizedString(@"邮箱", nil);
        
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

- (UIButton *)nextBtn
{
    if (!_nextBtn)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = KCOLOR(35, 145, 136);
        [button setTitle:NSLocalizedString(@"下一步",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = [self setCGRectWithX:35 Y:463 Width:375-70 Heigth:46];
        button.layer.cornerRadius = 5;
        _nextBtn = button;
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
}

@end
