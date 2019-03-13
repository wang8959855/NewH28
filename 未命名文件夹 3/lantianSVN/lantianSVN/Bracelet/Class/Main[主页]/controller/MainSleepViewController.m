//
//  MainSleepViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/11.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "MainSleepViewController.h"
#import "SleepCircleView.h"
#import "historyDataModel.h"
#import "XXPickerView.h"
#import "MainSleepDetailViewController.h"

@interface MainSleepViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, weak) SleepCircleView *sleepCircle;

@property (nonatomic, weak) oneDaySleepModel *sleepModel;

@property (nonatomic, weak) UILabel *totalSleepLabel;

@property (nonatomic, strong) UILabel *deepSleepLabel;

@property (nonatomic, strong) UILabel *lightSleepLabel;

@property (nonatomic, strong) UILabel *awakeLabel;

@property (nonatomic, weak) UIView *backView;

@property (nonatomic, weak) XXPickerView *pickerView;
@property (nonatomic, weak) UIView *clearBackView;

@end

@implementation MainSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HistoryDataModel *model = [[HistoryDataModel alloc] init];

    [self loadUI];
    
    kWEAKSELF;
    [model getOneDaySleepWithTimeSeconds:kHCH.todayTimeSeconds Completion:^(oneDaySleepModel *model) {
        if (model)
        {
            weakSelf.sleepCircle.model = model;
            weakSelf.sleepModel = model;
        }
    }];
}

- (void)dealloc
{
    adaLog(@"sleep delooc");
}

- (void)loadUI {
    [self addnavTittle:NSLocalizedString(@"睡眠",nil) RSSIImageView:YES shareButton:YES];
    [self sleepCircle];
    [self backView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, ScreenW, 20)];
    label1.text = @"正常人的睡眠时长为7-8小时";
    label1.font = [UIFont systemFontOfSize:15];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = kMainColor;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 94, ScreenW, 20)];
    label2.text = @"其中深睡时长应达到总睡眠时长的25%";
    label2.font = [UIFont systemFontOfSize:15];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = kMainColor;
    [self.view addSubview:label2];
    
    UIImageView *sleepImageView = [[UIImageView alloc] init];
    sleepImageView.contentMode = UIViewContentModeScaleAspectFit;
    sleepImageView.image = [UIImage imageNamed:@"sleepdetail"];
    [self.sleepCircle addSubview:sleepImageView];
    sleepImageView.sd_layout.topSpaceToView(self.sleepCircle, 70 * kX)
    .centerXIs(self.sleepCircle.width/2.)
    .widthIs(40 * kX)
    .heightIs(40 * kX);
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = @"0h0min";
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = [UIFont systemFontOfSize:25];
    [self.sleepCircle addSubview:totalLabel];
    totalLabel.sd_layout.topSpaceToView(sleepImageView, 15 * kX)
    .centerXIs(self.sleepCircle.width/2.)
    .widthIs(self.sleepCircle.width)
    .heightIs(30 * kX);
    _totalSleepLabel = totalLabel;
    
    //    设置目标按钮
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(130*kX, 35*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.sleepCircle.bottom + 55 * kX);
    [self.view addSubview:self.targetBtn];
    self.targetBtn.layer.borderColor = kMainColor.CGColor;
    self.targetBtn.layer.borderWidth = 1;
    self.targetBtn.layer.cornerRadius = 8*kDY;
    [self.targetBtn setImage:[UIImage imageNamed:@"target1"] forState:UIControlStateNormal];
    [self.targetBtn setTitle:[NSString stringWithFormat:@"%@h%@min",[XXUserInformation userSleepHourTarget], [XXUserInformation userSleepMinuteTarget]] forState:UIControlStateNormal];
    [self.targetBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    /*NSArray *imageArray = @[@"deepSleep",@"lightSleep",@"awake"];
    NSArray *titleArray = @[NSLocalizedString(@"深睡",nil),NSLocalizedString(@"浅睡",nil),NSLocalizedString(@"清醒",nil)];
    
    for (int i = 0; i <3; i ++)
    {
        UIImageView *sleepStateImageView = [[UIImageView alloc] init];
        sleepStateImageView.contentMode = UIViewContentModeScaleAspectFit;
        sleepStateImageView.image = [UIImage imageNamed:imageArray[i]];
        [self.view addSubview:sleepStateImageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = titleArray[i];
        [label sizeToFit];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kMainColor;
        label.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:label];
        
        if (i == 0)
        {
            sleepStateImageView.frame = CGRectMake(65 * kX, self.sleepCircle.bottom + 28 * kX, 30 * kX, 30 * kX);

            label.sd_layout.topSpaceToView(sleepStateImageView, 8 * kX)
            .centerXIs(sleepStateImageView.centerX)
            .widthIs(label.width)
            .heightIs(20);
        }else if (i == 1)
        {
            sleepStateImageView.sd_layout.topSpaceToView(self.sleepCircle, 28 * kX)
            .centerXIs(ScreenW / 2.)
            .widthIs(30 * kX)
            .heightIs(30 * kX);
            
            label.sd_layout.topSpaceToView(sleepStateImageView, 8 * kX)
            .centerXIs(ScreenW/2.)
            .widthIs(label.width)
            .heightIs(20);
        }else if (i == 2)
        {
            sleepStateImageView.frame = CGRectMake(ScreenW - 30 * kX - 65 * kX, self.sleepCircle.bottom + 28 * kX, 30 * kX, 30 * kX);
            
            label.sd_layout.topSpaceToView(sleepStateImageView, 8 * kX)
            .centerXIs(sleepStateImageView.centerX)
            .widthIs(label.width)
            .heightIs(20);
        }
    }
     */
}

