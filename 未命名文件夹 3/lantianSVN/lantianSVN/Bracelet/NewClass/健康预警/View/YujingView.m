//
//  YujingView.m
//  Bracelet
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "YujingView.h"

@interface YujingView ()

@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UILabel *switchTitle;

@end

@implementation YujingView

+ (YujingView *)yujingViewWithNoti:(BOOL)noti{
    YujingView *v = [[NSBundle mainBundle] loadNibNamed:@"YujingView" owner:self options:nil].lastObject;
    v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    v.frame = [UIScreen mainScreen].bounds;
    v.switchButton.selected = noti;
    if (noti) {
        v.switchTitle.text = @"预警通知开启";
    }else{
        v.switchTitle.text = @"预警通知关闭";
    }
    [[UIApplication sharedApplication].keyWindow addSubview:v];
    return v;
}

- (IBAction)switchButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",CUSTOMWARING,TOKEN];
    NSDictionary *para = @{@"userid":USERID,@"warn":@(sender.selected)};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateWarn" object:nil];
            if (sender.selected) {
                self.switchTitle.text = @"预警通知开启";
            }else{
                self.switchTitle.text = @"预警通知关闭";
            }
        }else{
            sender.selected = !sender.selected;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

@end
