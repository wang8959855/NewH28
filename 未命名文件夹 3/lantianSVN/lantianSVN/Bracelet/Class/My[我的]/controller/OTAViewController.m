//
//  OTAViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/4/11.
//  Copyright © 2017年 xiaoxia liu. All rights reserved.
//

#import "OTAViewController.h"


@interface OTAViewController ()<UIAlertViewDelegate>

@property (nonatomic , strong) UILabel *firmWareLabel;

@property (nonatomic, strong) HardWearVersionModel *versionModel;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIButton *otaButton;

@property (nonatomic, assign) BOOL isNew;
@end

@implementation OTAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self LoadUI];
    
    kWEAKSELF
    [[PZBlueToothManager sharedInstance] getHardWearVersionWithHardVersionBlock:^(HardWearVersionModel *model) {
        weakSelf.versionModel = model;
    }];
    
//    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"sdk12_app_2" ofType:@"zip"];
//    if (localPath)
//    {
//        [[PZBlueToothManager sharedInstance] localOTAWithURL:localPath];
//    }
}

- (void)LoadUI
{
    [self addNavWithTitle:NSLocalizedString(@"手环固件升级",nil) backButton:YES shareButton:NO];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *equipmentImage = [UIImage imageNamed:@"OTABracelet"];
    imageView.image = equipmentImage;
    [self.view addSubview:imageView];
    imageView.sd_layout.topSpaceToView(self.view, 120 * kX)
                        .centerXIs(self.view.width/2.)
                        .widthIs(80 * kX)
                        .heightIs(80 * kX);

    _firmWareLabel = [[UILabel alloc] init];
    _firmWareLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"未知",nil)];
    _firmWareLabel.textColor = [UIColor darkGrayColor];
    _firmWareLabel.textAlignment = NSTextAlignmentCenter;
    _firmWareLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_firmWareLabel];
    _firmWareLabel.sd_layout.topSpaceToView(imageView, 15 * kX)
                            .centerXIs(self.view.width/2.)
                            .widthIs(self.view.width)
                            .heightIs(30);
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.text = NSLocalizedString(@"最新版",nil);
    _stateLabel.textColor = [UIColor lightGrayColor];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_stateLabel];
    _stateLabel.sd_layout.centerXIs(self.view.width / 2.)
    .topSpaceToView(_firmWareLabel, 6 * kX)
    .widthIs(self.view.width)
    .heightIs(18);
    
    _otaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _otaButton.backgroundColor = [UIColor  lightGrayColor];
    _otaButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_otaButton setTitle:NSLocalizedString(@"升级",nil) forState:UIControlStateNormal];
    [_otaButton setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_otaButton setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal | UIControlStateHighlighted];

    [_otaButton setBackgroundImage:[self imageWithColor:kmainBackgroundColor] forState:UIControlStateSelected];
    [_otaButton setBackgroundImage:[self imageWithColor:kmainBackgroundColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    [_otaButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_otaButton addTarget:self action:@selector(updateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_otaButton];
    _otaButton.sd_layout.topSpaceToView(_stateLabel, 20 * kX)
    .centerXIs(self.view.width / 2.)
    .widthIs(160 * kX)
    .heightIs(30 );
    _otaButton.layer.cornerRadius = 8;
    _otaButton.clipsToBounds = YES;

}

- (void)updateClick:(UIButton *)button
{
    if (button.selected)
    {
        [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在下载固件",nil) detailLabel:nil];
        kWEAKSELF;
        [[AFAppDotNetAPIClient sharedClient] globalDownloadWithUrl:_firmURL Block:^(id responseObject, NSURL *filePath, NSError *error) {
            [self removeActityIndicatorFromView:weakSelf.view];
            if (filePath)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                hud.mode = MBProgressHUDModeDeterminate;
                hud.label.text = @"正在升级固件";
                [hud.button setTitle:NSLocalizedString(@"取消", @"HUD cancel button title") forState:UIControlStateNormal];
                [hud.button addTarget:weakSelf action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
                
                [[PZBlueToothManager sharedInstance] startDFUWithFirmWarePath:[filePath description] andProgressBlock:^(int progress) {
                    [MBProgressHUD HUDForView:weakSelf.view].progress = progress/100.0;
                    if (progress == 100)
                    {
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        weakSelf.isNew = NO;
                    }
                } errorBlock:^(NSString *error) {
                    adaLog(@"%@",error);
                }];
                
            }else
            {
                [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"下载失败",nil) deleyTime:1.5f];
            }
            adaLog(@"%@",responseObject);
            adaLog(@"%@",filePath);
        }];
    }
}

- (void)setIsNew:(BOOL)isNew
{
    _isNew = isNew;
    if (isNew)
    {
        _stateLabel.textColor = KCOLOR(232, 109, 114);
        _stateLabel.text = NSLocalizedString(@"可更新",nil);
        _otaButton.selected = YES;
    }else{
        _stateLabel.textColor = [UIColor lightGrayColor];
        _stateLabel.text = NSLocalizedString(@"最新版",nil);
        _otaButton.selected = NO;
    }
}

- (void)setVersionModel:(HardWearVersionModel *)versionModel
{
    _versionModel = versionModel;
    _firmWareLabel.text = versionModel.nameString;

   
    NSString *nameString = [_versionModel.nameString stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSMutableString *totalString = [[NSMutableString alloc] initWithString:nameString];

    [totalString insertString:@"_" atIndex:totalString.length-2];
    NSDictionary *versionDic = @{@"firmware":totalString};
    
    NSDictionary *param = [kHCH changeToParamWithDic:versionDic];
    
    kWEAKSELF;
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:@"getVname.php" ParametersDictionary:param Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [weakSelf removeActityIndicatorFromView:weakSelf.view];
        adaLog(@"%@",responseObject);
        if (responseObject)
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *dataDic = responseObject[@"data"];
//                int version = [dataDic[@"fid"] intValue];
//                if (version > _versionModel.mainSoftVersion) {
//                }
                weakSelf.firmURL = dataDic[@"url"];
                weakSelf.isNew = YES;

            }else
            {

            }
        }else
        {
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UIAlertViewDelegate


- (void)cancelWork:(UIButton *)button
{
    [[PZBlueToothManager sharedInstance] cancelDFU];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
