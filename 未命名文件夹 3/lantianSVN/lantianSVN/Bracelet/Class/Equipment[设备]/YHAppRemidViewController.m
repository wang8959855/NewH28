//
//  YHAppRemidViewController.m
//  Bracelet
//
//  Created by xieyingze on 17/1/11.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#import "YHAppRemidViewController.h"
#import "XXDeviceInfomation.h"
#import "NotifyModel.h"

@interface YHAppRemidViewController ()

@property (nonatomic, strong) NotifyModel *model;

@end

@implementation YHAppRemidViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    kWEAKSELF;
    [self loadUI];
    self.view.backgroundColor = kMainColor;
    [[PZBlueToothManager sharedInstance] getNotifyWithBlock:^(NotifyModel *notifyModel) {
        weakSelf.model = notifyModel;
    }];
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"APP提醒",nil) backButton:YES shareButton:NO];
    NSArray * array = @[NSLocalizedString(@"邮箱",nil),@"tx_email",
                        NSLocalizedString(@"QQ",nil),@"tx_qq",
                        NSLocalizedString(@"微信",nil),@"tx_wechat",
                        NSLocalizedString(@"facebook",nil),@"tx_facebook",
                        NSLocalizedString(@"twitter",nil),@"tx_twitter",
                        NSLocalizedString(@"WhatsAPP", nil),@"tx_whatsapp"];
    for (int i = 0; i < 6; i ++)
    {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        backView.sd_layout.topSpaceToView(self.view, SafeAreaTopHeight + 55 * kX * i)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(55 * kX);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:array[i * 2 + 1]];
        [backView addSubview:imageView];
        imageView.sd_layout.leftSpaceToView(backView, StatusBarHeight * kX)
        .centerYIs(backView.height/2.)
        .widthIs(30)
        .heightIs(30);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = array[i * 2];
        label.textColor = kmainBackgroundColor;
        [label sizeToFit];
        [backView addSubview:label];
        label.sd_layout.leftSpaceToView(imageView, StatusBarHeight)
        .centerYIs(backView.height/2.)
        .widthIs(label.width)
        .heightIs(30);
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"APPUnselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"APPSelected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.tag = 100 + i;
        button.sd_layout.topSpaceToView(self.view, SafeAreaTopHeight + 55 * kX * i)
        .rightSpaceToView(self.view, 22 * kX)
        .widthIs(55 * kX)
        .heightIs(55 * kX);
    }
}

- (void)setModel:(NotifyModel *)model
{
    _model = model;
    for (UIButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            switch (button.tag)
            {
                case 100:
                    button.selected = model.EmailState;
                    break;
                case 101:
                    button.selected = model.QQState;
                    break;
                case 102:
                    button.selected = model.WechartState;
                    break;
                case 103:
                    button.selected = model.FacebookState;
                    break;
                case 104:
                    button.selected = model.TwitterState;
                    break;
                case 105:
                    button.selected = model.WhatsAppState;
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - action

- (void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    switch (button.tag)
    {
        case 100:
            self.model.EmailState = button.selected;
            break;
        case 101:
            self.model.QQState = button.selected;

            break;
        case 102:
            self.model.WechartState = button.selected;

            break;
        case 103:
            self.model.FacebookState = button.selected;

            break;
        case 104:
            self.model.TwitterState = button.selected;
            break;
        case 105:
            self.model.WhatsAppState = button.selected;
            break;
        default:
            break;
    }
    self.model.notifyState = YES;
    [[PZBlueToothManager sharedInstance] setNotifyWithNotifyModel:self.model];

}

- (void)selectDateButton:(UIButton *)button
{
    button.selected = !button.selected;

    switch (button.tag) {
        case 1:
            self.model.SMSState = button.selected;
            break;
        case 2:
            self.model.CallState = button.selected;
            break;
        case 3:
            self.model.EmailState = button.selected;
            break;
        case 4:
            self.model.WechartState = button.selected;
            break;
        case 5:
            self.model.QQState = button.selected;
            break;
        case 6:
            self.model.FacebookState = button.selected;
            break;
        case 7:
            self.model.TwitterState = button.selected;
            break;
 
        default:
            break;
    }

}
@end
