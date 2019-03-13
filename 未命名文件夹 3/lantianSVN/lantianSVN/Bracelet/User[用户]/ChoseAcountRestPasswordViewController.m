//
//  ChoseAcountRestPasswordViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/8.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "ChoseAcountRestPasswordViewController.h"
#import "EmailResetPasswordViewController.h"
#import "PhoneResetPasswordViewController.h"

@interface ChoseAcountRestPasswordViewController ()


@end

@implementation ChoseAcountRestPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KCOLOR(42, 167, 155);
    [self loadUI];

}

- (void)loadUI
{
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
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    emailButton.backgroundColor = KCOLOR(35, 145, 136);
    [emailButton setTitle:NSLocalizedString(@"邮箱找回",nil) forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(emailClick) forControlEvents:UIControlEventTouchUpInside];
    emailButton.frame = [self setCGRectWithX:35 Y:153 Width:375-70 Heigth:46];
    emailButton.layer.cornerRadius = 5;
    [self.view addSubview:emailButton];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneButton.backgroundColor = KCOLOR(35, 145, 136);
    [phoneButton setTitle:NSLocalizedString(@"手机号找回",nil) forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    phoneButton.frame = [self setCGRectWithX:35 Y:250 Width:375-70 Heigth:46];
    phoneButton.layer.cornerRadius = 5;
    [self.view addSubview:phoneButton];
}

- (void)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)emailClick
{
    EmailResetPasswordViewController *emailRestVC = [EmailResetPasswordViewController new];
    [self.navigationController pushViewController:emailRestVC animated:YES];
}

- (void)phoneClick
{
    PhoneResetPasswordViewController *phoneResetVC = [PhoneResetPasswordViewController new];
    [self.navigationController pushViewController:phoneResetVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
