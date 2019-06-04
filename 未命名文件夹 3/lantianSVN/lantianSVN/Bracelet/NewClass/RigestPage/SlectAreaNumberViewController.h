//
//  SlectAreaNumberViewController.h
//  Bracelet
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^backAreaNumBlock)(NSString *areaNum);
@interface SlectAreaNumberViewController : BaseViewController

@property (nonatomic, copy) backAreaNumBlock backAreaNumBlock;

@end

NS_ASSUME_NONNULL_END
