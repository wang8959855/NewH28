//
//  HeartRateManualView.m
//  Bracelet
//
//  Created by apple on 2018/8/12.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "HeartRateManualView.h"
#import "PSDrawerManager.h"

@interface HeartRateManualView ()<HeartRateCircleViewDelegate>

@property (nonatomic, assign) int beginTimeSecond;
@property (nonatomic, assign) int endTimesecond;

@property (nonatomic, assign) int nowHeart;

@property (nonatomic, strong) NSMutableArray *heartArray;
@property (nonatomic, strong) NSMutableArray *heartArray1;

@end

@implementation HeartRateManualView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = allColorWhite;
        [self setupView];
        [[PSDrawerManager instance] beginDragResponse];
    }
    return self;
}

- (void)setupView
{
    [self setSleepbackGround];
    
}

-(void)setSleepbackGround
{
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@""];
    backImageView.backgroundColor = allColorWhite;
    [self addSubview:backImageView];
    backImageView.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight - 48);
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenH)];
    bgView.backgroundColor = kMainColor;
    [self addSubview:bgView];
    
    self.circleView = [[HeartRateCircleView alloc] init];
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
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:self.circleView.frame];
    bgView1.backgroundColor = allColorWhite;
    bgView1.layer.cornerRadius = bgView1.width/2.0;
    bgView1.layer.masksToBounds = YES;
    [self addSubview:bgView1];
    [self addSubview:self.circleView];
    
    UIButton *detailButton = [[UIButton alloc]init];
    [self.circleView addSubview:detailButton];
    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    CGFloat detailButtonX = 0;
    CGFloat detailButtonY = 0;
    CGFloat detailButtonW = MIN(180 * kX, 180 * kDY) * WidthProportion;
    CGFloat detailButtonH = MIN(180 * kX, 180 * kDY) * HeightProportion;
    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(180 * kX, 34 * kX);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.height - 290*kDY);
    [self addSubview:self.targetBtn];
//    self.targetBtn.layer.borderColor = kMainColor.CGColor;
//    self.targetBtn.layer.borderWidth = 1;
    self.targetBtn.layer.cornerRadius = 17*kDY;
    [self.targetBtn setBackgroundColor:[UIColor whiteColor]];
    [self.targetBtn setTitle:[NSString stringWithFormat:@"开始测量"] forState:UIControlStateNormal];
    [self.targetBtn setTitle:NSLocalizedString(@"结束测量",nil) forState:UIControlStateSelected];
    self.targetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.targetBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIView *view = [[UIView alloc] init];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = kMainColor.CGColor;
    view.layer.borderWidth = 0.5f;
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(10, self.targetBtn.bottom+10, ScreenWidth-20 , 180);
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    
    UIImageView *jiedu = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    jiedu.image = [UIImage imageNamed:@"jiedu"];
    [view addSubview:jiedu];
    
    UILabel *jieduLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 100, 20)];
    jieduLabel.text = @"心律检测";
    jieduLabel.font = Font_Bold_String(13);
    [view addSubview:jieduLabel];
    
    UILabel *tixing = [[UILabel alloc] initWithFrame:CGRectMake(20, jieduLabel.bottom, view.width-40, view.height-30)];
    [view addSubview:tixing];
    tixing.numberOfLines = 0;
    tixing.font = [UIFont systemFontOfSize:12];
    tixing.text = @"  *点击”开始测量”，即可启动以秒为频率的心率监测模式，秒秒钟实时监测心率波动数值和波动幅度，有助于实时检出心脏早博和心律失常风险，主动预防心血管疾病的发生发展。\n   *如感觉有心悸、心慌、胸闷、头晕、出汗等症状，请立即启动手动监测模式，或去医院做进一步检查。\n  *手动监测模式每次监测时段为5分钟。启动该模式时，请勿切换页面并保持亮屏！";
    tixing.textColor = kMainColor;
    
}

#pragma mark -- button方法
- (void)targetBtnAction:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected)
    {
        self.beginTimeSecond = [[TimeCallManager getInstance] getSecondsOfCurTime];
        kWEAKSELF;
        [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:YES andActualHeartBlock:^(int number1 , int number2) {
            if (number1) {
                if (_nowHeart != number2) {
                    _nowHeart = number2;
                    self.circleView.value = number2;
                    int timeSeconds = [[NSDate date] timeIntervalSince1970];
                    NSDictionary * dic = @{@"time":[NSString stringWithFormat:@"%d",timeSeconds],@"rate":[NSString stringWithFormat:@"%d",number2]};
                    [weakSelf.heartArray addObject:dic];
                    [weakSelf.heartArray1 addObject:@(number2)];
                }
            }else
            {
                if (button.selected)
                {
                    [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:NO andActualHeartBlock:nil];
                    button.selected = NO;
                }
                self.endTimesecond = [[TimeCallManager getInstance] getSecondsOfCurTime];
                [weakSelf testEnded];
            }
        }];
    }else
    {
        [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:NO andActualHeartBlock:nil];
    }
}

- (void)testEnded
{
    if (self.heartArray1.count != 0)
    {
//        NSString *heart = [AllTool  arrayToStringHeart:self.heartArray1];
        NSString *heart = @"";
        for (NSString *str in self.heartArray1) {
            heart = [heart stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
        }
        NSString *url = [NSString stringWithFormat:@"%@",MANUALUOLOADHEART];
        NSDictionary *param = @{@"userid":USERID,@"token":TOKEN,@"start":@(self.beginTimeSecond),@"end":@(self.endTimesecond),@"heart":heart};
        
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
            if (responseObject)
            {
                int code = [responseObject[@"code"] intValue];
                if (code == 0) {
                    
                }else{
                    [self makeToast:responseObject[@"message"] duration:1.5 position:CSToastPositionCenter];
                }
                self.heartArray = nil;
                adaLog(@"%@",responseObject[@"message"]);
            }
        }];
    }
}

- (NSMutableArray *)heartArray
{
    if (!_heartArray)
    {
        _heartArray = [[NSMutableArray alloc] init];
    }
    return _heartArray;
}

- (NSMutableArray *)heartArray1
{
    if (!_heartArray1)
    {
        _heartArray1 = [[NSMutableArray alloc] init];
    }
    return _heartArray1;
}

@end
