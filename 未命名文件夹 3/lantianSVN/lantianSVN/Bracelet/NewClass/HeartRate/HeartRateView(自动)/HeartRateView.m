 //
//  HeartRateView.m
//  Wukong
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "HeartRateView.h"
#import "PSDrawerManager.h"
#import "AlertMainView.h"
#import "HistoryDataModel.h"
#import "userDataModel.h"
#import "sportModel.h"
#import "HeartRateDetailViewController.h"
#import "SetBloodOxygenView.h"

@interface HeartRateView ()<BlutToothManagerDelegate,BlutToothManagerDelegate,HeartRateCircleViewDelegate>

@property (strong, nonatomic) UIScrollView *backScrollView;
//当前心率
@property (nonatomic, assign) NSInteger nowHeartRate;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HeartRateView

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
    if (![EirogaBlueToothManager sharedInstance].isconnected) {
        [self childrenTimeSecondChanged];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = allColorWhite;
        [self setupView];
        [[PSDrawerManager instance] beginDragResponse];
        [self childrenTimeSecondChanged];
        [self setBlocks];
        self.backScrollView.mj_header = [self getRefreshHeader];
        [self getHomeData];
    }
    return self;
}

-(void)setupView
{
    [self initPro];
    [self setSleepbackGround];
    
//    [[PZBlueToothManager sharedInstance] connectStateChangedWithBlock:^(BOOL isConnect, CBPeripheral *peripheral) {
//        if (isConnect) {
//            [[PZBlueToothManager sharedInstance] getHeartRateTimeinterverWithBlock:^(int number) {
//                int sec = 0;
//                if (number == 3) {
//                    sec = 120;
//                }
//                sec = number * 60;
//            }];
//        }
//    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:150 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimer) name:@"changeTimer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowHeartRate:) name:nowHeartRate object:nil];
}

- (void)nowHeartRate:(NSNotification *)noti{
    self.nowHeartRateLabel.text = [NSString stringWithFormat:@"%d次/分",[noti.object intValue]];
    self.circleView.value = [noti.object intValue];
}

- (void)changeTimer{
//    [self.timer invalidate];
//    self.timer = nil;
//    [[PZBlueToothManager sharedInstance] connectStateChangedWithBlock:^(BOOL isConnect, CBPeripheral *peripheral) {
//        if (isConnect) {
//            [[PZBlueToothManager sharedInstance] getHeartRateTimeinterverWithBlock:^(int number) {
//                int sec = 0;
//                if (number == 3) {
//                    sec = 120;
//                }
//                sec = number * 60;
//                self.timer = [NSTimer scheduledTimerWithTimeInterval:sec target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
//            }];
//        }
//    }];
}

-(void)setSleepbackGround
{
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@""];
    backImageView.backgroundColor = allColorWhite;
    [self addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight - 48);
    
    //CGFloat backScrollViewX = 0;
    CGFloat backScrollViewY = 0;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = self.frame.size.height;
    
    self.backScrollView = [[UIScrollView alloc] init];
    self.backScrollView.frame = CGRectMake(0,backScrollViewY,backScrollViewW, backScrollViewH);
    [self addSubview:self.backScrollView];
    
    self.backScrollView.contentSize = CGSizeMake(self.backScrollView.width, self.backScrollView.height+0.5);
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.backgroundColor  = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenH/2)];
    bgView.backgroundColor = kMainColor;
    [self.backScrollView addSubview:bgView];
    
    kWEAKSELF
//    [self.backScrollView addHeaderWithCallback:^{
//        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
//        [weakSelf SLEdropDownReload];
//    }];
    
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundView];
    
}

//初始化提醒的view  的 刷新
- (MJRefreshNormalHeader *)getRefreshHeader
{
    kWEAKSELF;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([EirogaBlueToothManager sharedInstance].isconnected) {
            [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
            [weakSelf childrenTimeSecondChanged];
        }else{
            [weakSelf addActityTextInView:weakSelf text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            [weakSelf.backScrollView.mj_header endRefreshing];
        }
        [self getHomeData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉可以刷新",nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开立即刷新",nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"正在刷新数据",nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor blackColor];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    return header;
}

-(void)SLEconnectionFailedAction:(int)isSeek
{
    
}

#pragma mark -- 内部方法
-(void)initPro
{
//    [PZBlueToothManager sharedInstance].delegate = self;
}

- (void)setBlocks
{
    
}
//下拉刷新
-(void)SLEdropDownReload
{

    [self childrenTimeSecondChanged];
}

- (void)childrenTimeSecondChanged {
    [self reloadData];
}

-(void)successCallbackSleepData
{
    [self reloadData];
    
}
- (void)reloadData;
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHeartRate" object:nil];
    [self.backScrollView.mj_header endRefreshing];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    
    HistoryDataModel *model = [[HistoryDataModel alloc]init];
    kWEAKSELF
    [model writeDateYearWithTimeSeconds:kHCH.todayTimeSeconds completion:^(userDataModel *dataModel) {
        if (dataModel)
        {
            sportModel *sportM = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel.userData];
            [weakSelf setLabel:sportM.heartArray];
        }else{
            
        }
    }];
    
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
    
//    self.fatigueLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",minValue] Unit:@"bpm" WithFont:18];
//    self.bloodPressureLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",maxValue] Unit:@"bpm" WithFont:18];
//    self.averageHeartRateLabel.attributedText = [self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%d",avgValue] Unit:@"bpm" WithFont:18];
//    self.nowHeartRateLabel.text = [NSString stringWithFormat:@"%d次/分",currentHR];
//    self.circleView.value = currentHR;
}

