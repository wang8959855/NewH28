//
//  YHEditEquipmentViewController.m
//  Bracelet
//
//  Created by xieyingze on 17/1/3.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#import "YHEditEquipmentViewController.h"
#import "YHEditCell.h"
#import "YHEditModel.h"
#import "CallViewController.h"
#import "AlarmViewController.h"
#import "EquipmentViewController.h"
#import "SittingViewController.h"
#import "PZMusicStateSetViewController.h"
#import "TakePhotoViewController.h"
#import "YHAppRemidViewController.h"
#import "SMSViewController.h"
#import "DisturbViewController.h"
#import "FindBindViewController.h"
#import "TaiwanViewController.h"
#import "HeartRateSetViewController.h"

@interface YHEditEquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSArray *imageArr;
@property(nonatomic,strong) NSArray *titleArr;
//@property(nonatomic,strong)NSArray *isOn;

@property(nonatomic)BOOL isPlayMusic;
@property(nonatomic)BOOL isPause;
@end

@implementation YHEditEquipmentViewController
/**
 *  背景图片视图
 *
 *  @return 懒加载完成之后的背景图片视图
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addnavTittle:nil RSSIImageView:YES shareButton:YES];
    [self addNavWithTitle:@"设置" backButton:YES shareButton:YES];
    self.view.backgroundColor = kMainColor;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH-110)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    [self.tableView registerClass:[YHEditCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.imageArr = @[@[@"mainPhone",@"mainSMS",],
                    @[@"mainAlarm",@"mainAPPAlarm"],
                    @[@"mainSleep",@"mainMusic"],
                    @[@"mainFindBind",@"mainJIuzuo"],
                    @[@"maintaiwan",@"equipmentHR"]
                   ];
    self.titleArr = @[@[NSLocalizedString(@"来电提醒",nil),NSLocalizedString(@"短信提醒",nil)],
                      @[NSLocalizedString(@"闹钟提醒",nil),NSLocalizedString(@"APP提醒",nil)],
                      @[NSLocalizedString(@"勿扰模式",nil),NSLocalizedString(@"音乐控制",nil)],
                      @[NSLocalizedString(@"寻找手环",nil),NSLocalizedString(@"久坐提醒",nil)],
                      @[NSLocalizedString(@"抬腕亮屏",nil),NSLocalizedString(@"自动检测心率",nil)]
                     ];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenH - 64 - self.tabBarController.tabBar.height)/4.;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    YHEditModel *model = [[YHEditModel alloc]init];
    [model.ImageArr addObject: self.imageArr[indexPath.row]];
    [model.titleArr addObject: self.titleArr[indexPath.row]];
    [cell setModel:model];
    
    cell.View1.tag = 100+indexPath.row;
    cell.View2.tag = 200 +indexPath.row;
    [cell.View1 addTarget:self action:@selector(gotoVC:) forControlEvents:UIControlEventTouchUpInside];
    [cell.View2 addTarget:self action:@selector(gotoVC:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)gotoVC:(UIButton*)sender
{
    if (sender.tag == 100) {
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        
        CallViewController *vc = [[CallViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 101)
    {
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        AlarmViewController *vc = [[AlarmViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
      
    }else if (sender.tag == 102){

        DisturbViewController *vc = [[DisturbViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 103){
        
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        FindBindViewController *vc = [[FindBindViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 104)
    {
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        TaiwanViewController *vc = [[TaiwanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 200){
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        SMSViewController *smsVC = [[SMSViewController alloc] init];
        [self.navigationController pushViewController:smsVC animated:YES];
    }else if (sender.tag == 201){
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        YHAppRemidViewController *vc = [[YHAppRemidViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (sender.tag == 202){
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }

        PZMusicStateSetViewController *vc = [[PZMusicStateSetViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 203){
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        SittingViewController *vc = [[SittingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }else if (sender.tag == 204){
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        HeartRateSetViewController *vc = [[HeartRateSetViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)addEquipment
{
    EquipmentViewController *vc = [[EquipmentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma =====================音乐播放=====================================
@end
