//
//  AlarmRepeatViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/15.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "AlarmRepeatViewController.h"

@interface AlarmRepeatViewController ()


@end

@implementation AlarmRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"重复",nil) backButton:YES shareButton:NO];
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitle:NSLocalizedString(@"储存",nil) forState:UIControlStateNormal];
    [sureButton sizeToFit];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    sureButton.frame = CGRectMake(ScreenW - sureButton.width - 20, 7 + StatusBarHeight, sureButton.width, 30);
    
    NSArray *weekArray = @[NSLocalizedString(@"周一",nil),
                       NSLocalizedString(@"周二",nil),
                       NSLocalizedString(@"周三",nil),
                       NSLocalizedString(@"周四",nil),
                       NSLocalizedString(@"周五",nil),
                       NSLocalizedString(@"周六",nil),
                       NSLocalizedString(@"周日",nil),];
    for (int i = 1; i < 8; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kmainLightColor;
        [self.view addSubview:view];
        view.sd_layout.topSpaceToView(self.view, 64 + 12 * kX + 54 * kX * i)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(52 * kX);
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kmaintextGrayColor;
        label.text = weekArray[i - 1];
        label.font = [UIFont systemFontOfSize:15];
        [label sizeToFit];
        [view addSubview:label];
        label.sd_layout.leftSpaceToView(view, 14 * kX)
        .centerYIs(view.height/2.)
        .widthIs(label.width)
        .heightIs(20);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setImage:[UIImage imageNamed:@"weekSelected"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"weekUnselected"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(weekSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.selected = self.repeat >> i & 1;
        [view addSubview:button];
        button.sd_layout.rightSpaceToView(view, 20 * kX)
        .centerYIs(view.height/2.)
        .widthIs(view.height)
        .heightIs(view.height);
    }
}

- (void)clickSure
{
    self.block(_repeat);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)weekSelected:(UIButton *)button
{
    button.selected = !button.selected;
    int selectedValue = 0x01 << button.tag;
    int newValue = _repeat ^ selectedValue;
    _repeat = newValue;
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
