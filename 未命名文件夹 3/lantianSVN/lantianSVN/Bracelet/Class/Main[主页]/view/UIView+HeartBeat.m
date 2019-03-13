//
//  UIView+HeartBeat.m
//  XYZKitDemo
//
//  Created by 谢英泽 on 2016/11/20.
//  Copyright © 2016年 谢英泽. All rights reserved.
//

#import "UIView+HeartBeat.h"

@implementation UIView (HeartBeat)

- (void)heartBeat:(id)repeatTimes
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values =  @[@(1.0),@(1.1),@(1.0),@(0.9)];
    animation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    animation.duration = 0.8;
    animation.removedOnCompletion = YES;
    
    //当repeatTimes为999时为循环 animation.repeatCount = HUGE_VALF;
    if (repeatTimes == nil) {
        animation.repeatCount = 2;
    }else{
        
        if ([repeatTimes intValue] == 999) {
            animation.repeatCount = HUGE_VALF;
        }else{
            animation.repeatCount = [repeatTimes intValue];
        }
    }
    
    [self.layer addAnimation:animation forKey:@"SHOW"];
}

- (void)stopHeartBeat
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values =  @[@(1.0),@(1.0),@(1.0),@(1.0)];
    animation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    animation.duration = 0.25;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    
    [self.layer addAnimation:animation forKey:@"SHOW"];
}

@end
