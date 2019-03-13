//
//  UerInfoViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/20.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIButton+WebCache.h"
#import "chooseView.h"
#import "DYScrollRulerView.h"
#import "XXTabBarController.h"

@interface UserInfoViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,DYScrollRulerDelegate>


@property (nonatomic, weak) UILabel *heightLabel;

@property (nonatomic, weak) UILabel *weightLabel;

@property (nonatomic, weak) UILabel *genderLabel;

@property (nonatomic, weak) UILabel *birthLabel;

@property (nonatomic, weak) chooseView *chooseView;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadUI];
}

- (void)loadUI
{
    
    if (_isRegist)
    {
        [self addNavWithTitle:NSLocalizedString(@"我的资料",nil) backButton:NO shareButton:NO];
    }else
    {
        [self addNavWithTitle:NSLocalizedString(@"我的资料",nil) backButton:YES shareButton:NO];
    }
 
    NSArray *titleArray = @[NSLocalizedString(@"身高",nil),NSLocalizedString(@"体重",nil),NSLocalizedString(@"性别",nil),NSLocalizedString(@"生日",nil)];
    for (int i = 0; i < titleArray.count; i ++)
    {
        UIView *backView = [[UIView alloc] init];
        [self.view addSubview:backView];
        backView.sd_layout.topSpaceToView(self.view, 100 * kX + 54 * kX  * i)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .heightIs(54 * kX);
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview:topLine];
        topLine.sd_layout.topEqualToView(backView)
        .leftSpaceToView(backView, 12)
        .rightSpaceToView(backView, 12)
        .heightIs(0.5);
        if (i == titleArray.count - 1)
        {
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.backgroundColor = [UIColor lightGrayColor];
            [backView addSubview:bottomLine];
            bottomLine.sd_layout.bottomEqualToView(backView)
            .leftSpaceToView(backView, 12)
            .rightSpaceToView(backView, 12)
            .heightIs(0.5);
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kmainBackgroundColor;
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        [backView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(backView, 26 * kX)
        .centerYIs(backView.height/2.)
        .widthIs(titleLabel.width)
        .heightIs(backView.height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@">" forState:UIControlStateNormal];
        [backView addSubview:button];
        button.sd_layout.rightEqualToView(backView)
        .topEqualToView(backView)
        .leftEqualToView(backView)
        .bottomEqualToView(backView);
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:detailLabel];
        detailLabel.sd_layout.rightSpaceToView(backView, 50 * kX)
        .leftSpaceToView(backView, 0)
        .topEqualToView(backView)
        .bottomEqualToView(backView);
        switch (i) {
            case 0:
                _heightLabel = detailLabel;
                _heightLabel.text = kHCH.userInfoModel.height;
                break;
            case 1:
                _weightLabel = detailLabel;
                _weightLabel.text = kHCH.userInfoModel.weight;
                break;
            case 2:
                _genderLabel = detailLabel;
                _genderLabel.text = [kHCH.userInfoModel.gender isEqualToString:@"1"]?NSLocalizedString(@"男", nil):NSLocalizedString(@"女", nil);
                break;
            case 3:
                _birthLabel = detailLabel;
                _birthLabel.text = kHCH.userInfoModel.birthday;
                break;
                
            default:
                break;
        }
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = kmainBackgroundColor;
    [button setTitle:NSLocalizedString(@"同步数据到手环",nil) forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(cureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button sizeToFit];
    button.sd_layout.bottomSpaceToView(self.view, 46 * kX)
    .centerXIs(self.view.width/2.)
    .widthIs(button.width + 10)
    .heightIs(35 * kX);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_chooseView)
    {
        [UIView animateWithDuration:0.34 animations:^{
            _chooseView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
        } completion:^(BOOL finished) {
            [_chooseView removeFromSuperview];
        }];
    }
}

- (void)cureButtonClick
{
    if (self.heightLabel.text && self.heightLabel.text.length != 0 &&
        self.weightLabel.text && self.weightLabel.text.length != 0 &&
        self.genderLabel.text && self.genderLabel.text.length != 0 &&
        self.birthLabel.text && self.birthLabel.text.length != 0)
    {
        [kHCH userInfoModelChanged];
        int gender = 0;
        if ([kHCH.userInfoModel.gender isEqualToString:@"2"]) {
            gender = 0;
        }
        if ([kHCH.userInfoModel.gender isEqualToString:@"1"]){
            gender = 1;
        }
        [[PZBlueToothManager sharedInstance] sendUserInformationWithHeight:[kHCH.userInfoModel.height intValue]weight:[kHCH.userInfoModel.weight intValue] gender:gender];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self.view makeToast:NSLocalizedString(@"请完善信息", nil) duration:2 position:[NSValue valueWithCGPoint:self.view.center]];
    }
}