- (void)setBackgroundView
{
    NSArray *array = @[@"血压",@"血氧",@"实时心率",@"体温"];
    NSArray *leftImageArr = @[@"xueya",@"xueyang",@"shishi",@"tiwen"];
    
    for (int i = 0; i < 4; i ++)
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake((8 + i % 2 * 181) *kX,
                                self.backScrollView.height- (29 * kDY)- (100 + 3)*kDY * (i/2 + 1)-30,
                                178 * kX+10,
                                100*kDY);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.tag = 30+i;
        view.userInteractionEnabled = YES;
        [self.backScrollView addSubview:view];
        
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
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertAtion:)];
//        [view addGestureRecognizer:tap];
        
        NSAttributedString *string;
        switch (i) {
            case 0:
            {
                _bloodPressureLabel = [[UILabel alloc] init];
                _bloodPressureLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _bloodPressureLabel.textAlignment = NSTextAlignmentCenter;
                _bloodPressureLabel.text = @"--/--mmHg";
                _bloodPressureLabel.textColor = kMainColor;
                [view addSubview:_bloodPressureLabel];
            }
                break;
            case 1:
            {
                _fatigueLabel = [[UILabel alloc] init];
                _fatigueLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _fatigueLabel.textAlignment = NSTextAlignmentCenter;
                _fatigueLabel.textColor = kMainColor;
                _fatigueLabel.text = @"--%";
                [view addSubview:_fatigueLabel];
            }
                break;
            case 2:
            {
//                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:18];
                _nowHeartRateLabel = [[UILabel alloc] init];
                _nowHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _nowHeartRateLabel.text = @"--次/分";
                _nowHeartRateLabel.textColor = kMainColor;
                _nowHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:_nowHeartRateLabel];
            }
                break;
            case 3:
            {
//                string = [self makeAttributedStringWithnumBer:@"--" Unit:@"bpm" WithFont:18];
                _averageHeartRateLabel = [[UILabel alloc] init];
                _averageHeartRateLabel.frame = CGRectMake(0, (view.height-30)/2+15, view.width, 30);
                _averageHeartRateLabel.textAlignment = NSTextAlignmentCenter;
                _averageHeartRateLabel.text = @"--℃";
                _averageHeartRateLabel.textColor = kMainColor;
                [view addSubview:_averageHeartRateLabel];
            }
                break;
            default:
                break;
        }
    }
    
    self.circleView = [[HeartRateCircleView alloc] init];
    [self.backScrollView addSubview:self.circleView];
    self.circleView.frame = CGRectMake(0, 0, MIN(180 * kX, 180 * kDY), MIN(180 * kX, 180 * kDY));
    self.circleView.center = CGPointMake(CurrentDeviceWidth / 2, 40 * kDY + self.circleView.height/2.);
    self.circleView.backgroundColor = [UIColor clearColor];
    
    self.circleView.minValue = 0;
    self.circleView.maxValue = 220;
    self.circleView.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circleView.endAngle = 3./2 * M_PI;
