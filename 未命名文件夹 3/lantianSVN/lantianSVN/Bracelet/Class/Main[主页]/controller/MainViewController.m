//
//  MainViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "MainViewController.h"
#import "BTHomeContentsCell.h"
#import "UnityTool.h"
#import "YHStepTestViewController.h"
#import "TrajectoryViewController.h"
#import "MainPageCollectionReusableView.h"
#import "MainHRViewController.h"
#import "MainSleepViewController.h"
#import "TakePhotoViewController.h"
#import "TrajectoryModel.h"

@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) MainPageCollectionReusableView *headView;
@end

static NSString *headID = @"mainPageHeadView";
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kmainBackgroundColor;
    
    kWEAKSELF;
    

    [[EirogaBlueToothManager sharedInstance] BlueToothStateChangedWithBLock:^(BOOL isconnected, CBPeripheral *peripheral) {
        if (isconnected)
        {
            [weakSelf reloadBlueToothData];
        }
    }];
    
    [self configuration];
    [self.view addSubview:self.collectionView];

    self.collectionView.mj_header = [self getRefreshHeader];
    [self.collectionView registerClass:[BTHomeContentsCell class] forCellWithReuseIdentifier:@"BTHomeContentsCell"];
   
    [self.collectionView registerClass:[MainPageCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID];
}

- (MJRefreshNormalHeader *)getRefreshHeader{
    kWEAKSELF;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([EirogaBlueToothManager sharedInstance].isconnected)
        {
            [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:5.0f];
            [weakSelf reloadBlueToothData];
        }else{
            [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"蓝牙未连接", nil) deleyTime:1.5f];
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉可以刷新",nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开立即刷新",nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"正在刷新数据",nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    return header;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadBlueToothData];
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    self.headView.maxValue = [[XXUserInformation userSportTarget] intValue];
}

- (void)reloadBlueToothData
{
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] getActualDataWithDataBlockWithBlock:^(ActualDataModel *model) {
        weakSelf.headView.model = model;
        [weakSelf.collectionView.mj_header endRefreshing];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadOutTime) object:nil];
    }];
}

- (void)reloadOutTime
{
    [self.collectionView.mj_header endRefreshing];
    [self addActityTextInView:self.view text:NSLocalizedString(@"刷新超时", nil) deleyTime:1.5f];
}

- (void)configuration
{
    [self addnavTittle:nil RSSIImageView:YES shareButton:YES];
}

#pragma mark - *********************代理方法*********************
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

//设置Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BTHomeContentsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BTHomeContentsCell" forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        YHStepTestViewController *vc = [[YHStepTestViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if (indexPath.row == 1){
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        MainHRViewController *HRVC = [[MainHRViewController alloc] init];
        [self.navigationController pushViewController:HRVC animated:YES];
        
    }else if (indexPath.row == 2){
        MainSleepViewController *sleepVC = [[MainSleepViewController alloc] init];
        [self.navigationController pushViewController:sleepVC animated:YES];
        
    }else if(indexPath.row == 3){
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
        [[PZBlueToothManager sharedInstance] changetakePhoteStateWithState:YES];

        TakePhotoViewController *takePhotoVC = [[TakePhotoViewController alloc] init];
        [self.navigationController pushViewController:takePhotoVC animated:YES];
       
    }else if (indexPath.row == 4){
        
        TrajectoryViewController *trajectoryVC = [TrajectoryViewController new];
        [self.navigationController pushViewController:trajectoryVC animated:YES];
        
    }else
    {
        if (![EirogaBlueToothManager sharedInstance].isconnected)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"蓝牙未连接",nil) deleyTime:1.5f];
            return;
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenW, 252 * kX);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if (kind == UICollectionElementKindSectionHeader)
    {
       _headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headID forIndexPath:indexPath];
        return _headView;
    }else
    {
        return nil;
    }

}

#pragma mark - *********************懒加载*********************

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemH = (ScreenH - 64 - self.tabBarController.tabBar.height - 252 * kX)/2.;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        [layout setItemSize:CGSizeMake(ScreenW/2, itemH)];
        [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [layout setMinimumInteritemSpacing:0];
        [layout setMinimumLineSpacing:0];
        [_collectionView setCollectionViewLayout:layout];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kUI_WIDTH, kUI_HEIGHT - self.tabBarController.tabBar.height - 64) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
    }
    return _collectionView;
}

@end
