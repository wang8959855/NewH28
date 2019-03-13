//
//  MainHRViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/11.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "MainHRViewController.h"
#import "LMGaugeView.h"
#import "UIView+HeartBeat.h"

@interface MainHRViewController ()

@property (nonatomic, weak) LMGaugeView *circleView;

@property (nonatomic, weak) UIButton *beginButton;

@property (nonatomic, weak) UILabel *HRLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int beginTimeSecond;

@property (nonatomic, assign) UIImageView *heartImageView;

@property (nonatomic, assign) int nowHeart;

@property (nonatomic, strong) NSMutableArray *heartArray;

@end

@implementation MainHRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
}

- (void)dealloc{
    adaLog(@"HR  delloc");
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"心率",nil) backButton:YES shareButton:YES];
    [self circleView];
    [self beginButton];
    [self heartImageView];
    [self HRLabel];
}

- (void)timeFire
{
    self.circleView.value += 1;
}

- (void)beginButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected)
    {
        if (!self.timer)
        {
           self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire) userInfo:nil repeats:YES];
        }
        self.HRLabel.text = @"00";
        [self.heartImageView heartBeat:@999];
        self.circleView.value = 0;
        
        kWEAKSELF;
        [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:YES andActualHeartBlock:^(int number1 , int number2) {
            if (number1) {
                weakSelf.HRLabel.text = [NSString stringWithFormat:@"%02d",number2];
                if (_nowHeart != number2) {
                    _nowHeart = number2;
                    int timeSeconds = [[NSDate date] timeIntervalSince1970];
                    NSDictionary * dic = @{@"time":[NSString stringWithFormat:@"%d",timeSeconds],@"rate":[NSString stringWithFormat:@"%d",number2]};
                    [weakSelf.heartArray addObject:dic];
                }
            }else
            {
                if (button.selected)
                {
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                    [weakSelf.heartImageView stopHeartBeat];
                    [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:NO andActualHeartBlock:nil];
                    button.selected = NO;
                }
                [weakSelf testEnded];
            }
        }];
    }else
    {
        [self.timer invalidate];
        self.timer = nil;
        [self.heartImageView stopHeartBeat];
        [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:NO andActualHeartBlock:nil];
    }
}

- (void)testEnded
{
    if (self.heartArray )
    {
        NSDictionary *jsonDic = @{@"deviceId":kHCH.mac,@"openid":kHCH.mac,@"values":_heartArray,@"type":kHCH.type,@"version":kHCH.version};
        
        NSDictionary *param = [kHCH changeToParamWithDic:jsonDic];
        [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"RealTimeHeartRate.php" ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
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

- (void)backBarButtonPressed:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [[PZBlueToothManager sharedInstance] switchActualHeartStateWithState:NO andActualHeartBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LMGaugeView *)circleView
{
    if (!_circleView)
    {
        LMGaugeView *lgmView = [[LMGaugeView alloc] init];
        lgmView.frame = CGRectMake(0, 0, 225 * kX, 225 * kX);
        lgmView.center = CGPointMake(ScreenW/2., 290 * kX);
        lgmView.value = 0;
        lgmView.startAngle = 3./2 * M_PI + M_PI/3600.;
        lgmView.endAngle = 3./2 * M_PI;
        lgmView.ringThickness = 9 *kX;
        lgmView.ringBackgroundColor = kmainDarkColor;
        lgmView.maxValue = 300;
        [self.view addSubview:lgmView];
        _circleView = lgmView;
    }
    return _circleView;
}

- (UIButton *)beginButton
{
    if (!_beginButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"开始测量",nil) forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"结束测量",nil) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = kmainDarkColor;
        button.layer.cornerRadius = 5;
        [self.view addSubview:button];
        button.sd_layout.topSpaceToView(_circleView, 43 * kX)
        .centerXIs(ScreenW/2.)
        .widthIs(150 * kX)
        .heightIs(37 * kX);
        _beginButton = button;
    }
    return _beginButton;
}

- (UIImageView *)heartImageView
{
    if (!_heartImageView)
    {
        UIImageView *heartImageView = [[UIImageView alloc] init];
        heartImageView.contentMode = UIViewContentModeScaleAspectFit;
        heartImageView.image = [UIImage imageNamed:@"bigHeart"];
        [self.circleView addSubview:heartImageView];
        heartImageView.sd_layout.topSpaceToView(self.circleView, 55 * kX)
        .centerXIs(self.circleView.width / 2.)
        .widthIs(44 * kX)
        .heightIs(38 *kX);
        _heartImageView = heartImageView;
    }
    return _heartImageView;
}

- (UILabel *)HRLabel
{
    if (!_HRLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"00";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:35];
        [self.circleView addSubview:label];
        label.sd_layout.topSpaceToView(_heartImageView, 20)
        .centerXIs(self.circleView.width/2.)
        .widthIs(self.circleView.width)
        .heightIs(35 * kX);
        _HRLabel = label;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor whiteColor];
        [self. circleView addSubview:lineView];
        lineView.sd_layout.topSpaceToView(label, 7 * kX)
        .centerXIs(self.circleView.width/2.)
        .heightIs(1)
        .widthIs(118 * kX);
        
        UILabel *bpmLabel = [[UILabel alloc] init];
        bpmLabel.textColor = [UIColor whiteColor];
        bpmLabel.textAlignment = NSTextAlignmentCenter;
        bpmLabel.text = @"bpm";
        [self.circleView addSubview:bpmLabel];
        bpmLabel.sd_layout.topSpaceToView(lineView, 8 * kX)
        .centerXIs(self.circleView.width/2.)
        .widthIs(self.circleView.width)
        .heightIs(20);
    }
    return _HRLabel;
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