//    self.circleView.ringBackgroundColor = kColor(234, 237, 242);
    self.circleView.valueTextColor = kColor(244, 70, 73);
    self.circleView.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circleView.delegate = self;
    self.circleView.value = 0;
    [self.circleView setNeedsDisplay];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.circleView.frame];
    bgView.backgroundColor = allColorWhite;
    bgView.layer.cornerRadius = bgView.width/2.0;
    bgView.layer.masksToBounds = YES;
    [self.backScrollView addSubview:bgView];
    [self.backScrollView addSubview:self.circleView];
    
    UIButton *detailButton = [[UIButton alloc]init];
    [self.circleView addSubview:detailButton];
    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat detailButtonX = 0;
    CGFloat detailButtonY = 0;
    CGFloat detailButtonW = MIN(223 * kX, 223 * kDY) * WidthProportion;
    CGFloat detailButtonH = MIN(223 * kX, 223 * kDY) * HeightProportion;
    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(200*kX, 30*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.height - 286*kDY);
    [self.backScrollView addSubview:self.targetBtn];
    self.targetBtn.layer.cornerRadius = 8*kDY;
    [self.targetBtn setTitle:[NSString stringWithFormat:@"血压/血糖校准设置"] forState:UIControlStateNormal];
    [self.targetBtn setImage:[UIImage imageNamed:@"jiaozhun"] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.targetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *
 查询当前血压
 */
-(void)sleepDrawWithDictionary{
}

-(void)refreshing
{
    if (self.rateReloadViewBlock) {
        self.rateReloadViewBlock(NSLocalizedString(@"DataSyn", nil));
    }
}
-(void)SLErefreshSucc
{
    if (self.rateReloadViewBlock) {
        self.rateReloadViewBlock(NSLocalizedString(@"syncFinish", nil));
    }
}
-(void)SLErefreshFail
{
    if (self.rateReloadViewBlock) {
        self.rateReloadViewBlock(NSLocalizedString(@"synchronizationFailure", nil));
    }
}

#pragma mark -- button方法
- (void)targetBtnAction:(UIButton *)button{
    [SetBloodOxygenView bloodOxygenView];
}
- (void)detailButtonAction:(UIButton *)button{
    if ([EirogaBlueToothManager sharedInstance].isconnected) {
        HeartRateDetailViewController *detail = [HeartRateDetailViewController new];
        detail.hidesBottomBarWhenPushed = YES;
        [self.controller.navigationController pushViewController:detail animated:YES];
    }else{
        [self addActityTextInView:self text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
        [self.backScrollView.mj_header endRefreshing];
    }
}
- (void)reloadOutTime
{
    [self.backScrollView.mj_header endRefreshing];
    [self SLErefreshFail];
}

//获取属性字符串
- (NSMutableAttributedString *)makeAttributedStringWithnumBer:(NSString *)number Unit:(NSString *)unit WithFont:(int)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:number];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributeString.length)];
    NSMutableAttributedString *unitString = [[NSMutableAttributedString alloc] initWithString:unit];
    [unitString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font - 5] range:NSMakeRange(0, unitString.length)];
    [attributeString appendAttributedString:unitString];
    return attributeString;
}

/*
//获取最后一个心率值
- (NSInteger)getSleepEndTime:(NSInteger)time{
    NSDictionary *lastDayDic= [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:time - KONEDAYSECONDS];
    NSDictionary *detailDic = [[CoreDataManage shareInstance] querDayDetailWithTimeSeconds:kHCH.selectTimeSeconds];
    NSMutableArray *sleepArray = [NSMutableArray array];
    NSMutableArray * lastDaySleepArray = [SleepTool lastDaySleepDataWithDictionary:lastDayDic];
    
    [sleepArray addObjectsFromArray:lastDaySleepArray];
    
    NSArray *todaySleepArray = [SleepTool todayDaySleepDataWithDictionary:detailDic];
    [sleepArray addObjectsFromArray:todaySleepArray];
    
    sleepArray = [AllTool filterSleepToValid:sleepArray];//过滤清醒成浅睡
    int nightBeginTime = 0;
    int nightEndTime = 0;
    BOOL isBegin = NO;
    for (int i = 0; i < sleepArray.count; i ++)
    {
        int sleepState = [sleepArray[i] intValue];
        if (sleepState != 0 && sleepState != 3)
        {
            if (isBegin == NO)
            {
                isBegin = YES;
                nightBeginTime = i;
            }
            nightEndTime = i;
        }
    }
    
    if (sleepArray && sleepArray.count != 0)
    {
        if (nightEndTime > nightBeginTime)
        {
            nightEndTime += 1;
        }
    }
    
    return [self drawNightHeartViewWithBeginTime:nightBeginTime EndTime:nightEndTime];
}

- (NSInteger)drawNightHeartViewWithBeginTime:(int)beginTime EndTime:(int)endTime
{
    NSMutableArray *_nightHeartArray = [NSMutableArray array];
    [_nightHeartArray removeAllObjects];
    if (beginTime == endTime)
    {
        return 60;
    }
    beginTime = beginTime*10;
    endTime = endTime *10;
    NSDictionary *heartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds - KONEDAYSECONDS + 8];
    
    NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:heartDic[HeartRate_ActualData_HCH]];
    //只是去后面两个小时
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    NSRange range = NSMakeRange(0, mutableArray.count/3);
    [mutableArray removeObjectsInRange:range];
    
    NSMutableArray *tempArray = [NSMutableArray new];
    if (array && array.count != 0)
    {
        [tempArray addObjectsFromArray:mutableArray];
    }
    else
    {
        for (int i = 0 ; i < 120; i ++) //晚上九点到十二点
        {
            [tempArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    for (int i = 1 ; i < 5; i ++)
    {
        if( i == 4 )
        {   //只是取前十个小时
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array1 = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            NSMutableArray *mutableArray1 = [NSMutableArray arrayWithArray:array1];
            NSRange range1 = NSMakeRange(mutableArray1.count/ 3, mutableArray1.count/3 *2);
            [mutableArray1 removeObjectsInRange:range1];
            if (array && array.count != 0)
            {
                [tempArray addObjectsFromArray:mutableArray1];
            }
            else
            {
                for (int i = 0 ; i < 60; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
            
        }
        else
        {
            NSDictionary *nightHeartDic = [[CoreDataManage shareInstance] querHeartDataWithTimeSeconds:kHCH.selectTimeSeconds+i];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:nightHeartDic[HeartRate_ActualData_HCH]];
            if (array && array.count != 0&&(!((array.count==1)&&([array[0]isEqualToString:@""]))))
            {
                [tempArray addObjectsFromArray:array];
            }
            else
            {
                for (int i = 0 ; i < 180; i ++)
                {
                    [tempArray addObject:[NSNumber numberWithInt:0]];
                }
            }
        }
    }
    
    
    for (int i = beginTime; i < endTime; i ++)
    {
        if(tempArray[i])
        {
            [_nightHeartArray addObject:tempArray[i]];
        }
        else
        {
        }
    }
    return [_nightHeartArray.lastObject integerValue];
}
*/