- (void)targetBtnAction:(UIButton *)button{
    
    UIView  *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    backView.frame = CGRectMake(0, self.view.height, self.view.width, self.view.height);
    
    XXPickerView *picker = [[XXPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    [picker setBackgroundColor:kmainBackgroundColor];
    [picker setupCenterViewColor:kmainBackgroundColor];
    [backView addSubview:picker];
    picker.sd_layout.bottomEqualToView(backView)
    .leftEqualToView(backView)
    .rightEqualToView(backView)
    .heightIs(254 * kX);
    _pickerView = picker;
    int hour = [[XXUserInformation userSleepHourTarget] intValue];
    int min = [[XXUserInformation userSleepMinuteTarget] intValue];
    [picker.mPickerView selectRow:hour inComponent:0 animated:NO];
    [picker.mPickerView selectRow:min inComponent:2 animated:NO];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = kmainDarkColor;
    [backView addSubview:topView];
    topView.sd_layout.leftEqualToView(backView)
    .rightEqualToView(backView)
    .bottomSpaceToView(picker, 0)
    .heightIs(45 * kX);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kmaintextGrayColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"睡眠",nil);
    [topView addSubview:titleLabel];
    titleLabel.sd_layout.leftEqualToView(topView)
    .rightEqualToView(topView)
    .topEqualToView(topView)
    .bottomEqualToView(topView);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelButton];
    [cancelButton sizeToFit];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.frame = CGRectMake(20 * kX , 0, 100, topView.height);
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    okButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:okButton];
    [okButton sizeToFit];
    okButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    okButton.frame = CGRectMake(ScreenW - 100 - 20 * kX , 0, 100, topView.height);
    
    _clearBackView = backView;
    [UIView animateWithDuration:0.35 animations:^{
        _clearBackView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    }];
}

- (void)cancelClick
{
    [UIView animateWithDuration:0.35 animations:^{
        _clearBackView.frame = CGRectMake(0, self.view.height, self.view.width, self.view.height);
    } completion:^(BOOL finished) {
        [_clearBackView removeFromSuperview];
        _clearBackView = nil;
    }];
}

- (void)sureClick
{
    [UIView animateWithDuration:0.35 animations:^{
        _clearBackView.frame = CGRectMake(0, self.view.height, self.view.width, self.view.height);
    } completion:^(BOOL finished) {
        [_clearBackView removeFromSuperview];
        _clearBackView = nil;
    }];
    
    NSInteger hour = [_pickerView.mPickerView selectedRowInComponent:0];
    NSInteger min = [_pickerView.mPickerView selectedRowInComponent:2];
    [XXUserInformation setUserSleepHourTarget:[NSString stringWithFormat:@"%ld",hour]];
    [XXUserInformation setUserSleepMinuteTarget:[NSString stringWithFormat:@"%ld",min]];
    [self.targetBtn setTitle:[NSString stringWithFormat:@"%ldh%ldmin",hour,min] forState:UIControlStateNormal];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor whiteColor];
        }
    }
    if (component == 0 ) {
        
        return 24;
    }
    else if (component == 2){
        
        return 60;
    }
    else
    {
        return 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0 || component == 2)
    {
        return [NSString stringWithFormat:@"%02ld",(long)row];
    }
    else if(component == 1)
    {
        return NSLocalizedString(@"h", nil);
    }
    else
    {
        return NSLocalizedString(@"min", nil);
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[self pickerView:pickerView titleForRow:row forComponent:component] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSParagraphStyleAttributeName:paragraph}];
    return attributedString;
}

