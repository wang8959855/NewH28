//
//  EditPhoneViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/20.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "EditPhoneViewController.h"

@interface EditPhoneViewController ()

@property (nonatomic, strong) UITextField *numberTF;

@end

@implementation EditPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"编辑联系人",nil) backButton:YES shareButton:NO];
    
    NSArray *titleArray = @[NSLocalizedString(@"标签",nil),NSLocalizedString(@"号码",nil)];
    for (int i = 0; i < 2; i ++)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = kmainBackgroundColor;
        [self.view addSubview:backView];
        backView.sd_layout.topSpaceToView(self.view, 132 * kX + i * 88 * kX)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(54 * kX);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kmaintextGrayColor;
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        [backView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(backView, 12 * kX)
        .centerYIs(backView.height/2.)
        .widthIs(titleLabel.width)
        .heightIs(backView.height);
        
        if (i == 0)
        {
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.textColor = [UIColor whiteColor];
            tipLabel.text = _labelString;
            tipLabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:tipLabel];
            tipLabel.sd_layout.centerYIs(backView.height/2.)
            .leftEqualToView(backView)
            .rightEqualToView(backView)
            .heightIs(backView.height);
        }else{
            _numberTF = [[UITextField alloc] init];
            _numberTF.keyboardType = UIKeyboardTypePhonePad;
            _numberTF.borderStyle = UITextBorderStyleNone;
            _numberTF.textColor = [UIColor whiteColor];
            _numberTF.textAlignment = NSTextAlignmentCenter;
            _numberTF.text = _numberString;
            _numberTF.placeholder = NSLocalizedString(@"请输入电话号码",nil);
            [_numberTF setValue:kmaintextGrayColor forKeyPath:@"_placeholderLabel.textColor"];
            [backView addSubview:_numberTF];
            _numberTF.sd_layout.centerYIs(backView.height/2.)
            .leftSpaceToView(titleLabel, 3)
            .rightEqualToView(backView)
            .heightIs(40);
        }
    }
    
}

- (void)backBarButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.block)
    {
        self.block(_numberTF.text);
    }
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
