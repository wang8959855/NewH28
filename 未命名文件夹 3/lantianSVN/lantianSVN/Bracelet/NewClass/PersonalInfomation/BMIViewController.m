//
//  BMIViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/3.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "BMIViewController.h"

@interface BMIViewController ()

@end

@implementation BMIViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_isRegister)
    {
        _backButton.hidden = YES;
        _backButtonBig.hidden = YES;
    }
    [self setXibLabel];
    
    NSArray *array = @[@"偏瘦.png",NSLocalizedString(@"偏瘦", nil), kColor(248,57,107),
                       @"正常.png",NSLocalizedString(@"正常", nil), kColor(4,231,242),
                       @"超重.png",NSLocalizedString(@"超重", nil), kColor(252,179,84),
                       @"肥胖.png",NSLocalizedString(@"肥胖", nil),kColor(248,57,107)];
    float BMI = _weight*10000.0/_height/_height;
    float minWeight = 18.5*_height*_height/10000;
    float maxWeight = 25 * _height *_height/10000;
    _weightArea.text = [NSString stringWithFormat:@"%.1fkg-%.1fkg",minWeight,maxWeight];
    
    _textView.layer.borderColor = kColor(167, 211, 235).CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 85/2.;
    
    if (BMI < 18.5)
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        [self.BMIButton setTitleColor:array[2] forState:UIControlStateNormal];
        [self.BMIButton setImage:[UIImage imageNamed:array[0]] forState:UIControlStateNormal];
        self.stateLabel.text = array[1];
        self.stateLabel.textColor = array[2];
        
    }else if (BMI < 25)
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        [self.BMIButton setTitleColor:array[5] forState:UIControlStateNormal];
        [self.BMIButton setImage:[UIImage imageNamed:array[3]] forState:UIControlStateNormal];

        self.stateLabel.text = array[4];
        self.stateLabel.textColor = array[5];
    }else if(BMI < 30)
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        [self.BMIButton setTitleColor:array[8] forState:UIControlStateNormal];
        [self.BMIButton setImage:[UIImage imageNamed:array[6]] forState:UIControlStateNormal];

        self.stateLabel.text = array[7];
        self.stateLabel.textColor = array[8];
    }else
    {
        [self.BMIButton setTitle:[NSString stringWithFormat:@"%.0f",BMI] forState:UIControlStateNormal];
        [self.BMIButton setTitleColor:array[11] forState:UIControlStateNormal];
        [self.BMIButton setImage:[UIImage imageNamed:array[9]] forState:UIControlStateNormal];

        self.stateLabel.text = array[10];
        self.stateLabel.textColor = array[11];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)setXibLabel
{
    _titleLabel.text = @"个人资料";

    _kStandardBMI.text = @"标准BMI范围";
    _fanweiLabel.text = NSLocalizedString(@"健康体重范围", nil);
    _informationLabel.text = NSLocalizedString(@"为了您的身体健康，请制定合理的饮食习惯！", nil);
    [_okBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
}

- (IBAction)goBackClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changeMainNofication object:nil];
}

- (IBAction)okBtnClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changeMainNofication object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
