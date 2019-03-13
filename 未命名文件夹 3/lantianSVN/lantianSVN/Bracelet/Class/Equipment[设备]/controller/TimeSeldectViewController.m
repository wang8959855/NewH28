//
//  TimeSeldectViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/17.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "TimeSeldectViewController.h"
#import "XXPickerView.h"


@interface TimeSeldectViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) XXPickerView *pickerView;

@end

@implementation TimeSeldectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}

- (void)loadUI
{
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:NSLocalizedString(@"储存",nil) forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton sizeToFit];
    [sureButton addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    sureButton.frame = CGRectMake(ScreenW - sureButton.width - 20, 7 + 20, sureButton.width, 30);
    [self initPickView];
    [self addNavWithTitle:NSLocalizedString(@"时间设置",nil) backButton:YES shareButton:NO];

}

- (void)initPickView
{
    _pickerView = [[XXPickerView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 180)];
    
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    // Update center view color
    [_pickerView setBackgroundColor:kmainLightColor];
    [_pickerView setupCenterViewColor:kmainLightColor];
    [self.view addSubview:_pickerView];
    
    // Select row
    [_pickerView.mPickerView selectRow:_hour inComponent:1 animated:YES];
    [_pickerView.mPickerView selectRow:_min inComponent:2 animated:YES];

}

- (void)clickSure
{
    self.block(_hour, _min);
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
    if (component == 1 || component == 2)
    {
        genderLabel.text = [NSString stringWithFormat:@"%02ld",(long)row];
    }else {
        genderLabel.text = _titleString;
    }
    return genderLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 1;
    }else
    if (component == 1 ) {
        
        return 24;
    }
    else if (component == 2)
    {
        return 60;
    }else
    {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _titleString;
    }else if (component == 3)
    {
        return nil;
    }else
    return [NSString stringWithFormat:@"%02ld",(long)row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1) {
        _hour = [[self pickerView:pickerView titleForRow:row forComponent:1]intValue];
    }
    else if(component == 2){
        
        _min = [[self pickerView:pickerView titleForRow:row forComponent:1]intValue];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