- (void)setSleepModel:(oneDaySleepModel *)sleepModel
{
    self.totalSleepLabel.text = [NSString stringWithFormat:@"%dh%dmin",sleepModel.totalSleepTime/60,sleepModel.totalSleepTime%60];
    self.deepSleepLabel.text = [NSString stringWithFormat:@"%dh%dmin",sleepModel.deepSleepTime/60,sleepModel.deepSleepTime%60];
    self.lightSleepLabel.text = [NSString stringWithFormat:@"%dh%dmin",sleepModel.lightSleepTime/60,sleepModel.lightSleepTime%60];
    self.awakeLabel.text = [NSString stringWithFormat:@"%dh%dmin",sleepModel.awakeSleepTime/60,sleepModel.awakeSleepTime%60];
}

- (SleepCircleView *)sleepCircle
{
    if (!_sleepCircle)
    {
        SleepCircleView *view = [[SleepCircleView alloc] initWithFrame:CGRectMake(0, 0, 235 * kX, 235 * kX)];
        [self.view addSubview:view];
        view.center = CGPointMake(ScreenW/2., 258 * kX);
        _sleepCircle = view;
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 235 * kX, 235 * kX)];
        [self.view addSubview:v];
        [self.view sendSubviewToBack:v];
        v.center = CGPointMake(ScreenW/2., 258 * kX);
        v.layer.masksToBounds = YES;
        v.layer.cornerRadius = v.frame.size.width/2;
        v.backgroundColor = kMainColor;
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detailButton.frame = CGRectMake(0, 0, 235*kX, 235*kX);
        detailButton.center = CGPointMake(ScreenW/2., 258*kX);
        [self.view addSubview:detailButton];
        [detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sleepCircle;
}

- (void)detailButtonClick {
    if ([EirogaBlueToothManager sharedInstance].isconnected) {
        MainSleepDetailViewController *detail = [MainSleepDetailViewController new];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
    }
}

- (UIView *)backView
{
    if (!_backView)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kmainBackgroundColor;
        view.layer.borderColor = KCOLOR(160, 202, 196).CGColor;
        view.layer.borderWidth = 1.0;
        view.layer.cornerRadius = 3;
        view.frame = CGRectMake(45 * kX, 400 * kX + 64, ScreenW - 90 * kX, 150 * kX);
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        [self.view addSubview:view];
        _backView = view;
        
        NSArray *nameArray = @[NSLocalizedString(@"深睡",nil),NSLocalizedString(@"浅睡",nil),NSLocalizedString(@"清醒",nil)];
        NSArray *imageArray = @[@"deepSleep",@"lightSleep",@"awake"];
        for (int i = 0 ; i < 3; i ++)
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = nameArray[i];
            [label sizeToFit];
            label.textColor = [UIColor whiteColor];
            label.frame = CGRectMake(13 * kX, 50 * kX * i  , label.width, 50 * kX);
            [_backView addSubview:label];
            
            UIImageView *sleepImage = [[UIImageView alloc] init];
            sleepImage.center = CGPointMake(label.width+20 * kX, label.y+10 * kX);
            sleepImage.size = CGSizeMake(30 * kX, 30 * kX);
            sleepImage.image = [UIImage imageNamed:imageArray[i]];
            [_backView addSubview:sleepImage];
        }
        
        _deepSleepLabel = [[UILabel alloc] init];
        _deepSleepLabel.text = @"0h0min";
        _deepSleepLabel.textColor = [UIColor whiteColor];
        _deepSleepLabel.textAlignment = NSTextAlignmentRight;
        _deepSleepLabel.frame = CGRectMake(_backView.width - 200 * kX, 0, 187 * kX, 50 *kX);
        [_backView addSubview:_deepSleepLabel];
        
        _lightSleepLabel = [[UILabel alloc] init];
        _lightSleepLabel.text = @"0h0min";
        _lightSleepLabel.textColor = [UIColor whiteColor];
        _lightSleepLabel.textAlignment = NSTextAlignmentRight;
        _lightSleepLabel.frame = CGRectMake(_backView.width - 200 * kX, 50 *kX, 187 * kX, 50 *kX);
        [_backView addSubview:_lightSleepLabel];
        
        _awakeLabel = [[UILabel alloc] init];
        _awakeLabel.text = @"0h0min";
        _awakeLabel.textColor = [UIColor whiteColor];
        _awakeLabel.textAlignment = NSTextAlignmentRight;
        _awakeLabel.frame = CGRectMake(_backView.width - 200 * kX, 100  * kX, 187 * kX, 50 *kX);
        [_backView addSubview:_awakeLabel];
    }
    return _backView;
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
