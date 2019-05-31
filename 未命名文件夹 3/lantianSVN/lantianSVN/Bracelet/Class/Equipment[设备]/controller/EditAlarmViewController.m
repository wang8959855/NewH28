//
//  EditAlarmViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/21.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "EditAlarmViewController.h"
#import "XXPickerView.h"
#import "AlarmModel.h"
#import "XXDeviceInfomation.h"
#import "AlarmRepeatViewController.h"

@interface EditAlarmViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    XXPickerView *_pickerView; //选择器
    NSString *_hourString; //时
    NSString *_minuteString; //分
}

@property (nonatomic, strong) UIView *repeatView;

@property (nonatomic, strong) UIView *nameView;

@property (nonatomic, weak) UILabel *repeatLabel;

@property (nonatomic, strong) UITextField *nameTF;

@end



@implementation EditAlarmViewController

#pragma mark - viewDidLoad入口
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:kmainBackgroundColor];
    
    [self loadUI];
    
    
    

}

- (void)loadUI
{
    [self initPickViewWithDictionary:self.alarmModel];

    [self addNavWithTitle:NSLocalizedString(@"编辑闹钟",nil) backButton:YES shareButton:NO];

    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitle:NSLocalizedString(@"储存",nil) forState:UIControlStateNormal];
    [sureButton sizeToFit];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    sureButton.frame = CGRectMake(ScreenW - sureButton.width - 20, 7 + StatusBarHeight, sureButton.width, 30);
    
    
    _repeatView = [[UIView alloc] init];
    _repeatView.backgroundColor = kmainLightColor;
    [self.view addSubview:_repeatView];
    _repeatView.sd_layout.topSpaceToView(_pickerView, 70 * kX)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(42 * kX);
    
    UILabel *repeatNameLabel = [[UILabel alloc] init];
    repeatNameLabel.text= NSLocalizedString(@"重复",nil);
    repeatNameLabel.textColor = kmaintextGrayColor;
    [repeatNameLabel sizeToFit];
    [_repeatView addSubview:repeatNameLabel];
    repeatNameLabel.sd_layout.leftSpaceToView(_repeatView, 20 * kX)
    .centerYIs(_repeatView.height/2.)
    .widthIs(repeatNameLabel.width)
    .heightIs(20);
    
    _nameView = [[UIView alloc] init];
    _nameView.backgroundColor = kmainLightColor;
    [self.view addSubview:_nameView];
    _nameView.sd_layout.topSpaceToView(_repeatView, 15 * kX)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(42 * kX);
    
    _nameTF = [[UITextField alloc] init];
    _nameTF.textColor = [UIColor whiteColor];
    _nameTF.textAlignment = NSTextAlignmentRight;
    _nameTF.borderStyle = UITextBorderStyleNone;
    _nameTF.layer.borderWidth = 1.;
    _nameTF.layer.borderColor = [UIColor whiteColor].CGColor;
    [_nameView addSubview:_nameTF];
    _nameTF.sd_layout.rightSpaceToView(_nameView, 17 * kX)
    .centerYIs(_nameView.height / 2.)
    .widthIs(160)
    .heightIs(30);
    
    
    UILabel *tipNameLabel = [[UILabel alloc] init];
    tipNameLabel.textColor = kmaintextGrayColor;
    tipNameLabel.text = NSLocalizedString(@"标签",nil);
    [tipNameLabel sizeToFit];
    [_nameView addSubview:tipNameLabel];
    tipNameLabel.sd_layout.leftSpaceToView(_nameView, 20 * kX)
    .centerYIs(_nameView.height / 2.)
    .widthIs(tipNameLabel.width)
    .heightIs(20);
    
    [self initRepeatViewWithRepeat:self.alarmModel.repeats];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 布局

