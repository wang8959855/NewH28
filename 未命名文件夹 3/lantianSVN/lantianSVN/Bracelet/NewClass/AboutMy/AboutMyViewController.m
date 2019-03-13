//
//  AboutMyViewController.m
//  Bracelet
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "AboutMyViewController.h"
#import "BaseWebViewController.h"

@interface AboutMyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *version;

@property (weak, nonatomic) IBOutlet UILabel *corn;


@end

@implementation AboutMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavWithTitle:@"关于我们" backButton:YES shareButton:NO];
    self.version.text = appVersion;
    [self getAppStoreVersion];
}

//帮助
- (IBAction)helpAction:(UIButton *)sender {
    BaseWebViewController *web = [[BaseWebViewController alloc] init];
    web.hidesBottomBarWhenPushed = YES;
    web.urlStr = @"https://rulong.lantianfangzhou.com//wechat2/assistance.html";
    web.titleStr = @"帮助";
    [self.navigationController pushViewController:web animated:YES];
}

//检查软件
- (IBAction)checkRuanjian:(UIButton *)sender {
    if (!self.corn.isHidden) {
        //跳转到appstore
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/1319730997?mt=8"]];
    }else{
        [self showAlertView:@"已是最新版本!"];
    }
}

//公司简介
- (IBAction)jjAction:(UIButton *)sender {
    BaseWebViewController *web = [[BaseWebViewController alloc] init];
    web.hidesBottomBarWhenPushed = YES;
    web.urlStr = @"https://www.lantianfangzhou.com/app/h28/aboutUs/index.html";
    web.titleStr = @"公司简介";
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取appStore版本
- (void)getAppStoreVersion{
    NSString *urlStr = @"http://itunes.apple.com/lookup?id=1319730997";
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:urlStr ParametersDictionary:nil Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        NSString * version      = responseObject[@"results"][0][@"version"];//线上最新版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion       = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//当前用户版本
        BOOL result = [currentVersion compare:version] == NSOrderedAscending;
        if (result) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"updeateVersion"];
            self.corn.hidden = NO;
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"updeateVersion"];
            self.corn.hidden = YES;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVersion" object:nil];
    }];
}

@end
