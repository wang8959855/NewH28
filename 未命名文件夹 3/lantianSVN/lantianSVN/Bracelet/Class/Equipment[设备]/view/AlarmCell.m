//
//  AlarmCell.m
//  Bracelet
//
//  Created by SZCE on 16/1/21.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "AlarmCell.h"
#import "XXDeviceInfomation.h"

//按钮的高度
#define kBUTTONHEIGHT 30
//按钮宽度
#define kBUTTONWIDTH 55
//动画时间
#define kANIMATIONDURATION 0.2

@interface AlarmCell ()
{
    //按钮的回调
    ActionButtonHandle actionButtonHandle;
   
    BeginSwipeHandle beginSwipeHandle;
    
    SwitchButtonHandle swithButtonHandle;
}

@property (nonatomic , weak) UIView *cellContentView;

@property (nonatomic, weak) UIButton *deleteBtn;

@property (nonatomic, weak) UISwitch *alarmSwitch;

@property (nonatomic, weak) UILabel *line;

@end

@implementation AlarmCell

#pragma mark - 懒加载
-(UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:NSLocalizedString(@"删除",nil) forState:UIControlStateNormal];
        [button setTitleColor:kmainBackgroundColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        [button addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cellContentView addSubview:button];
        _deleteBtn = button;
    }
    return _deleteBtn;
}

- (UISwitch *)alarmSwitch
{
    if (!_alarmSwitch)
    {
        UISwitch *sc = [[UISwitch alloc] init];
//        sc.tintColor = [UIColor whiteColor];
        sc.onTintColor = kMainColor;
        [sc addTarget:self action:@selector(swithValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.cellContentView addSubview:sc];
        _alarmSwitch = sc;
    }
    return _alarmSwitch;
}

- (UIView *)cellContentView
{
    if (!_cellContentView)
    {
        UIView *v = [[UIView alloc] init];
//        v.backgroundColor = kmainBackgroundColor;
        [self.contentView addSubview:v];
        
        _cellContentView = v;
    }
    
    return _cellContentView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"00:00";
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.font = [UIFont systemFontOfSize:25];
        [self.cellContentView addSubview:timeLabel];
        
        _timeLabel = timeLabel;
    }
    
    return _timeLabel;
}

- (UILabel *)cycleLabel
{
    if (!_cycleLabel)
    {
        UILabel *cycleLabel = [[UILabel alloc] init];
        cycleLabel.textColor = [UIColor blackColor];
        cycleLabel.font = [UIFont systemFontOfSize:12];
        [self.cellContentView addSubview:cycleLabel];
        
        _cycleLabel = cycleLabel;
    }
    
    return _cycleLabel;
}

- (UILabel *)line{
    if (!_line) {
        UILabel *line = [[UILabel alloc] init];
        line = [[UILabel alloc] init];
        line.backgroundColor = KCOLOR(201, 201, 201);
        [self.cellContentView addSubview:line];
        _line = line;
    }
    return _line;
}

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        //创建按钮
        [self deleteBtn];
        
        //添加手势
        [self addGestureRecognizerToCellContentView];
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        //创建按钮
        [self deleteBtn];
        //添加手势
        [self addGestureRecognizerToCellContentView];
    }
    
    return self;
}

#pragma mark - Setter
- (void)setModel:(AlarmModel *)model
{
    _model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",model.hour,model.minute];
    int repeatValue = model.repeats;
    
    self.alarmSwitch.on = model.state;
    
    NSMutableString *repeatString = [NSMutableString string];
    
    if ((repeatValue & 0xFE) == 0xFE) {
        
        [repeatString appendString:NSLocalizedString(@"每天", nil)];
    }
    else if (repeatValue == 0x00 || repeatValue == 0x01){
        
        [repeatString appendString:NSLocalizedString(@"从不", nil)];
    }
    else
    {
        NSArray * array = @[NSLocalizedString(@"周一",nil),NSLocalizedString(@"周二",nil),NSLocalizedString(@"周三",nil),NSLocalizedString(@"周四",nil),NSLocalizedString(@"周五",nil),NSLocalizedString(@"周六",nil),NSLocalizedString(@"周日",nil)];
        
        for (int i = 1; i < 8; i++) {
            NSUInteger selectedValue = (repeatValue >> i) & 0x01;
            if (selectedValue) {
                [repeatString appendString:array[i - 1]];
                [repeatString appendString:@" "];
            }
        }
    }
    self.cycleLabel.text = repeatString;
}

#pragma mark - selector
/**
 *  删除按钮点击事件
 *
 *  @param button <#button description#>
 */
