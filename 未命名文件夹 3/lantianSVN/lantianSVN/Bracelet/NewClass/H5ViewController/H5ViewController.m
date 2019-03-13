//
//  H5ViewController.m
//  Wukong
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "H5ViewController.h"

@interface H5ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation H5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *back = [self.view viewWithTag:10000];
    [back addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
    [self addNavWithTitle:titleStr backButton:YES shareButton:NO];
    [self performSelector:@selector(setTitStr:) withObject:titleStr afterDelay:0.1];
}

- (void)setTitStr:(NSString *)titleStr{
    self.titleLabel.text = self.titleStr;
    [self addNavWithTitle:titleStr backButton:YES shareButton:NO];
    NSURL *url1 = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回
- (void)goBackAction:(UIButton *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
