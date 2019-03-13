//
//  JiuzuoViewController.m
//  Wukong
//
//  Created by 迈诺科技 on 16/5/18.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "JiuzuoViewController.h"
#import "SMTabbedSplitViewController.h"
#import "JiuzuoSetViewController1.h"
#import "JiuzuoMinuteListView.h"

@interface JiuzuoViewController ()

//延时时间
@property (weak, nonatomic) IBOutlet UILabel *DelayMinute;

//时间段
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@property (strong, nonatomic) SedentaryModel *model;

@end

@implementation JiuzuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setXibLabels];
}

- (void)setXibLabels
{
    _titleLabel.text = NSLocalizedString(@"久坐提醒", nil);
    _kJiuzuoShijianLabel.text = NSLocalizedString(@"久坐提醒时间段", nil);
}

- (void)dealloc{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getSedentaryWithSedentaryModelBlock:^(SedentaryModel *sedentaryModel) {
        weakSelf.model = sedentaryModel;
        [weakSelf setLabel];
    }];
}

#pragma mark -- ButtonAction
//选择时间段
- (IBAction)addBtnAction:(UIButton *)sender{
    JiuzuoSetViewController1 *jiu = [JiuzuoSetViewController1 new];
    jiu.model = self.model;
    [self.vc.navigationController pushViewController:jiu animated:YES];
    
    kWEAKSELF
    jiu.jiuzuoBlock = ^(SedentaryModel *model) {
        weakSelf.model = model;
        [weakSelf saveModel];
        [weakSelf setLabel];
    };
}
//选择延时
- (IBAction)SelectDelayAction:(UIButton *)sender {
    JiuzuoMinuteListView *delay = [JiuzuoMinuteListView jiuzuoMinuteListView];
    kWEAKSELF
    delay.jiuzuoDelay = ^(int delay) {
        weakSelf.model.timeInteval = delay;
        [weakSelf setLabel];
        [weakSelf saveModel];
    };
}

- (void)saveModel{
    [[PZBlueToothManager sharedInstance] setSedentaryWithSedentaryModel:self.model];
}

- (void)setLabel{
    self.periodLabel.text = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",self.model.beginHour,self.model.beginMin,self.model.endHour,self.model.endMin];
    self.DelayMinute.text = [NSString stringWithFormat:@"%dmin",self.model.timeInteval];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