- (void)deleteClick:(UIButton *)button
{
    actionButtonHandle(button,self);
}

/**
 *  开关按钮点击事件
 *
 *  @param button <#button description#>
 */


- (void)swithValueChanged:(UISwitch *)sw
{
    swithButtonHandle(sw,self);
}

#pragma mark - 手势相关
/**
 *  cellContentView添加拖动手势
 */
- (void)addGestureRecognizerToCellContentView
{
    //添加拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    [self.cellContentView addGestureRecognizer:pan];
}

/**
 *  拖动手势触发
 *
 *  @param pan <#pan description#>
 */
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    //手势滑动开始
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        if (beginSwipeHandle)
        {
            beginSwipeHandle(self);
        }
    }
    //手势移动
    else
    {
        //1.获取移动的坐标
        CGPoint point = [pan translationInView:self.contentView];
//        adaLog(@"%@",NSStringFromCGPoint(point));
        
        //2.计算cellContent中心点的x
        CGFloat centerX = pan.view.center.x + point.x;
        
        //3.中心点限制。  原始的按钮的中心点x - kBUTTONWIDTH*2 < centerX <  原始的按钮的中心点x
        if (centerX >= self.contentView.center.x)
        {
            centerX = self.contentView.center.x;
        }
        else if(centerX <= self.contentView.center.x - 88 * kX)
        {
            centerX = self.contentView.center.x - 88 * kX;
        }
        
        //4.修改cellContentView的中心点
        pan.view.center = CGPointMake(centerX, pan.view.center.y);
        
        //5.清除叠加值
        [pan setTranslation:CGPointZero inView:self.contentView];
        
        //6.滑动停止的时候监测中心点坐标，如果中心点移动的位置小于一个按钮的宽度，直接还原。否则，展开。
        if (pan.state == UIGestureRecognizerStateEnded)
        {
            if (centerX >= self.contentView.center.x - 80 *kX)
            {
                [UIView animateWithDuration:kANIMATIONDURATION animations:^{
                    self.cellContentView.center = self.contentView.center;
                }];
            }
            else
            {
                [UIView animateWithDuration:kANIMATIONDURATION animations:^{
                    self.cellContentView.center = CGPointMake(self.contentView.center.x - 88 * kX, self.cellContentView.center.y);
                }];
            }
        }
    }

}

/**
 *  设置按钮
 *
 *  @param handle    按钮点击的回调
 */
- (void)addActionButtonHandle:(ActionButtonHandle)handle
{
    actionButtonHandle = handle;
}

//设置开始拖动的回调
- (void)setBeginSwipeHandle:(BeginSwipeHandle)handle
{
    beginSwipeHandle = handle;
}

- (void)setSwithButtonHandle:(SwitchButtonHandle)handle
{
    swithButtonHandle = handle;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        //获取手势对象
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        
        //获取移动的坐标
        CGPoint point = [pan translationInView:self.contentView];
        
        //adaLog(@"-- %@",NSStringFromCGPoint(point));
        
        //如果point.x绝对值 > point.y 手势能响应。否则tableView滚动
        if (ABS(point.y) > ABS(point.x) )
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellContentView.frame = CGRectMake(0, 1, self.contentView.width, self.contentView.height - 2);
    
    self.deleteBtn.frame = CGRectMake(self.contentView.frame.size.width , 0, 88 * kX, self.cellContentView.height);
    
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(15, 0, self.timeLabel.width, self.cellContentView.frame.size.height);
    
    self.line.frame = CGRectMake(0, self.cellContentView.height-1, self.cellContentView.width, 1);
    
    self.cycleLabel.frame = CGRectMake(self.timeLabel.maxX + 20, 0, 200, self.cellContentView.frame.size.height);
    self.cycleLabel.sd_layout.bottomSpaceToView(self.cellContentView, 10 * kX)
    .leftSpaceToView(self.cellContentView, 80 * kX)
    .widthIs(self.cellContentView.width - 80 * kX)
    .heightIs(28);
    
    self.alarmSwitch.sd_layout.rightSpaceToView(self.cellContentView, 20 * kX)
    .centerYIs(self.cellContentView.height/2.);
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    adaLog(@"%@",NSStringFromCGPoint(point));
    UIView * view = [super hitTest:point withEvent:event];
    if (view) {
        // 转换坐标系
        CGPoint newPoint = [self.deleteBtn convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.deleteBtn.bounds, newPoint)) {
            view = self.deleteBtn;
        }
    }
    return view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
