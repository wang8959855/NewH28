//
//  PoliceHeaderView.h
//  Bracelet
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealtPoliceViewController.h"

@interface PoliceHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *sosButton;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (nonatomic, assign) BOOL isWar;

@property (nonatomic, strong) HealtPoliceViewController *vc;

@property (weak, nonatomic) IBOutlet UILabel *policeState;


@end
