//
//  PZMyViewController.m
//  Bracelet
//
//  Created by panzheng on 2017/5/17.
//  Copyright © 2017年 com.czjk.www. All rights reserved.
//

#import "PZMyViewController.h"
#import "BTHomeContentsCell.h"
#import "EquipmentViewController.h"
#import "OTAViewController.h"
#import "UserInfoViewController.h"
#import "TargetViewController.h"
#import "SendMessageViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"


@interface PZMyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;



@end

@implementation PZMyViewController

static NSString *reuseID = @"collectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    self.view.backgroundColor = kMainColor;
    
//    NSString *url = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (void)loadUI
{
    [self addNavWithTitle:nil backButton:YES shareButton:nil];
    [self.collectionView registerClass:[BTHomeContentsCell class] forCellWithReuseIdentifier:reuseID];
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemH = (ScreenH - 64 - self.tabBarController.tabBar.height)/4.;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        [layout setItemSize:CGSizeMake(ScreenW/2, itemH)];
        [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [layout setMinimumInteritemSpacing:0];
        [layout setMinimumLineSpacing:0];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [collectionView setDelegate:self];
        [collectionView setDataSource:self];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        
        [self.view addSubview:collectionView];
        collectionView.sd_layout.leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .topSpaceToView(self.view, 64);
        _collectionView = collectionView;
        
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

//设置Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BTHomeContentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    cell.isMy = YES;
    cell.row = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            EquipmentViewController *equipVC = [[EquipmentViewController alloc] init];
            [self.navigationController pushViewController:equipVC animated:YES];
        }
            break;
        case 1:
        {
            UserInfoViewController *equipVC = [[UserInfoViewController alloc] init];
            [self.navigationController pushViewController:equipVC animated:YES];
        }
            break;

        case 2:
        {
            TargetViewController *targetVC = [[TargetViewController alloc] init];
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            break;
        case 3:
        {
            OTAViewController *OTAVc = [[OTAViewController alloc] init];
            [self.navigationController pushViewController:OTAVc animated:YES];
        }
            break;
        case 4:
        {
            SendMessageViewController *vc = [[SendMessageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            AboutViewController *vc = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            UIAlertController *alertContrler = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"确认退出登录",nil) preferredStyle:UIAlertControllerStyleAlert];
            kWEAKSELF;
            UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf logOut];
            }];
            [alertContrler addAction:cancelButton];
            [alertContrler addAction:okButton];
            [self presentViewController:alertContrler animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)logOut
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@user",kHCH.userInfoModel.name]] error:nil];
    
    [PZSaveDefaluts remobeObjectForKey:@"userData"];
    kHCH.userInfoModel = nil;
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = loginVC;
    
    //    解绑手环
    [XXDeviceInfomation setIsBindDevice:NO];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"EquipmentSupport"];
    [[PZBlueToothManager sharedInstance] disConnectedPeripheral];
    [PZSaveDefaluts remobeObjectForKey:@"kBleBoundPeripheralIdentifierString"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