- (void)requestGETWarning{
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",GETWARNING,TOKEN];
    NSDictionary *para = @{@"userid":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            NSInteger warnNum = [responseObject[@"data"][@"warnNum"] integerValue];
            [self.targetBtn setTitle:[NSString stringWithFormat:@"警报次数%ld次",warnNum] forState:UIControlStateNormal];
        }else{
        }
    }];
}

//点击提示
- (void)alertAtion:(UIGestureRecognizer *)tap{
    NSArray *arr;
    switch (tap.view.tag) {
        case 30:
            arr = @[@"从监测起始至目前的心率最高数值。"];
            break;
            
        case 31:
            arr = @[@"从监测起始至目前的心率最低数值。"];
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

- (void)getHomeData{
    [self makeToastActivity];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@",HOMEDATA];
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:uploadUrl ParametersDictionary:@{@"userid":USERID,@"device":@"h28_",@"token":TOKEN} Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self hideToastActivity];
        if (error) {
            [self makeToast:@"网络连接错误" duration:1.5 position:CSToastPositionCenter];
        }else{
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                
                self.averageHeartRateLabel.text = [NSString stringWithFormat:@"%@℃",responseObject[@"data"][@"tiwen"]];
                self.fatigueLabel.text = [NSString stringWithFormat:@"%@%%",responseObject[@"data"][@"xueyang"]];
                self.bloodPressureLabel.text = [NSString stringWithFormat:@"%@mmHg",responseObject[@"data"][@"xueya"]];
                
                NSString *xueya = responseObject[@"data"][@"xueya"];
                NSArray *xueyaArr = [xueya componentsSeparatedByString:@"/"];
                NSString *xueyang = [NSString stringWithFormat:@"%.1f",[responseObject[@"data"][@"xueyang"] doubleValue]];
                NSArray *xueyangArr = [xueyang componentsSeparatedByString:@"."];
                
                int spo2 = 0;
                if (xueyaArr.count == 2) {
                    spo2 = [xueyangArr[1] intValue];
                }
                
                NSString *xuetang;
                if (responseObject[@"data"][@"xuetang"] == nil || [responseObject[@"data"][@"xuetang"] isEqual:[NSNull null]]) {
                    xuetang = @"";
                }else{
                    xuetang = [NSString stringWithFormat:@"%.1f",[responseObject[@"data"][@"xuetang"] floatValue]];
                }
                
                if ([[EirogaBlueToothManager sharedInstance] isconnected]) {
                    [[PZBlueToothManager sharedInstance] sendUserBph:[xueyaArr[0] intValue] bpl:[xueyaArr[1] intValue] glu:[xuetang intValue] spo1:[xueyangArr[0] intValue] spo2:spo2];
                }
                
            } else {
                [self makeToast:message duration:1.5 position:CSToastPositionCenter];
            }
        }
    }];
}

@end
