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
#import "NightCircleView.h"
#import "HelpSleepViewController.h"

@interface MainSleepViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,NightCircleViewDelegate>

@property (nonatomic, weak) SleepCircleView *sleepCircle;

@property (nonatomic, weak) oneDaySleepModel *sleepModel;

@property (nonatomic, weak) UILabel *totalSleepLabel;

@property (nonatomic, strong) UILabel *deepSleepLabel;

@property (nonatomic, strong) UILabel *lightSleepLabel;

@property (nonatomic, strong) UILabel *awakeLabel;

@property (nonatomic, weak) UIView *backView;

@property (nonatomic, weak) XXPickerView *pickerView;
@property (nonatomic, weak) UIView *clearBackView;

@property (strong, nonatomic) NightCircleView *circle;


//选择显示类型的view
@property (nonatomic, strong) UIView *selectShowTypeView;
//睡觉
@property (nonatomic, strong) UIButton *sleepButton;
//助眠
@property (nonatomic, strong) UIButton *helpSleepButton;

@end

@implementation MainSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HistoryDataModel *model = [[HistoryDataModel alloc] init];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenH/2+42+20)];
    bgView.backgroundColor = kMainColor;
    [self.view addSubview:bgView];
    
    [self loadUI];
    
    kWEAKSELF;
    [model getOneDaySleepWithTimeSeconds:kHCH.todayTimeSeconds Completion:^(oneDaySleepModel *model) {
        if (model)
        {
//            weakSelf.sleepCircle.model = model;
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
    [self backView];
    
    
    self.circle = [[NightCircleView alloc] init];
    [self.view addSubview:self.circle];
    self.circle.frame = CGRectMake(0, 0, MIN(203 * kX, 203 * kDY), MIN(203 * kX, 203 * kDY));
    self.circle.center = CGPointMake(CurrentDeviceWidth / 2, SafeAreaTopHeight+42+20+40 * kDY + self.circle.height/2.);
    self.circle.backgroundColor = [UIColor clearColor];
    
    self.circle.minValue = 0;
    self.circle.maxValue = [[XXUserInformation userSleepHourTarget] integerValue]*60;
    self.circle.startAngle = 3./2 * M_PI + M_PI/3600.;
    self.circle.endAngle = 3./2 * M_PI;
    self.circle.ringBackgroundColor = [UIColor whiteColor];
    self.circle.valueTextColor = [UIColor whiteColor];
    self.circle.ringThickness = MIN(16 * kX, 16 * kDY);
    self.circle.delegate = self;
    self.circle.value = 0;
    [self.circle setNeedsDisplay];
    
    UIButton *detailButton = [[UIButton alloc]init];
    [self.circle addSubview:detailButton];
    detailButton.backgroundColor = [UIColor clearColor];//detailButton.alpha = 0.5;
    [detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    CGFloat detailButtonX = 0;
    CGFloat detailButtonY = 0;
    CGFloat detailButtonW = MIN(203 * kX, 203 * kDY) * WidthProportion;
    CGFloat detailButtonH = MIN(203 * kX, 203 * kDY) * HeightProportion;
    detailButton.frame = CGRectMake(detailButtonX, detailButtonY, detailButtonW, detailButtonH);
    
    
    //    设置目标按钮
    self.targetBtn = [[UIButton alloc] init];
    self.targetBtn.size = CGSizeMake(180*kX, 35*kDY);
    self.targetBtn.center = CGPointMake(CurrentDeviceWidth/2., self.circle.bottom + 30 * kX);
    [self.view addSubview:self.targetBtn];
    self.targetBtn.layer.cornerRadius = 8*kDY;
    [self.targetBtn setImage:[UIImage imageNamed:@"target1"] forState:UIControlStateNormal];
    
    [self.targetBtn setAttributedTitle:[self makeAttributedStringWithnumBer:[NSString stringWithFormat:@"%@h",[XXUserInformation userSleepHourTarget]] Unit:@"(目标睡眠)" WithFont:18] forState:UIControlStateNormal];
    
    [self.targetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.targetBtn.titleLabel.textColor = allColorWhite;
    [self.targetBtn addTarget:self action:@selector(targetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //selectShowTypeView
    _selectShowTypeView = [[UIView alloc] init];
    _selectShowTypeView.frame = CGRectMake(ScreenWidth/2-100, SafeAreaTopHeight+12+10, 200, 40);
    _selectShowTypeView.backgroundColor = kColor(214, 241, 251);
    [self.view addSubview:_selectShowTypeView];
    //    _selectShowTypeView.layer.borderWidth = 1;
    //    _selectShowTypeView.layer.borderColor = kColor(210, 210, 210).CGColor;
    _selectShowTypeView.layer.cornerRadius = 20.f;
    _selectShowTypeView.layer.masksToBounds = YES;
    
    //selectShowTypeView上的button
    _sleepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sleepButton.frame = CGRectMake(0, 0, 110, 40);
    [_sleepButton setTitle:@"睡眠" forState:UIControlStateNormal];
    [_sleepButton setBackgroundColor:kColor(40, 82, 251)];
    _sleepButton.layer.cornerRadius = 20.f;
    _sleepButton.layer.masksToBounds = YES;
    [_sleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_sleepButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_sleepButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    _sleepButton.selected = YES;
    [_selectShowTypeView addSubview:_sleepButton];
    
    _helpSleepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _helpSleepButton.frame = CGRectMake(90, 0, 110, 40);
    [_helpSleepButton setTitle:@"助眠" forState:UIControlStateNormal];
    _helpSleepButton.layer.cornerRadius = 20.f;
    _helpSleepButton.layer.masksToBounds = YES;
    [_helpSleepButton setBackgroundColor:[UIColor clearColor]];
    [_helpSleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_helpSleepButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_helpSleepButton addTarget:self action:@selector(changeShowView:) forControlEvents:UIControlEventTouchUpInside];
    [_selectShowTypeView addSubview:_helpSleepButton];
    
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

//切换视图
- (void)changeShowView:(UIButton *)button{
    if (button == _helpSleepButton) {
        HelpSleepViewController *sleep = [HelpSleepViewController new];
        sleep.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sleep animated:YES];
    }
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
    self.circle.maxValue = hour*60;
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
    self.circle.value = sleepModel.totalSleepTime+sleepModel.deepSleepTime+sleepModel.awakeSleepTime;
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
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        view.layer.borderColor = kMainColor.CGColor;
        view.layer.borderWidth = 0.5f;
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(10, self.view.height - 338*kDY + 100, ScreenWidth-20 , 200);
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        [self.view addSubview:view];
        _backView = view;
        
        UIImageView *jiedu = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        jiedu.image = [UIImage imageNamed:@"jiedu"];
        [view addSubview:jiedu];
        
        UILabel *jieduLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 100, 20)];
        jieduLabel.text = @"睡眠解读";
        jieduLabel.font = Font_Bold_String(13);
        [view addSubview:jieduLabel];
        
        UILabel *tixing = [[UILabel alloc] initWithFrame:CGRectMake(20, view.height-45, view.width-40, 40)];
        [view addSubview:tixing];
        tixing.numberOfLines = 0;
        tixing.font = [UIFont systemFontOfSize:11];
        tixing.text = @"*正常人睡眠时长是7-8小时，\n 其中深睡时长应达到总睡眠时长的25%。";
        tixing.textColor = kMainColor;
        
        NSArray *nameArray = @[NSLocalizedString(@"深睡",nil),NSLocalizedString(@"浅睡",nil),NSLocalizedString(@"清醒",nil)];
        NSArray *imageArray = @[@"深睡",@"浅睡",@"清醒"];
        for (int i = 0 ; i < 3; i ++)
        {
            
            UIImageView *sleepImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50+i*40, 25,25)];
            sleepImage.image = [UIImage imageNamed:imageArray[i]];
            [_backView addSubview:sleepImage];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = nameArray[i];
            [label sizeToFit];
            label.textColor = kMainColor;
            label.frame = CGRectMake(sleepImage.right + 3, sleepImage.top , 50, 25);
            [_backView addSubview:label];
            
            if (i == 0) {
                _deepSleepLabel = [[UILabel alloc] init];
                _deepSleepLabel.text = @"0h0min";
                _deepSleepLabel.textColor = kMainColor;
                _deepSleepLabel.textAlignment = NSTextAlignmentRight;
                _deepSleepLabel.frame = CGRectMake(_backView.width - 200 * kX, label.center.y-25, 187 * kX, 50 *kX);
                [_backView addSubview:_deepSleepLabel];
            }else if (i == 1){
                _lightSleepLabel = [[UILabel alloc] init];
                _lightSleepLabel.text = @"0h0min";
                _lightSleepLabel.textColor = kMainColor;
                _lightSleepLabel.textAlignment = NSTextAlignmentRight;
                _lightSleepLabel.frame = CGRectMake(_backView.width - 200 * kX, label.center.y-25 *kX, 187 * kX, 50 *kX);
                [_backView addSubview:_lightSleepLabel];
            }else if (i == 2){
                _awakeLabel = [[UILabel alloc] init];
                _awakeLabel.text = @"0h0min";
                _awakeLabel.textColor = kMainColor;
                _awakeLabel.textAlignment = NSTextAlignmentRight;
                _awakeLabel.frame = CGRectMake(_backView.width - 200 * kX, label.center.y-25  * kX, 187 * kX, 50 *kX);
                [_backView addSubview:_awakeLabel];
            }
            
        }
        
    }
    return _backView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
