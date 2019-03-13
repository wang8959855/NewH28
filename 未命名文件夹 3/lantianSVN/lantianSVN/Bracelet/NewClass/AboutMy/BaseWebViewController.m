//
//  BaseWebViewController.m
//  Bracelet
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addNavWithTitle:self.titleStr backButton:YES shareButton:NO];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
