//
//  JiuzuoMinuteListView.m
//  Bracelet
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "JiuzuoMinuteListView.h"

@implementation JiuzuoMinuteListView

+ (JiuzuoMinuteListView *)jiuzuoMinuteListView{
    JiuzuoMinuteListView *v = [[NSBundle mainBundle] loadNibNamed:@"JiuzuoMinuteListView" owner:self options:nil].lastObject;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    return v;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

- (IBAction)selectDelatyAction:(UIButton *)sender {
    int minute = 0;
    switch (sender.tag) {
        case 0:
            minute = 0;
            break;
        case 1:
            minute = 30;
            break;
        case 2:
            minute = 60;
            break;
        case 3:
            minute = 90;
            break;
        case 4:
            minute = 120;
            break;
        case 5:
            minute = 150;
            break;
    }
    if (self.jiuzuoDelay) {
        self.jiuzuoDelay(minute);
    }
    [self removeFromSuperview];
}


@end
