//
//  YHEditCell.h
//  Bracelet
//
//  Created by xieyingze on 17/1/3.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHEditModel.h"

@interface YHEditCell : UITableViewCell
@property(nonatomic,strong)UIButton *View1;
@property(nonatomic,strong)UIImageView *icon1;
@property(nonatomic,strong)UILabel *typeLable1;

@property(nonatomic,strong)UIButton *View2;
@property(nonatomic,strong)UIImageView *icon2;
@property(nonatomic,strong)UILabel *typeLable2;

@property(nonatomic,strong)UIView *line1;
@property(nonatomic,strong)UIView *line2;
-(void)setModel:(YHEditModel*)model;

@end
