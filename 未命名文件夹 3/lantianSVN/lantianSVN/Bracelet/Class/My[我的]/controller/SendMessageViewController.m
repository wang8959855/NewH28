//
//  SendMessageViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/24.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "SendMessageViewController.h"
#import "XXTextView.h"

@interface SendMessageViewController ()

@property (nonatomic, weak) XXTextView *textView;

@property (nonatomic, weak) UITextField *phoneNumberTF;

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"意见反馈",nil) backButton:YES shareButton:NO];
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = [UIColor lightGrayColor];
    topLabel.text = NSLocalizedString(@"您遇到的问题或建议",nil);
    topLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:topLabel];
    [topLabel sizeToFit];
    topLabel.sd_layout.topSpaceToView(self.view, 64 + 15 * kX)
    .leftSpaceToView(self.view, 23 * kX)
    .widthIs(topLabel.width)
    .heightIs(20);
    
    XXTextView *textView = [[XXTextView alloc] init];
    textView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    textView.font = [UIFont systemFontOfSize:16];
    textView.xx_placeholder = NSLocalizedString(@"请输入",nil);
    textView.xx_placeholderColor = [UIColor grayColor];
    [self.view addSubview:textView];
    textView.sd_layout.topSpaceToView(topLabel, 5)
    .leftSpaceToView(self.view, 23 * kX)
    .rightSpaceToView(self.view, 23 * kX)
    .heightIs(190 * kX);
    textView.layer.cornerRadius = 4;
    _textView = textView;
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.textColor = [UIColor lightGrayColor];
    bottomLabel.text = NSLocalizedString(@"您的联系方式",nil);
    bottomLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:bottomLabel];
    [bottomLabel sizeToFit];
    bottomLabel.sd_layout.topSpaceToView(_textView, 54 * kX)
    .leftSpaceToView(self.view, 23 * kX)
    .widthIs(bottomLabel.width)
    .heightIs(20);
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    textField.placeholder = NSLocalizedString(@"常用手机号码",nil);
    textField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:textField];
    textField.sd_layout.topSpaceToView(bottomLabel, 5)
    .leftSpaceToView(self.view, 23 * kX)
    .rightSpaceToView(self.view, 23*kX)
    .heightIs(30);
    textField.layer.cornerRadius = 4;
    _phoneNumberTF = textField;
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.backgroundColor = kmainBackgroundColor;
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitle:NSLocalizedString(@"提交",nil) forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    commitButton.sd_layout.bottomSpaceToView(self.view, 90 * kX)
    .centerXIs(self.view.width/2.)
    .widthIs(150 * kX)
    .heightIs(35);
    commitButton.layer.cornerRadius = 4;
    commitButton.clipsToBounds = YES;
}

- (void)commitClick
{

    NSDictionary *paramDic = @{@"deviceId":kHCH.mac,@"openid":kHCH.mac,@"content":_textView.text};
    NSDictionary *param = [kHCH changeToParamWithDic:paramDic];
    
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"suggest_submit.php" ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self addActityTextInView:self.view text:NSLocalizedString(@"感谢您的反馈",nil) deleyTime:2.f];
        if (responseObject)
        {
            adaLog(@"%@",responseObject[@"message"]);
        }
    }];
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