- (void)initRepeatViewWithRepeat:(int)repeat
{

    NSMutableString *repeatString = [NSMutableString string];
    if ((repeat & 0xFE) == 0xFE) {
        
        [repeatString appendString:NSLocalizedString(@"每天", nil)];
    }
    else if (repeat == 0x00 || repeat == 0x01){
        
        [repeatString appendString:NSLocalizedString(@"从不", nil)];
    }
    else
    {
        NSArray * array = @[NSLocalizedString(@"周一",nil),NSLocalizedString(@"周二",nil),NSLocalizedString(@"周三",nil),NSLocalizedString(@"周四",nil),NSLocalizedString(@"周五",nil),NSLocalizedString(@"周六",nil),NSLocalizedString(@"周日",nil)];
        
        for (int i = 1; i < 8; i++) {
            NSUInteger selectedValue = (repeat >> i) & 0x01;
            if (selectedValue) {
                [repeatString appendString:array[i - 1]];
                [repeatString appendString:@" "];
            }
        }
    }
    [repeatString appendString:@" >"];
    self.repeatLabel.text = repeatString;
}

- (void)initPickViewWithDictionary:(AlarmModel *)model
{
    _pickerView = [[XXPickerView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 180)];
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    // Update center view color
    [_pickerView setBackgroundColor:kmainLightColor];
    [_pickerView setupCenterViewColor:kmainLightColor];
    [self.view addSubview:_pickerView];
    
    // Select row
    [_pickerView.mPickerView selectRow:self.alarmModel.hour inComponent:0 animated:YES];
    [_pickerView.mPickerView selectRow:self.alarmModel.minute inComponent:1 animated:YES];
    _hourString = [NSString stringWithFormat:@"%d",self.alarmModel.hour];
    _minuteString = [NSString stringWithFormat:@"%d",self.alarmModel.minute];
    
//    _pickerView.sd_layout.topSpaceToView(self.view, 64 + 14 * kX)
//    .leftEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .heightIs(180);
}


#pragma mark - navigation

- (void)clickSure
{

    self.alarmModel.hour = [_hourString intValue];
    self.alarmModel.minute = _minuteString.intValue;
    self.alarmModel.state = 1;
    
    if (self.alarmModel.repeats == 0) {
        //给当日
        NSString *week = [[TimeCallManager getInstance] getCurrnetWeek];
        NSArray * array = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        
        for (int i = 1; i < 8; i++) {
            if ([array[i-1] isEqualToString:week]) {
                self.alarmModel.repeats = 0x01 << i;
            }
        }
    }
    
    [[PZBlueToothManager sharedInstance] setAlarmWithAlarmID:self.alarmModel.idNum State:self.alarmModel.state Hour:self.alarmModel.hour Minute:self.alarmModel.minute Repeat:self.alarmModel.repeats];
    
    [[PZBlueToothManager sharedInstance] setAlarmNameWithAlarmID:self.alarmModel.idNum Name:_nameTF.text];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerViewDataSource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor whiteColor];
        }
    }
    
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = [UIColor whiteColor];
    genderLabel.text = [NSString stringWithFormat:@"%02ld",(long)row];
    return genderLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0 ) {
        
        return 24;
    }
    else {
        
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%02ld",(long)row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}



//在这里对选择的数据进行处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        _hourString = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    else if(component == 1){
        
        _minuteString = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
}

#pragma mark -- GET
- (UILabel *)repeatLabel
{
    if (!_repeatLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:13];
        
        [_repeatView addSubview:label];
        _repeatLabel = label;
        _repeatLabel.sd_layout.rightSpaceToView(_repeatView, 17 * kX)
        .centerYIs(_repeatView.height/2.)
        .widthIs(self.view.width)
        .heightIs(25);
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(chooseRepeat) forControlEvents:UIControlEventTouchUpInside];
        [_repeatView addSubview:button];
        button.frame = CGRectMake(0, 0, self.view.width, _repeatView.height);
    }
    return _repeatLabel;
}

#pragma mark - action


- (void)chooseRepeat
{
    AlarmRepeatViewController *repeatVC = [[AlarmRepeatViewController alloc]init];
    repeatVC.repeat = self.alarmModel.repeats;
    kWEAKSELF;
    repeatVC.block = ^(int repeat) {
        self.alarmModel.repeats = repeat;
        [weakSelf initRepeatViewWithRepeat:repeat];
    };
    [self.navigationController pushViewController:repeatVC animated:YES];
}

- (void)selectDateButton:(UIButton *)button
{
    button.selected = !button.selected;
    
    int selectedValue = 0x01 << button.tag;
    int newValue = self.alarmModel.repeats ^ selectedValue;
    self.alarmModel.repeats = newValue;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
