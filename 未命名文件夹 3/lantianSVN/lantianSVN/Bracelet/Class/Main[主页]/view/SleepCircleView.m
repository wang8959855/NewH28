//
//  SleepCircleView.m
//  Bracelet
//
//  Created by panzheng on 2017/5/11.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "SleepCircleView.h"


@implementation SleepCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addTimeBack];
        [self addTime];
    }
    return self;
}

- (void)addTimeBack
{
    UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                           radius:self.width / 2.
                                                       startAngle:-M_PI_2
                                                         endAngle:M_PI_2*3
                                                        clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 20 * kX;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = kmainDarkColor.CGColor;
    shapeLayer.path = bezPath.CGPath;
    [self.layer addSublayer:shapeLayer];
    
    UIBezierPath *bezPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                           radius:self.width / 2. - 14 * kX
                                                       startAngle:-M_PI_2
                                                         endAngle:M_PI_2*3
                                                        clockwise:YES];
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.lineWidth = 4 * kX;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.strokeColor = kmainDarkColor.CGColor;
    shapeLayer2.path = bezPath2.CGPath;
    [self.layer addSublayer:shapeLayer2];
    
    UIBezierPath *bezPath3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                            radius:self.width / 2. - 31 * kX
                                                        startAngle:-M_PI_2
                                                          endAngle:M_PI_2*3
                                                         clockwise:YES];
    CAShapeLayer *shapeLayer3 = [CAShapeLayer layer];
    shapeLayer3.lineWidth = 18 * kX;
    shapeLayer3.fillColor = [UIColor clearColor].CGColor;
    shapeLayer3.strokeColor = kmainAwakeSleep.CGColor;
    shapeLayer3.path = bezPath3.CGPath;
    [self.layer addSublayer:shapeLayer3];
}

- (void)setModel:(oneDaySleepModel *)model
{
    int beginTime = model.beginTime;
    NSArray *sleepArray = [NSKeyedUnarchiver unarchiveObjectWithData:model.sleepData];
//    6点以前
    if (beginTime < 1080 )
    {
        beginTime += 1440;
    }
    CGFloat perAngle = 2*M_PI/144;
    for (int i = 0 ; i < sleepArray.count; i ++)
    {
        int sleepState = [sleepArray[i] intValue];
        
        UIColor *color;
        switch (sleepState)
        {
            case 0x13:
//                color = KCOLOR(31, 131, 124);
                color = kmainLightColor;

                break;
            case 0x14:
//                color = KCOLOR(20, 96, 92);
                color = kmainDeepSleep;

                break;
            default:
                continue;
                break;
        }
        
        CGFloat startAngle = (- M_PI + (beginTime + i * 10 - 1080)/10 *perAngle);
        CGFloat endAngle = startAngle+2 * M_PI/144 + 2 * M_PI/1000;
        
        UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                               radius:self.width / 2. - 31 * kX
                                 
                                                           startAngle:startAngle
                                                             endAngle:endAngle
                                                            clockwise:YES];
               CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.lineWidth = 18 * kX;
        shapeLayer.path = bezPath.CGPath;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:shapeLayer];
    }
}


- (void)addTime
{
    CGFloat perAngle = M_PI/12;
    
    NSArray *array = @[@"24",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22"];
    for (int i = 0; i < 24; i++) {
        
        CGFloat startAngle = (-M_PI_2+perAngle*i);
        CGFloat endAngle = startAngle+M_PI/360;
        
        UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                               radius:self.width / 2.

                                                           startAngle:startAngle
                                                             endAngle:endAngle
                                                            clockwise:YES];
        if (i%2 == 1)
        {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
            shapeLayer.lineWidth = 10;
            shapeLayer.path = bezPath.CGPath;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            [self.layer addSublayer:shapeLayer];
            
        }else
        {
            NSString *tickText = array[i / 2];
            CGFloat textAngel = startAngle+(endAngle-startAngle)/2;
            CGPoint point = [self calculateTextPositonWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                              Angle:textAngel];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y, 18, 12)];
            label.center = point;
            label.text = tickText;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:8];
            label.textAlignment = NSTextAlignmentCenter;
            label.transform = CGAffineTransformRotate(CGAffineTransformIdentity, i* 15 * M_PI/180.);
            [self addSubview:label];
        }
    }
}

- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = self.width/2. * cosf(angel);
    CGFloat y = self.width/2. * sinf(angel);
    
    return CGPointMake(center.x + x, center.y + y);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
