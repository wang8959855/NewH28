//
//  TargetViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/23.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "TargetViewController.h"
#import "XXPickerView.h"


@interface TargetViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, weak) UILabel *stepLabel;

@property (nonatomic, weak) UILabel *sleepLabel;

@property (nonatomic, weak) UIView *clearBackView;

@property (nonatomic, weak) XXPickerView *pickerView;

@property (nonatomic, assign) BOOL isStep;
@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"目标编辑",nil) backButton:YES shareButton:NO];
    NSArray *imageNameArray = @[@"targetStep",@"targetSleep"];
    for (int i = 0; i < 2; i ++)
    {
        UIView *backView = [[UIView alloc] init];
        [self.view addSubview:backView];
        backView.sd_layout.topSpaceToView(self.view, 64 + 65 * kX * i)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(65 * kX);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        [backView addSubview:imageView];
        imageView.sd_layout.leftSpaceToView(backView, 20 * kX)
        .centerYIs(backView.height / 2.)
        .widthIs(55 * kX)
        .heightIs(55 * kX);
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor grayColor];
        [backView addSubview:line];
        line.sd_layout.bottomEqualToView(backView)
        .leftSpaceToView(backView, 15 * kX)
        .rightSpaceToView(backView, 15 * kX)
        .heightIs(0.5);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"8000";
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        [backView addSubview:label];
        label.sd_layout.rightSpaceToView(backView, 50 * kX)
        .centerYIs(backView.height/2.)
        .widthIs(200)
        .heightIs(30);
        
        if (i == 0)
        {
            _stepLabel = label;
            _stepLabel.text = [XXUserInformation userSportTarget];
        }else
        {
            
            _sleepLabel = label;
            _sleepLabel.text = [NSString stringWithFormat:@"%@h%@min",[XXUserInformation userSleepHourTarget], [XXUserInformation userSleepMinuteTarget]];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:button];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.sd_layout.topEqualToView(backView)
        .bottomEqualToView(backView)
        .leftEqualToView(backView)
        .rightEqualToView(backView);
    }
}

- (void)chooseButtonClick:(UIButton *)button
{
    if (!_clearBackView)
    {
        if (button.tag == 100)
        {
            _isStep = YES;
        }else
        {
            _isStep = NO;
        }
        
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
        if (_isStep)
        {
            int value = [[XXUserInformation userSportTarget] intValue];
            [picker.mPickerView selectRow:value/1000 - 1 inComponent:0 animated:NO];
        }else
        {
            int hour = [[XXUserInformation userSleepHourTarget] intValue];
            int min = [[XXUserInformation userSleepMinuteTarget] intValue];
            [picker.mPickerView selectRow:hour inComponent:0 animated:NO];
            [picker.mPickerView selectRow:min inComponent:2 animated:NO];
        }
        
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
        if (_isStep)
        {
            titleLabel.text = NSLocalizedString(@"步数",nil);
        }else
        {
            titleLabel.text = NSLocalizedString(@"睡眠",nil);
        }
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
    
    if (_isStep)
    {
        NSInteger row = [_pickerView.mPickerView selectedRowInComponent:0];
        self.stepLabel.text = [NSString stringWithFormat:@"%ld",(row + 1) * 1000];
        [XXUserInformation setUserSportTarget:self.stepLabel.text];
    }else{
        NSInteger hour = [_pickerView.mPickerView selectedRowInComponent:0];
        NSInteger min = [_pickerView.mPickerView selectedRowInComponent:2];
        [XXUserInformation setUserSleepHourTarget:[NSString stringWithFormat:@"%ld",hour]];
        [XXUserInformation setUserSleepMinuteTarget:[NSString stringWithFormat:@"%ld",min]];
        self.sleepLabel.text = [NSString stringWithFormat:@"%ldh%ldmin",hour,min];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_isStep)
    {
        return 1;
    }
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
    if (_isStep)
    {
        return 20;
    }else
    {
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
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_isStep)
    {
        return [NSString stringWithFormat:@"%ld",(row + 1) * 1000];
    }else
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
