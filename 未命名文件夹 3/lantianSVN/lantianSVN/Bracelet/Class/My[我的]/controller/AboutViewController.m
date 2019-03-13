//
//  AboutViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/4/21.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
    // Do any additional setup after loading the view.
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"关于", nil) backButton:YES shareButton:NO];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH)];
    [self.view addSubview:webView];
    NSString *urlString = @"http://www.lantianfangzhou.com/";
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
//
//    UIImageView *icon = [[UIImageView alloc] init];
//    [self.view addSubview:icon];
//    icon.image = [UIImage imageNamed:@"about_icon"];
//    icon.sd_layout.centerXIs(self.view.centerX)
//    .topSpaceToView(self.view, 40 + 64)
//    .widthIs(80)
//    .heightIs(80);
//
//    UILabel *nameLable = [[UILabel alloc] init];
//    [self.view addSubview:nameLable];
//    nameLable.text = @"LingYue";
//    nameLable.textColor = [UIColor grayColor];
//    [nameLable sizeToFit];
//    nameLable.sd_layout.topSpaceToView(icon, 20)
//    .centerXIs(self.view.centerX)
//    .widthIs(nameLable.width)
//    .heightIs(25);
//
//    UILabel *versionLabel = [[UILabel alloc] init];
//    versionLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"软件版本", nil),[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//    versionLabel.textColor = [UIColor grayColor];
//    versionLabel.font = [UIFont systemFontOfSize:15];
//    [versionLabel sizeToFit];
//    [self.view addSubview:versionLabel];
//    versionLabel.sd_layout.topSpaceToView(nameLable, 20)
//    .centerXIs(self.view.centerX)
//    .widthIs(versionLabel.width)
//    .heightIs(25);
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
