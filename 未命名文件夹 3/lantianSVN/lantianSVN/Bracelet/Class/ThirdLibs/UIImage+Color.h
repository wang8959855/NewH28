//
//  UIImage+Color.h
//  lingqianguan
//
//  Created by yinxiangfu on 15/11/19.
//  Copyright © 2015年 wentongjinrong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 *  将颜色转换成图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage*)imageWithColor:(UIColor*)color;

@end
