//
//  TimeIntervelViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/6/27.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "TimeIntervelViewController.h"
#import "XXPickerView.h"

@interface TimeIntervelViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) XXPickerView *pickerView;


@end

@implementation TimeIntervelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];

}

- (void)loadUI
{
    [self initPickView];
    [self addNavWithTitle:NSLocalizedString(@"测试频率",nil) backButton:YES shareButton:NO];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitle:NSLocalizedString(@"储存",nil) forState:UIControlStateNormal];
    [sureButton sizeToFit];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    sureButton.frame = CGRectMake(ScreenW - sureButton.width - 20, 7 + 20, sureButton.width, 30);
}

- (void)clickSure
{
    if (self.block)
    {
        self.block(_min);
    }
    int num = 0;
    if (_min == 2) {
        num = 3;
    }else{
        num = _min;
    }
    [[PZBlueToothManager sharedInstance] setHeartRateTimeWithTime:num];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTimer" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

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
    NSArray *timeArray = @[@"2",@"5",@"10"];
    if (component == 1)
    {
        genderLabel.text = timeArray[row];
    }else if (component == 2)
    {
        genderLabel.text = NSLocalizedString(@"分钟", nil);
    }
    return genderLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

        if (component == 1 ) {
            
            return 3;
        }
        else if (component == 2)
        {
            return 1;
        }else
        {
            return 0;
        }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0)
//    {
//        return _titleString;
//    }else if (component == 3)
//    {
//        return nil;
//    }else
//        return [NSString stringWithFormat:@"%02ld",(long)row];
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *timeArray = @[@"2",@"5",@"10"];
    
    _min = [timeArray[row] intValue];
    adaLog(@"%d",_min);
}


- (void)initPickView
{
    _pickerView = [[XXPickerView alloc] init];
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    // Update center view color
    [_pickerView setBackgroundColor:kmainLightColor];
    [_pickerView setupCenterViewColor:kmainLightColor];
    int row = 0;
    if (_min == 5)
    {
        row = 1;
    }else if (_min == 10)
    {
        row = 2;
    }else if (_min == 30)
    {
        row = 3;
    }else if (_min == 60)
    {
        row = 4;
    }else if (_min == 120)
    {
        row = 5;
    }
    [_pickerView.mPickerView selectRow:row inComponent:1 animated:YES];
    [self.view addSubview:_pickerView];
    
    // Select row
    _pickerView.sd_layout.yIs(64)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(180);
    
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
