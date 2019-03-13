//
//  UILabel+Style.h
//  MasonryDemo
//
//  Created by wtjr on 16/11/9.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Style)


/**
 设置Label样式

 @param text          文字
 @param textColor     文字颜色
 @param textFont      文字大小 默认为系统字体
 @param textAlignment 文字居中状态
 */
- (void)setLabelStyle:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)textFont texrAlignment:(NSTextAlignment)textAlignment;

- (void) textLeftTopAlign;

-(void)alignTop;


@end
