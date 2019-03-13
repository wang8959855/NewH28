//
//  XXPickerView.h
//  XXPickerView
//
//  Created by wangwendong on 16/1/8.
//  Copyright © 2016年 sunricher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXPickerView : UIView

@property (weak, nonatomic) id<UIPickerViewDataSource> dataSource;
@property (weak, nonatomic) id<UIPickerViewDelegate> delegate;

/**
 * @brief 更新 Center View 的颜色
 */
- (void)setupCenterViewColor:(UIColor *)aColor;

@property (strong, nonatomic) UIPickerView *mPickerView;

@end
