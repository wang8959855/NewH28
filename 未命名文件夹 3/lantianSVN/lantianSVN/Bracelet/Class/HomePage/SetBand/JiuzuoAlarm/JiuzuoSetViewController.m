//
//  JiuzuoSetViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "JiuzuoSetViewController.h"

@interface JiuzuoSetViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JiuzuoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setXibLabels];
    
    _duration = 30;
    if (self.model)
    {
        [_beginTimeBtn setTitle:[NSString stringWithFormat:@"%02d:%02d",_model.beginHour,_model.beginMin] forState:UIControlStateNormal];
        [_beginTimeBtn setTitle:[NSString stringWithFormat:@"%02d:%02d",_model.beginHour,_model.beginMin] forState:UIControlStateNormal];
        [_beginTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_endTimeBtn setTitle:[NSString stringWithFormat:@"%02d:%02d",_model.endHour,_model.endMin] forState:UIControlStateNormal];
        [_endTimeBtn setTitle:[NSString stringWithFormat:@"%02d:%02d",_model.endHour,_model.endMin] forState:UIControlStateNormal];
        [_endTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _duration = self.model.timeInteval;
        
    }
    _durationLabel.text = [NSString stringWithFormat:@"%d%@",_duration,NSLocalizedString(@"分钟", nil)];
}

- (void)setXibLabels
{
    _titleLabel.text = NSLocalizedString(@"久坐提醒", nil);
    _kBeginTimeLabel.text = NSLocalizedString(@"开始久坐时间", nil);
    _kEndTimeLabel.text = NSLocalizedString(@"结束久坐时间", nil);
    _kTImeDurationLabel.text = NSLocalizedString(@"时间间隔提醒", nil);
    _durationLabel.text = @"";
    [_saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    _kTextTipLabel.text = NSLocalizedString(@"开启久坐提醒后，您的设备将增加一定的耗电量", nil);
}


#pragma mark -- ButtonAction

- (IBAction)TimeAction:(UIButton *)sender
{
    [self setPickerView];
    sender.selected = YES;
    _nowBtn = sender;
}

- (IBAction)durationBtnClick:(UIButton *)sender
{
    [self.view addSubview:self.tableViewBackView];
    _tableViewBackView.sd_layout.bottomSpaceToView(self.view,0)
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view);
    _tableViewBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}


- (IBAction)goBackButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveChangeAction:(UIButton *)sender
{
    if (_beginTimeBtn.titleLabel.text.length == 0)
    {
        [self addActityTextInView:self.view  text:NSLocalizedString(@"请选择开始时间", nil) deleyTime:1.5f];
        return;
    }
    else if (_endTimeBtn.titleLabel.text.length == 0)
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"请选择结束时间", nil) deleyTime:1.5];
        return;
    }else{
        NSArray *beginArray = [_beginTimeBtn.titleLabel.text componentsSeparatedByString:@":"];
        NSArray *endArray = [_endTimeBtn.titleLabel.text componentsSeparatedByString:@":"];
        int beginHour = [beginArray[0] intValue];
        int beginMin = [beginArray[1] intValue];
        int endHour = [endArray[0] intValue];
        int endMin = [endArray[1] intValue];
        if (endHour *60 + endMin < beginHour * 60 + beginMin)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"结束时间不能早于或等于开始时间", nil) deleyTime:1.5f];
            return;
        }
        else if (endHour *60 + endMin - beginHour * 60 - beginMin < _duration)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"久坐时间段长度短于久坐提醒时间间隔", nil) deleyTime:1.5f];
            return;
        }
        else
        {
            if ([EirogaBlueToothManager sharedInstance].isconnected)
            {
                int tag = -1;
                if (self.model)
                {
                    tag = self.model.repeats;
                }
                else
                {
                    for (int i = 0 ; i < _exitArray.count; i ++)
                    {
                        NSString *string = _exitArray[i];
                        if ([string isEqualToString:@""])
                        {
                            tag = i;
                        }
                    }
                }
                SedentaryModel *model = [[SedentaryModel alloc] init];
                model.repeats = tag;
                model.beginHour = beginHour;
                model.beginMin = beginMin;
                model.endHour = endHour;
                model.endMin = endMin;
                model.timeInteval = _duration;
                [[PZBlueToothManager sharedInstance] setSedentaryWithSedentaryModel:model];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)setPickerView
{
    _backView = [[UIView alloc] initWithFrame:CurrentDeviceBounds];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    
    _animationView  = [[UIView alloc] initWithFrame:CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246)];
    [_backView addSubview:_animationView];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30,CurrentDeviceWidth, 216)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_animationView addSubview:_datePicker];
    
    
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [_animationView addSubview:buttonView];
    buttonView.sd_layout.leftEqualToView(_backView)
    .rightEqualToView(_backView)
    .heightIs(30)
    .bottomSpaceToView(_datePicker,0);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonView addSubview:button];
    button.frame = CGRectMake(CurrentDeviceWidth-80, 0, 80, 40);
    [button addTarget:self action:@selector(dateSureClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btnImageView.image = [UIImage imageNamed:@"hook"];
    btnImageView.center = button.center;
    [buttonView addSubview:btnImageView];
    
    [UIView animateWithDuration:0.23 animations:^{
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight-246,CurrentDeviceWidth, 246);
    }];
}

- (void)dateSureClick
{
    
    
    
    
    
    NSDate *pickDate = _datePicker.date;
    NSDateFormatter *formates = [[NSDateFormatter alloc]init];
    [formates setDateFormat:@"HH:mm"];
    NSString *dayString = [formates stringFromDate:pickDate];
    [_nowBtn setTitle:dayString forState:UIControlStateNormal];
    [_nowBtn setTitle:dayString forState:UIControlStateSelected];
    [_nowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self hiddenDateBackView];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d %@",[_dataArray[indexPath.row] intValue], NSLocalizedString(@"分钟", nil)] ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableViewBackView)
    {
        [_tableViewBackView removeFromSuperview];
        self.tableViewBackView = nil;
        self.durationTableView = nil;
    }
    _duration = 30 + 30 * (int)indexPath.row;
    _durationLabel.text = [NSString stringWithFormat:@"%d%@",_duration,NSLocalizedString(@"分钟", nil)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenDateBackView];
    if (_tableViewBackView)
    {
        [_tableViewBackView removeFromSuperview];
        self.tableViewBackView = nil;
        self.durationTableView = nil;
    }
}

- (void)hiddenDateBackView
{
    _nowBtn.selected = NO;
    self.nowBtn = nil;
    [UIView animateWithDuration:0.23 animations:^{
        _animationView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, 246);
    } completion:^(BOOL finished) {
        
        [_backView removeFromSuperview];
        _backView = nil;
        [_datePicker removeFromSuperview];
        _datePicker = nil;
    }];
    
}

-(UIView *)tableViewBackView
{
    if (!_tableViewBackView)
    {
        _tableViewBackView = [[UIView alloc] init];
        _durationTableView = [[UITableView alloc] init];
        _durationTableView.delegate = self;
        _durationTableView.dataSource = self;
        [_tableViewBackView addSubview:_durationTableView];
        _durationTableView.sd_layout.centerXIs(self.view.centerX)
        .centerYIs(self.view.centerY)
        .widthIs(200)
        .heightIs(176);
    }
    return _tableViewBackView;
}

-(NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[@30,@60,@90,@120];
    }
    return _dataArray;
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
