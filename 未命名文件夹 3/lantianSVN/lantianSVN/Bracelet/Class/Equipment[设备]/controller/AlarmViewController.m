//
//  AlarmViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/19.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmCell.h"
#import "EditAlarmViewController.h"
#import "XXDeviceInfomation.h"
#import "AlarmModel.h"
#define kALARMVIEWCELL @"alarmViewCell"

@interface AlarmViewController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  表视图
 */
@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *alarmIDArray;

@end

@implementation AlarmViewController

#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 75 * kX - 64)];
        tableView.backgroundColor = kmainBackgroundColor;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.bounces = NO;
        
        
        //        设置代理
        tableView.delegate = self;
        tableView.dataSource = self;
        
        
        //        设置cell属性
        [tableView registerClass:[AlarmCell class] forCellReuseIdentifier:kALARMVIEWCELL];
        tableView.rowHeight = 130 * kX;
        [tableView setSeparatorColor:kRGBCOLOR(74, 116, 139, 1.0)];
        
        [self.view addSubview:tableView];
        
        _tableView = tableView;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = kmainLightColor;
        [button addTarget:self action:@selector(addAlarm) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.frame = CGRectMake(0, ScreenH - 75 * kX, ScreenW, 75 * kX);
        
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageButton setImage:[UIImage imageNamed:@"alarmADD"] forState:UIControlStateNormal];
        [button addSubview:imageButton];
        [imageButton addTarget:self action:@selector(addAlarm) forControlEvents:UIControlEventTouchUpInside];
        imageButton.sd_layout.centerXIs(self.view.width/2.)
        .centerYIs(button.height/2.)
        .widthIs(35)
        .heightIs(35);
        
        
    }
    return _tableView;
}

- (NSMutableArray *)alarmIDArray
{
    if (!_alarmIDArray)
    {
        _alarmIDArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 8; i ++)
        {
            [_alarmIDArray addObject:@"0"];
        }
    }
    return _alarmIDArray;
}

#pragma mark - viewDidLoad入口
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = kMainColor;
    [self addNavWithTitle:NSLocalizedString(@"闹钟",nil) backButton:YES shareButton:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.alarmArray removeAllObjects];
    self.alarmArray = nil;
    self.alarmIDArray = nil;
    [self initNavigation];
    [self loadUI];
    [self getBLEAlarmDataWithAlarmID:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigation
- (void)initNavigation
{
    
    //右边按钮
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    rightLabel.text = NSLocalizedString(@"确定", nil);
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGetsture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSure)];
    [rightLabel addGestureRecognizer:tapGetsture];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightLabel];
    
    //左边按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)getBLEAlarmDataWithAlarmID:(int)alarmID;
{
    kWEAKSELF
    [[PZBlueToothManager sharedInstance] getAlarmWithAlarmID:alarmID andAlarmModelBlock:^(AlarmModel *alarmModel) {
        if (alarmModel.state != 2 && alarmModel.repeats != 0)
        {
            if ([self.alarmIDArray[alarmModel.idNum] isEqualToString:@"0"]) {
                [weakSelf.alarmIDArray replaceObjectAtIndex:alarmModel.idNum withObject:@"1"];
                [weakSelf.alarmArray addObject:alarmModel];
                [weakSelf.tableView reloadData];
            }
        }
        if (alarmModel.idNum < 7)
        {
            [weakSelf getBLEAlarmDataWithAlarmID:alarmModel.idNum + 1];
        }
    }];
}

- (void)clickSure
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([XXDeviceInfomation deviceAlarmArray].count * 0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 布局
- (void)loadUI
{
    [self.tableView reloadData];
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alarmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:kALARMVIEWCELL forIndexPath:indexPath];
        
        //添加删除按钮
        [cell addActionButtonHandle:^(UIButton *button, AlarmCell *cell2) {
            
            //1.获取要删除的cell的indexPath
            NSIndexPath *idx = [tableView indexPathForCell:cell2];
            
            AlarmModel *model = self.alarmArray[idx.row];
            model.state = 2;
            [[PZBlueToothManager sharedInstance] setAlarmWithAlarmID:model.idNum State:model.state Hour:model.hour Minute:model.minute Repeat:model.repeats];
            [self.alarmArray removeObjectAtIndex:idx.row];
            [tableView deleteRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setSwithButtonHandle:^(UISwitch *sw, AlarmCell *cell3) {
            cell3.model.state = sw.isOn;
            [[PZBlueToothManager sharedInstance] setAlarmWithAlarmID:cell3.model.idNum State:cell3.model.state Hour:cell3.model.hour Minute:cell3.model.minute Repeat:cell3.model.repeats];
        }];

        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kmainBackgroundColor;
        cell.model = self.alarmArray[indexPath.row];
        return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//点击cell触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != self.alarmArray.count) {
        
        EditAlarmViewController *editVC = [[EditAlarmViewController alloc]init];
        editVC.alarmModel = self.alarmArray[indexPath.row];
        [self.navigationController pushViewController:editVC animated:YES];
    }
}


#pragma mark - action
/**
 *  点击添加按钮触发事件
 */
- (void)addAlarm
{
    AlarmModel *model = [AlarmModel new];
    model.state = 0;
    model.repeats = 0;
    model.hour = 0;
    model.minute = 0;
    model.idNum = -1;
    
    for (int i = 0 ; i < self.alarmIDArray.count; i ++)
    {
        NSString *idString = self.alarmIDArray[i];
        if ([idString isEqualToString:@"0"])
        {
            model.idNum = i;
            break;
        }
    }
    if (model.idNum >= 0)
    {
        EditAlarmViewController *editVC = [[EditAlarmViewController alloc]init];
        editVC.alarmModel = model;
        [self.vc.navigationController pushViewController:editVC animated:YES];
    }else{
        [self addActityTextInView:self.view text:NSLocalizedString(@"闹钟最多可设置8个",nil) deleyTime:2.f];
    }

    
    //  因为在点击添加按钮的时候，其他行的删除按钮可能还有显示，所以只能全部刷新。
    //    NSIndexPath *indx = [NSIndexPath indexPathForRow:self.alarmArray.count-1 inSection:0];
    //   [self.tableView insertRowsAtIndexPaths:@[indx] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - get方法

- (NSMutableArray *)alarmArray
{
    if (!_alarmArray)
    {
        _alarmArray = [[NSMutableArray alloc] init];
    }
    return _alarmArray;
}


@end
