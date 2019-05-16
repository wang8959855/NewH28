//
//  HealtPoliceViewController.m
//  Bracelet
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 com.czjk.www. All rights reserved.
//

#import "HealtPoliceViewController.h"
#import "PoliceCell.h"
#import "PoliceHeaderView.h"
#import "SOSView.h"

#import <WebKit/WebKit.h>

static NSString *listCell = @"policeCell";
static NSString *header = @"header";

@interface HealtPoliceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *_titleArr;
    NSArray *_imageArr;
}

@property (nonatomic, assign) BOOL isWar;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//上一次选择的模式
@property (nonatomic, strong) PoliceCell *selectCell;
@property (nonatomic, assign) NSInteger monitorType;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *sxiao;

@end

@implementation HealtPoliceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self getUserClick];
}

- (void)reloadWebView{
    //测试
    NSString *root = @"http://test07.lantianfangzhou.com/report/current";
    //生产
    //        NSString *root = @"http://sanguo.lantianfangzhou.com/h28/report/current";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/0",root,self.sxiao,USERID,TOKEN]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addnavTittle:@"健康报告" RSSIImageView:YES shareButton:YES];
//    [self setSubViews];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserClick) name:@"updateWarn" object:nil];
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:refreshButton];
    refreshButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 25, StatusBarHeight + 12, 20, 20);
    [refreshButton setImage:[UIImage imageNamed:@"shuaxin-icon"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(reloadWebView) forControlEvents:UIControlEventTouchUpInside];
    
    
    //测试
    NSString *root = @"http://test07.lantianfangzhou.com/report/current";
    //生产
    //    NSString *root = @"http://sanguo.lantianfangzhou.com/h28/report/current";
    
    self.sxiao = @"h28";
    
    CGFloat backScrollViewY = SafeAreaTopHeight;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - SafeAreaTopHeight - SafeAreaBottomHeight;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/0",root,self.sxiao,USERID,TOKEN]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 60, StatusBarHeight + 12, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"repot1",@"repot2",@"repot3",@"repot4",@"repot5"];
    [self.navigationController pushViewController:guide animated:YES];
}

- (void)setSubViews{
    _titleArr = @[@"饮酒监测",@"吸烟监测",@"加班监测",@"运动监测",@"游戏监测",@"驾驶监测",@"晨起监测",@"冷热监测",@"如厕监测",@"情绪监测"];
    _imageArr = @[@"yinjiu",@"xiyan",@"jiaban",@"yundong",@"youxi",@"jiashi",@"chenqi",@"lengre",@"ruce",@"qingxv"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PoliceCell" bundle:nil] forCellWithReuseIdentifier:listCell];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PoliceHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake((ScreenW-15)/2, 80)];
    [layout setSectionInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoliceCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:listCell forIndexPath:indexPath];
    cell.titleLabel.text = _titleArr[indexPath.row];
    cell.ImageV.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    if (self.monitorType != 0 && self.monitorType == indexPath.row+1) {
        cell.backView.backgroundColor = KCOLOR(255, 178, 70);
        self.selectCell = cell;
    }else{
        cell.backView.backgroundColor = kMainColor;
    }
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PoliceHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:header forIndexPath:indexPath];
        headerView.isWar = self.isWar;
        headerView.vc = self;
        if (self.monitorType == 0) {
            headerView.policeState.text = [self getDate:@"您目前正处于自动检测模式"];
        }else{
           headerView.policeState.text = [self getDate:[NSString stringWithFormat:@"您目前正处于%@模式",_titleArr[self.monitorType-1]]];
        }
        return headerView;
    }
    return nil;
}

- (NSString *)getDate:(NSString *)state{
    NSString *con = @"";
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    int nowSec = hour*3600+minute*60+second;
    if (nowSec > 3600 && nowSec <= 10800) {
        //丑时
        con = @"(01:00-03:00)";
    }else if (nowSec > 10800 && nowSec <= 18000){
        //寅时
        con = @"(03:00-05:00)";
    }else if (nowSec > 18000 && nowSec <= 25200){
        //卯时
        con = @"(05:00-07:00)";
    }else if (nowSec > 25200 && nowSec <= 32400){
        //辰时
        con = @"(07:00-09:00)";
    }else if (nowSec > 32400 && nowSec <= 39600){
        //巳时
        con = @"(09:00-11:00)";
    }else if (nowSec > 39600 && nowSec <= 46800){
        //午时
        con = @"(11:00-13:00)";
    }else if (nowSec > 46800 && nowSec <= 54000){
        //未时
        con = @"(13:00-15:00)";
    }else if (nowSec > 54000 && nowSec <= 61200){
        //申时
        con = @"(15:00-17:00)";
    }else if (nowSec > 61200 && nowSec <= 68400){
        //酉时
        con = @"(17:00-19:00)";
    }else if (nowSec > 68400 && nowSec <= 75600){
        //戌时
        con = @"(19:00-21:00)";
    }else if (nowSec > 75600 && nowSec <= 82800){
        //亥时
        con = @"(21:00-23:00)";
    }else if (nowSec > 82800 || nowSec <= 3600){
        //子时
        con = @"(23:00-01:00)";
    }
    
    return [NSString stringWithFormat:@"%@%@",state,con];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenW, 170);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PoliceCell *cell = (PoliceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.selectCell != nil && self.selectCell == cell) {
        //有选中
        self.selectCell = nil;
        self.monitorType = 0;
        [self setUserClick:[NSString stringWithFormat:@"%ld",indexPath.row+1] cell:nil msg:[NSString stringWithFormat:@"结束%@",cell.titleLabel.text]];
    }else if (self.selectCell != nil && self.selectCell != cell){
        [self addActityTextInView:self.view text:[NSString stringWithFormat:@"请先结束%@",self.selectCell.titleLabel.text] deleyTime:1.5];
    }else{
        //没有选中
        [self setUserClick:[NSString stringWithFormat:@"%ld",indexPath.row+1] cell:cell msg:[NSString stringWithFormat:@"开始%@",cell.titleLabel.text]];
    }
}

//获取检测状态
- (void)getUserClick{
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",GETSERVER,TOKEN];
    NSDictionary *para = @{@"userid":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self removeActityIndicatorFromView:self.view];
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            self.monitorType = [responseObject[@"data"][@"monitorType"] integerValue];
            self.isWar = [responseObject[@"data"][@"isWarn"] boolValue];
            [self.collectionView reloadData];
        }else{
            [self addActityTextInView:self.view text:@"获取失败"  deleyTime:1.5f];
        }
    }];
}

//定制监测
- (void)setUserClick:(NSString *)type cell:(PoliceCell *)cell msg:(NSString *)msg{
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",SETSERVER,TOKEN];
    NSDictionary *para = @{@"userid":USERID,@"monitor":type};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self removeActityIndicatorFromView:self.view];
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            if (cell) {
                self.monitorType = type.integerValue;                
            }else{
                self.monitorType = 0;
            }
            self.selectCell = cell;
            [self addActityTextInView:self.view text:msg deleyTime:1.5];
            [self.collectionView reloadData];
        }else{
            [self addActityTextInView:self.view text:@"设置失败"  deleyTime:1.5f];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
