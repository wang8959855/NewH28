//
//  JiuzuoMinuteListView.h
//  Bracelet
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^jiuzuoDelay)(int delay);
@interface JiuzuoMinuteListView : UIView

@property (nonatomic, copy) jiuzuoDelay jiuzuoDelay;

+ (JiuzuoMinuteListView *)jiuzuoMinuteListView;

@end

NS_ASSUME_NONNULL_END