- (void)headButtonClick:(UIButton *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从相册选择", nil), nil];
    [actionSheet showInView:self.view];
    [self.view addSubview:actionSheet];
}

- (void)buttonClick:(UIButton *)button
{
    if (!_chooseView)
    {
        kWEAKSELF;
        chooseView *view = [[chooseView alloc] init];
        view.delegate =self;
        view.frame = CGRectMake(0, ScreenH, self.view.width, self.view.height);
        switch (button.tag)
        {
            case 100:
            {
                if ([self.heightLabel.text intValue] > 0)
                {
                    view.value = [_heightLabel.text intValue];
                }
                else{
                    view.value = 170;
                }
                view.type = viewTypeHeight;

                view.buttonHandle = ^(chooseView *view) {
                weakSelf.heightLabel.text = [NSString stringWithFormat:@"%d",view.value];
                    kHCH.userInfoModel.height = [NSString stringWithFormat:@"%d",view.value];
                };
            }
                break;
            case 101:
            {
                if ([self.weightLabel.text intValue] > 0)
                {
                    view.value = [_weightLabel.text intValue];
                }
                else{
                    view.value = 50;
                }
                view.type = viewTypeWeight;
                
                view.buttonHandle = ^(chooseView *view) {
                    weakSelf.weightLabel.text = [NSString stringWithFormat:@"%d",view.value];
                    kHCH.userInfoModel.weight = [NSString stringWithFormat:@"%d",view.value];

                };
            }
                break;
            case 102:
            {
                if ([self.genderLabel.text length] > 0)
                {
                    view.value = [self.genderLabel.text isEqualToString:NSLocalizedString(@"男",nil)]?1:2;
                }
                else{
                    view.value = 2;
                }
                view.type = viewTypeGender;
                
                view.buttonHandle = ^(chooseView *view) {
                    if (view.value == 1)
                    {
                        weakSelf.genderLabel.text = NSLocalizedString(@"男",nil);

                    }else if (view.value == 2)
                    {
                        weakSelf.genderLabel.text = NSLocalizedString(@"女",nil);
                    }
                    kHCH.userInfoModel.gender = [NSString stringWithFormat:@"%d",view.value];
                };
            }
                break;
            case 103:
            {

                view.type = viewTypeBirthDay;
                
                view.buttonHandle = ^(chooseView *view) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    self.birthLabel.text = [formatter stringFromDate:view.datePicker.date];
                    kHCH.userInfoModel.birthday = self.birthLabel.text;
                };
            }
                break;
            default:
                break;
        }
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.view addSubview:view];
        [UIView animateWithDuration:0.34 animations:^{
            view.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        }];
        _chooseView = view;

    }
}




- (BOOL)cameraEnable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)photoEnable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)supportMediaType:(NSString *)type sourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (type.length == 0) {
        //        adaLog(@"Type Empty");
        return NO;
    }
    
    // 获取当前设置支持的所有媒体类型
    NSArray * mediaArr = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    __block BOOL result = NO;
    [mediaArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(NSString *)obj isEqualToString:type]) {
            *stop = YES;
            result = YES;
        }
    }];
    
    return result;
}

-(void)dyScrollRulerView:(DYScrollRulerView *)rulerView valueChange:(float)value
{
    self.chooseView.value = value ;
}


//保存图片结果的回调
// UIImageWriteToSavedPhotosAlbum 组合的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
    }else{
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
