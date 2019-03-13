//
//  BaseView.m
//  Bracelet
//
//  Created by apple on 2018/8/12.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = textString ;
    hud.label.text = textString;
    hud.margin = 10.f;
    //        hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.square = YES;
    //    [hud hide:YES afterDelay:times];
    [hud hideAnimated:YES afterDelay:times];
}

@end
