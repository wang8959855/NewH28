//
//  BMIViewController.h
//  Wukong
//
//  Created by 迈诺科技 on 16/5/3.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BMIViewController : BaseViewController

typedef void(^BMIBlock)();

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *BMIButton;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (copy, nonatomic)  BMIBlock backBlock;

@property (copy, nonatomic)  BMIBlock okBlock;



@property (weak, nonatomic) IBOutlet UILabel *fanweiLabel;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;


@property (weak, nonatomic) IBOutlet UILabel *kStandardBMI;


@property (weak, nonatomic) IBOutlet UILabel *weightArea;

@property (weak, nonatomic) IBOutlet UIView *textView;


@property (assign , nonatomic) float height;

@property (assign, nonatomic) float weight;


@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (nonatomic,assign) BOOL isRegister;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButtonBig;

@end
