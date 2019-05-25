//
//  SportView.m
//  Wukong
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "SportView.h"
#import "TargetViewController.h"
#import "AlertMainView.h"
#import "HistoryDataModel.h"
#import "userDataModel.h"
#import "sportModel.h"
#import "XXPickerView.h"
#import "NewSportDetailViewController.h"

@interface SportView ()<BlutToothManagerDelegate,LMGaugeViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,assign)NSInteger connectViewX;     // View 的 frame
@property (nonatomic,assign)NSInteger connectViewY;
@property (nonatomic,assign)NSInteger connectViewW;
@property (nonatomic,assign)NSInteger connectViewH;

@property (nonatomic,strong)NSTimer *refreshConnectTimer;//定时器  刷新界面
@property (nonatomic,strong)UIAlertView *alertView1;//系统异常  的提示

@property (nonatomic, weak) XXPickerView *pickerView;
@property (nonatomic, weak) UIView *clearBackView;

@property (nonatomic, assign) int totalStep;
@property (nonatomic, assign) int totalKcal;
@property (nonatomic, assign) int totalKm;

@end

@implementation SportView

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = allColorWhite;
        [self childrenTimeSecondChanged];
        [self setBlocks];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(childrenTimeSecondChanged) name:@"updateHeartRate" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowHeartRate:) name:nowHeartRate object:nil];
    }
    return self;
}

- (void)nowHeartRate:(NSNotification *)noti{
    _heartRateLabel.text = [NSString stringWithFormat:@"%d次/分",[noti.object intValue]];
}

- (void)setupView {
    [self setbackGround];
}

- (void)setbackGround {
    CGFloat backGroudImageViewW = CurrentDeviceWidth;
    CGFloat backGroudImageViewH = CurrentDeviceHeight - 48;
    UIImageView *backGroudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backGroudImageViewW, backGroudImageViewH)];
    backGroudImageView.backgroundColor = allColorWhite;
    [self addSubview:backGroudImageView];
    
    
    CGFloat backScrollViewX = 0 ;
    CGFloat backScrollViewY = 64;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.height;
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(backScrollViewX,backScrollViewY, backScrollViewW,backScrollViewH);
    [self addSubview:self.backScrollView];
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    bgView.backgroundColor = kMainColor;
    [self.backScrollView addSubview:bgView];
    
    //    设置下方4个view
    NSArray *array = @[@"里程",@"卡路里",@"实时心率",@"平均心率"];
    NSArray *leftImageArr = @[@"licheng_",@"kaluli_",@"shishi",@"pingjun_"];
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake((8 + i % 2 * 181) *kX,
                                self.backScrollView.height - (29 * kDY)- (100 + 3)*kDY * (i/2 + 1)-50,
                                178 * kX+10,
                                100*kDY);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.tag = 30+i;
        view.userInteractionEnabled = YES;
        [self.backScrollView addSubview:view];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertAtion:)];
