//
//  HeartRateViewController.m
//  Bracelet
//
//  Created by apple on 2018/8/11.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "HeartRateViewController.h"
#import "HeartRateView.h"
#import "HeartRateManualView.h"
#import "SheBeiViewController.h"

@interface HeartRateViewController ()

//选择显示类型的view
@property (nonatomic, strong) UIView *selectShowTypeView;

//自动
@property (nonatomic, strong) UIButton *autoButton;
//手动
@property (nonatomic, strong) UIButton *manualButton;

//心率的view
@property (nonatomic, strong) HeartRateView *rateView;
//脏腑的view
@property (nonatomic, strong) HeartRateManualView *rateViewManual;

@end

@implementation HeartRateViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.rateView childrenTimeSecondChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //是否进入设备连接界面
    NSString *isDevice = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoginOpenDevice"];
    if ([isDevice isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLoginOpenDevice"];
        SheBeiViewController *shebei = [SheBeiViewController sharedInstance];
        shebei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shebei animated:NO];
    }
    
    [self addnavTittle:@"体征" RSSIImageView:YES shareButton:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"kBleBoundPeripheralIdentifierString"];
        
        if (![EirogaBlueToothManager sharedInstance].isconnected) {
            if (value && ![value isEqualToString:@""])
            {
                [[PZBlueToothManager sharedInstance] connectWithUUID:value perName:nil Mac:nil];
            }
        }
    });
    self.view.backgroundColor = kMainColor;
    [self setView];
    
}

- (void)setView{
    
    //selectShowTypeView
    _selectShowTypeView = [[UIView alloc] init];
    _selectShowTypeView.frame = CGRectMake(ScreenWidth/2-100, 64+12+10, 200, 40);
    _selectShowTypeView.backgroundColor = KCOLOR(214, 241, 251);
    [self.view addSubview:_selectShowTypeView];
//    _selectShowTypeView.layer.borderWidth = 1;
//    _selectShowTypeView.layer.borderColor = kColor(210, 210, 210).CGColor;
    _selectShowTypeView.layer.cornerRadius = 20.f;
    _selectShowTypeView.layer.masksToBounds = YES;
    
    //selectShowTypeView上的button
    _autoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _autoButton.frame = CGRectMake(0, 0, 110, 40);
    _autoButton.layer.cornerRadius = 20.f;
    _autoButton.layer.masksToBounds = YES;
    [_autoButton setTitle:@"自动" forState:UIControlStateNormal];
    [_autoButton setBackgroundColor:KCOLOR(40, 82, 251)];
    [_autoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_autoButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_autoButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    _autoButton.selected = YES;
    [_selectShowTypeView addSubview:_autoButton];
    
    _manualButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _manualButton.frame = CGRectMake(90, 0, 110, 40);
    _manualButton.layer.cornerRadius = 20.f;
    _manualButton.layer.masksToBounds = YES;
    [_manualButton setTitle:@"手动" forState:UIControlStateNormal];
    [_manualButton setBackgroundColor:[UIColor clearColor]];
    [_manualButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_manualButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_manualButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    [_selectShowTypeView addSubview:_manualButton];
    
    
    CGFloat backScrollViewY = 64+42+20;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - 64 - 49;
    
    _rateViewManual = [[HeartRateManualView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _rateViewManual.controller = self;
    [self.view addSubview:_rateViewManual];
    
    _rateView = [[HeartRateView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _rateView.controller = self;
    [self.view addSubview:_rateView];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 30, StatusBarHeight + 12, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"tizheng1",@"tizheng2",@"tizheng3",@"tizheng4",@"tizheng5",@"tizheng6"];
    [self.navigationController pushViewController:guide animated:YES];
}

//切换视图
- (void)changeShowView:(UIButton *)button{
    [button setBackgroundColor:KCOLOR(40, 82, 251)];
    button.selected = YES;
    if (button == _autoButton) {
        _manualButton.selected = NO;
        [_manualButton setBackgroundColor:[UIColor clearColor]];
        [self.view bringSubviewToFront:self.rateView];
        [self.rateView childrenTimeSecondChanged];
    }else{
        _autoButton.selected = NO;
        [_autoButton setBackgroundColor:[UIColor clearColor]];
        [self.view bringSubviewToFront:self.rateViewManual];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
