//
//  AlertMainView.m
//  Wukong
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "AlertMainView.h"

@interface AlertMainView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UIButton *notAlertButton;
@property (nonatomic, assign) AlertMainViewType type;

//alert2
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *messageArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;


@end

@implementation AlertMainView

+ (AlertMainView *)alertMainViewWithType:(AlertMainViewType)type{
    AlertMainView *v = [[NSBundle mainBundle] loadNibNamed:@"AlertMainView" owner:self options:nil].firstObject;
    v.frame = [UIScreen mainScreen].bounds;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.type = type;
    if (type == AlertMainViewTypeTest) {
        v.message.text = @"健康监测模块分为“血压”、“脏腑”、“睡眠”三大监测系统，点击任一系统，即可进入相应页面。每个系统分别显示相关的主要生理参数，采集计算频率为秒，实时分析动态健康参数，反映动态健康趋势";
    }else if (type == AlertMainViewTypePolice){
        v.message.text = @"设置“饮酒监测、加班监测、运动监测”单次定制区的目的是为用户提供特殊场景的实时监测服务，防止因饮酒过量、加班疲劳过度、运动过度引发猝死风险。系统默认单次定制监测时间为2小时，如不点击定制“饮酒监测”、“运动监测”、“加班监测”，系统处于24小时自动监测默认状态。";
    }else if (type == AlertMainViewTypeRegulation){
        v.message.text = @"健康报告模块主要呈现十二项健康参数和各类健康数据周期报告，分别为定位信息、当前周期报告、日周期报告、周周期报告、月周期报告、年周期报告等。每项生理参数采集计算频率为分，实时分析连续、周期健康参数，反映周期健康趋势。";
    }
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    return v;
}


#pragma mark - alert2
+ (AlertMainView *)alertMainViewWithArray:(NSArray *)array{
    AlertMainView *v = [[NSBundle mainBundle] loadNibNamed:@"AlertMainView" owner:self options:nil].lastObject;
    v.frame = [UIScreen mainScreen].bounds;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.messageArr = array;
    [v setSubViews2];
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    return v;
}

- (void)setSubViews2{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat height = 0;
    for (NSString *str in self.messageArr) {
        CGRect rect = [[NSString stringWithFormat:@"        %@",str] boundingRectWithSize:CGSizeMake(ScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        height += rect.size.height;
    }
    self.tableHeight.constant = height+7*self.messageArr.count;
}

//知道了
- (IBAction)okAction:(UIButton *)sender {
    if (self.notAlertButton.selected == YES) {
        if (self.type == AlertMainViewTypeTest) {
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isAlertTest"];
        }else if (self.type == AlertMainViewTypePolice){
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isAlertPolice"];
        }else if (self.type == AlertMainViewTypeRegulation){
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"isAlertRegulation"];
        }
    }
    [self removeFromSuperview];
}

//不在提醒
- (IBAction)notAlertAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect rect = [[NSString stringWithFormat:@"        %@",self.messageArr[indexPath.row]] boundingRectWithSize:CGSizeMake(ScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth-90, rect.size.height)];
    titleLable.numberOfLines = 0;
    titleLable.text = [NSString stringWithFormat:@"        %@",self.messageArr[indexPath.row]];
    titleLable.textColor = kColor(26, 160, 230);
    titleLable.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:titleLable];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGRect rect = [[NSString stringWithFormat:@"        %@",self.messageArr[indexPath.row]] boundingRectWithSize:CGSizeMake(ScreenWidth-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height+self.messageArr.count;
}

@end
