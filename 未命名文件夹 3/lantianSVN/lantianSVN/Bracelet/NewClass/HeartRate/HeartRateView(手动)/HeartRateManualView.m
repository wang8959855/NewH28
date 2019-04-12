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

@property (nonatomic, assign) int nowHeart;

@property (nonatomic, strong) NSMutableArray *heartArray;

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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenH/2)];
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
    self.circleView.valueTextColor = kMainColor;
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
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.height - 260*kDY);
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
}

#pragma mark -- button方法
- (void)targetBtnAction:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected)
    {
        kWEAKSELF;
        [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:YES andActualHeartBlock:^(int number1 , int number2) {
            if (number1) {
                if (_nowHeart != number2) {
                    _nowHeart = number2;
                    self.circleView.value = number2;
                    int timeSeconds = [[NSDate date] timeIntervalSince1970];
                    NSDictionary * dic = @{@"time":[NSString stringWithFormat:@"%d",timeSeconds],@"rate":[NSString stringWithFormat:@"%d",number2]};
                    [weakSelf.heartArray addObject:dic];
                }
            }else
            {
                if (button.selected)
                {
                    [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:NO andActualHeartBlock:nil];
                    button.selected = NO;
                }
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
    if (self.heartArray )
    {
        NSString *url = [NSString stringWithFormat:@"%@/?token=%@",HEARTRATEUPDATE,TOKEN];
        NSDictionary *jsonDic = @{@"deviceId":kHCH.mac,@"openid":kHCH.mac,@"values":_heartArray,@"type":kHCH.type,@"version":kHCH.version};
        
        NSDictionary *param = [kHCH changeToParamWithDic:jsonDic];
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
            if (responseObject)
            {
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

@end