//        [view addGestureRecognizer:tap];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        imageV.image = [UIImage imageNamed:@"xiaokuang"];
        [view addSubview:imageV];
        
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        leftImage.image = [UIImage imageNamed:leftImageArr[i]];
        [view addSubview:leftImage];
        
        UILabel *label = [[UILabel alloc] init];
        //label.backgroundColor = [UIColor redColor];
        label.text = array[i];
        label.font = Font_Normal_String(13);
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(0, (view.height-30)/2-15, view.width, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        NSMutableAttributedString *string;
        switch (i) {
            case 0:
            {
                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"km" WithFont:18];
                _distanceLabel = [[UILabel alloc] init];
                _distanceLabel.textColor = kMainColor;
                _distanceLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _distanceLabel.textAlignment = NSTextAlignmentCenter;
                _distanceLabel.attributedText = string;
                _distanceLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_distanceLabel];
            }
                break;
            case 1:
            {
                string =  [self makeAttributedStringWithnumBer:@"--" Unit:@"kcal" WithFont:18];
                _caloriesLabel = [[UILabel alloc] init];
                _caloriesLabel.textColor = kMainColor;
                _caloriesLabel.textAlignment = NSTextAlignmentCenter;
                _caloriesLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _caloriesLabel.attributedText = string;
                _caloriesLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_caloriesLabel];
                
            }
                break;
            case 2:
            {
                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"次/分" WithFont:18];
                _heartRateLabel = [[UILabel alloc] init];
                _heartRateLabel.textColor = kMainColor;
                _heartRateLabel.textAlignment = NSTextAlignmentCenter;
                _heartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _heartRateLabel.attributedText = string;
                _heartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_heartRateLabel];
            }
                break;
            case 3:
            {
                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"次/分" WithFont:18];
                _activeTimeLabel = [[UILabel alloc] init];
                _activeTimeLabel.textAlignment = NSTextAlignmentCenter;
                _activeTimeLabel.textColor = kMainColor;
                _activeTimeLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _activeTimeLabel.attributedText = string;
                _activeTimeLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_activeTimeLabel];
            }
                break;
            default:
                break;
        }
        
    }
    
    self.circle = [[LMGaugeView1 alloc] init];
    [self.backScrollView addSubview:self.circle];
    self.circle.frame = CGRectMake(0, 0, MIN(203 * kX, 203 * kDY), MIN(203 * kX, 203 * kDY));
    self.circle.center = CGPointMake(CurrentDeviceWidth / 2, 20 * kDY + self.circle.height/2.);
    self.circle.backgroundColor = [UIColor clearColor];
    
    self.circle.minValue = 0;
    self.circle.maxValue = [XXUserInformation userSportTarget].floatValue;
    self.circle.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circle.endAngle = 3./2 * M_PI;
    self.circle.ringBackgroundColor = [UIColor whiteColor];
    self.circle.valueTextColor = [UIColor whiteColor];
    self.circle.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circle.delegate = self;
    self.circle.value = 0;
    self.circle.valueFont  = Font_Normal_String(38);
    [self.circle setNeedsDisplay];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = self.circle.frame;
    [detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:detailButton];
    self.backScrollView.mj_header = [self getRefreshHeader];
    
    
    //    设置目标按钮
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(170*kX, 35*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.circle.bottom+30);
    [self.backScrollView addSubview:self.targetBtn];
    //    self.targetBtn.layer.borderColor = kMainColor.CGColor;
    //    self.targetBtn.layer.borderWidth = 1;
    self.targetBtn.layer.cornerRadius = 8*kDY;
    [self.targetBtn setImage:[UIImage imageNamed:@"target1"] forState:UIControlStateNormal];
    [self.targetBtn setAttributedTitle:[self makeAttributedStringWithnumBer:[XXUserInformation userSportTarget] Unit:@"(目标步数)" WithFont:18] forState:UIControlStateNormal];
    [self.targetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textColor = allColorWhite;
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (MJRefreshNormalHeader *)getRefreshHeader{
    kWEAKSELF;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([EirogaBlueToothManager sharedInstance].isconnected)
        {
            [[EirogaBlueToothManager sharedInstance] getHistoryDataWithTimeSeconds:0 andHour:0];
            [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
            [weakSelf childrenTimeSecondChanged];
        }else{
            [weakSelf addActityTextInView:weakSelf text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            [weakSelf.backScrollView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉可以刷新",nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开立即刷新",nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"正在刷新数据",nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor blackColor];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    return header;
}

#pragma mark -- button方法

- (void)childrenTimeSecondChanged {
    
    [self.targetBtn setTitle:[XXUserInformation userSportTarget] forState:UIControlStateNormal];
    self.circle.maxValue = [XXUserInformation userSportTarget].floatValue;
    
    [self endHeadRefresh];
    if ([[EirogaBlueToothManager sharedInstance] isconnected]) {
        HistoryDataModel *model = [[HistoryDataModel alloc]init];
        kWEAKSELF
        [model writeDateYearWithTimeSeconds:kHCH.todayTimeSeconds completion:^(userDataModel *dataModel) {
            if (dataModel) {
                sportModel *sportM = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel.userData];
                [weakSelf setLabel:sportM.heartArray];
            }else{
                
            }
        }];
        _targetBtn.userInteractionEnabled = YES;
        
        [[PZBlueToothManager sharedInstance] getActualDataWithDataBlockWithBlock:^(ActualDataModel *model) {
            [weakSelf setStep:model];
        }];
        
    } else {
        _heartRateLabel.attributedText = [self makeAttributedStringWithnumBer:@"--" Unit:@"次/分" WithFont:18];
//        _targetBtn.userInteractionEnabled = NO;
    }
}

- (void)setLabel:(NSArray *)StepArray{
    int maxValue = 0;
    int minValue = 0;
    int count = 0;
    int totalValue = 0;
    
    int currentHR = 0;
    int hour = [AllTool currentHour];
    int minute = [AllTool currentMinute];
    int location = (hour*60+minute)/2;
    for ( int i = 0 ; i < StepArray.count; i ++)
    {
        int value = [StepArray[i] intValue];
        if (location-1 == i) {
//            currentHR = value;
        }
        if (value > 0)
        {
            currentHR = value;
            if (minValue == 0)
            {
                minValue = value;
            }
            count ++;
            maxValue = MAX(maxValue, value);
            if (value < minValue)
            {
                minValue = value;
            }
            totalValue += value;
        }
    }
    int avgValue = totalValue/count;
    
//    _activeTimeLabel.text = [NSString stringWithFormat:@"%d次/分",avgValue];
//    _heartRateLabel.text = [NSString stringWithFormat:@"%d次/分",currentHR];
}

- (void)setStep:(ActualDataModel *)model{
    NSString *distance = [NSString stringWithFormat:@"%.3f",model.distance/1000.];
    self.totalKm = model.distance;
    self.totalKcal = model.calories;
    self.totalStep = model.steps;
    self.caloriesLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",model.calories] Unit:@"kcal" WithFont:18];
    self.distanceLabel.attributedText = [self makeAttributedStringWithnumBer:distance Unit:@"km" WithFont:18];
    self.circle.value = model.steps;
    _activeTimeLabel.text = [NSString stringWithFormat:@"%d次/分",model.hr];
    
}

- (void)targetBtnAction:(UIButton *)button{
    UIView  *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
    backView.frame = CGRectMake(0, self.height, self.width, self.height);
    
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
    int value = [[XXUserInformation userSportTarget] intValue];
    [picker.mPickerView selectRow:value/1000 - 1 inComponent:0 animated:NO];
    
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
    titleLabel.text = NSLocalizedString(@"步数",nil);
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
        _clearBackView.frame = CGRectMake(0, 0, self.width, self.height);
    }];
}

- (void)cancelClick
{
    [UIView animateWithDuration:0.35 animations:^{
        _clearBackView.frame = CGRectMake(0, self.height, self.width, self.height);
    } completion:^(BOOL finished) {
        [_clearBackView removeFromSuperview];
        _clearBackView = nil;
    }];
}

- (void)sureClick
{
    [UIView animateWithDuration:0.35 animations:^{
        _clearBackView.frame = CGRectMake(0, self.height, self.width, self.height);
    } completion:^(BOOL finished) {
        [_clearBackView removeFromSuperview];
        _clearBackView = nil;
    }];
    
    NSInteger row = [_pickerView.mPickerView selectedRowInComponent:0];
//    [self.targetBtn setTitle:[NSString stringWithFormat:@"%ld",(row + 1) * 1000] forState:UIControlStateNormal];
    [self.targetBtn setAttributedTitle:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%ld",(row + 1) * 1000] Unit:@"(目标步数)" WithFont:18] forState:UIControlStateNormal];
    [XXUserInformation setUserSportTarget:[NSString stringWithFormat:@"%ld",(row + 1) * 1000]];
    [self childrenTimeSecondChanged];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
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
    return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld",(row + 1) * 1000];
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

- (void)detailButtonClick {
    if ([EirogaBlueToothManager sharedInstance].isconnected) {
        NewSportDetailViewController *detail = [NewSportDetailViewController new];
        detail.hidesBottomBarWhenPushed = YES;
        detail.totalStep = self.totalStep;
        detail.totalKcal = self.totalKcal;
        detail.totalKm = self.totalKm;
        [self.controller.navigationController pushViewController:detail animated:YES];
    }else{
        [self addActityTextInView:self text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
        [self.backScrollView.mj_header endRefreshing];
    }
}

#pragma mark -- 内部方法

- (void)reloadOutTime {
    [self.backScrollView.mj_header endRefreshing];
}

- (void)setBlocks {
    //解除绑定要回调事件
    [self childrenTimeSecondChanged];
}

//停止头部的刷新
-(void)endHeadRefresh {
    [self.backScrollView.mj_header endRefreshing];
}

#pragma mark -- 圆环代理
- (UIColor *)gaugeView:(LMGaugeView1 *)gaugeView ringStokeColorForValue:(CGFloat)value {
    return kColor(89, 253, 214);
}
#pragma mark -- 给客户的友情提示
-(void)dismiss:(UIAlertView *)al {
    if (_alertView1) {
        [_alertView1 dismissWithClickedButtonIndex:[al cancelButtonIndex] animated:YES];
    }
}
/**
 提示没有网络
 */
-(void)remindNotReachable
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self addActityTextInView:window text:NSLocalizedString(@"当前无网络连接", nil) deleyTime:1.0f];
}

//获取属性字符串
- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

//点击提示
- (void)alertAtion:(UIGestureRecognizer *)tap{
    NSArray *arr;
    switch (tap.view.tag) {
        case 30:
            arr = @[@"从监测起始至目前的步行里程总数。"];
            break;
            
        case 31:
            arr = @[@"从监测起始至目前的卡路里消耗总数。"];
            break;
            
        case 32:
            arr = @[@"以秒为单位的实时心率数值。"];
            break;
            
        case 33:
            arr = @[@"从监测起始至目前的心率平均数值。"];
            break;
    }
    [AlertMainView alertMainViewWithArray:arr];
}

@end

