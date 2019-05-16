//
//  SheBeiViewController.m
//  keyBand
//
//  Created by 迈诺科技 on 15/11/3.
//  Copyright © 2015年 huichenghe. All rights reserved.
//

#import "SheBeiViewController.h"
#import "PerModel.h"
#import "DeviceTypeViewController.h"
#import "PSDrawerManager.h"
#import "SheBeiCell.h"

@interface SheBeiViewController ()<DeviceTypeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>//BlueToothScanDelegate,

@property (nonatomic,assign) BOOL isChange;
@end

static NSString *cellReuse = @"Cell";
static NSString *conectReuse = @"connectedCell";


@implementation SheBeiViewController
+ (SheBeiViewController *)sharedInstance
{
    static SheBeiViewController * instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
- (void)dealloc
{
    //    [BlueToothData getInstance].shebeiDelegate = nil;
    //    _bluetoothScan.myDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setXibLabel];
    [self setupView];
    [self refreshConnectView];
    //    [self setupConstraint];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 30, StatusBarHeight + 12, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy-black"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"guanli1",@"sousuo1",@"sousuo2"];
    [self.navigationController pushViewController:guide animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [[PSDrawerManager instance] cancelDragResponse];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //[self initPro];//刷新状态
    [self refreshHead];             //刷新title
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[PSDrawerManager instance] beginDragResponse];
}

- (void)initPro
{
    _isChange = NO;
    //    WeakSelf;
    //    [[CositeaBlueTooth sharedInstance]checkCBCentralManagerState:^(CBCentralManagerState state) {
    //        [weakSelf refreshConnectView];
    //
    //    }];
}
-(void)refreshConnectView
{
    if([[EirogaBlueToothManager sharedInstance] isconnected])
    {
        [_searchBtn setTitle:@"解绑设备" forState:UIControlStateNormal];
        
        _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
        CBPeripheral *per =  [EirogaBlueToothManager sharedInstance].peripheral;
        _stateLabel.text = per.name;
        _deviceName.text = kHCH.mac;
        
    }
    else
    {
        _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
        [_searchBtn setTitle:NSLocalizedString(@"搜索设备",nil) forState:UIControlStateNormal];
        _deviceName.text = NSLocalizedString(@"未绑定",nil);
    }
}
- (void)setupView
{
    [self setupTopNav];
    self.deviceTableView.mj_header = [self getRefreshHeader];
    [self.deviceTableView registerNib:[UINib nibWithNibName:@"SheBeiCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [[EirogaBlueToothManager sharedInstance] BlueToothStateChangedWithBLock:^(BOOL isConnect, CBPeripheral *peripheral) {
        [self removeActityIndicatorFromView:self.view];
        if (isConnect) {
            [self hidenSearchView:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
            [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
            [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
            
            _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
            [XXDeviceInfomation setDeviceIdentifierString:peripheral.identifier.UUIDString];
            _deviceName.text = kHCH.mac;
            _stateLabel.text = peripheral.name;
            [self bindDevice:@"h28_"];
        }else{
            [self addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
            [_searchBtn setTitle:NSLocalizedString(@"搜索设备",nil) forState:UIControlStateNormal];
            _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
        }
    }];
    
    _searchViewTopView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [_searchViewTopView addSubview:topView];
    topView.frame = CGRectMake(0, 0, CurrentDeviceWidth, 20);

}

//初始化提醒的view  的 刷新
- (MJRefreshNormalHeader *)getRefreshHeader {
    kWEAKSELF;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.deviceTableView.mj_header endRefreshing];
        weakSelf.deviceArray = nil;
        [[PZBlueToothManager sharedInstance] scanDevicesWithBlock:^(NSArray *array) {
            NSArray *devices = [array copy];
            weakSelf.deviceArray = [AllTool checkBracelet:devices];
            [weakSelf.deviceTableView reloadData];
        }];
        [weakSelf performSelector:@selector(reloadOutTime) withObject:nil afterDelay:3.0f];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:NSLocalizedString(@"下拉可以刷新",nil) forState:MJRefreshStateIdle];
    [header setTitle:NSLocalizedString(@"松开立即刷新",nil) forState:MJRefreshStatePulling];
    [header setTitle:NSLocalizedString(@"正在刷新数据",nil) forState:MJRefreshStateRefreshing];
    header.stateLabel.textColor = [UIColor blackColor];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    return header;
}

- (IBAction)toHelp:(id)sender
{
    //    HelpBandingViewController *help = [[HelpBandingViewController alloc]init];
    //    [self.navigationController pushViewController:help animated:YES];
}

- (void)setupTopNav
{
    [self addNavWithTitle:@"手环" backButton:YES shareButton:NO];
    CGFloat buttonY = StatusBarHeight;
    CGFloat buttonW = 50;
    CGFloat buttonH = 44;
    CGFloat buttonX = CurrentDeviceWidth - buttonW - 3;
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"deviceTypeA.png"];
   
    CGFloat imageViewW = 22*WidthProportion;
    CGFloat imageViewH = 22*WidthProportion;
    CGFloat imageViewY = (44-imageViewH)-imageViewH/2+StatusBarHeight;
    CGFloat imageViewX = CurrentDeviceWidth - imageViewW - 15*WidthProportion;
    
    imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW,imageViewH);
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(deviceType:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
}
- (void)deviceType:(UIButton *)button
{
    DeviceTypeViewController *deveceType = [[DeviceTypeViewController alloc]init];
    deveceType.navigationController.navigationBar.hidden = YES;
    deveceType.delegate = self;
    [self.navigationController pushViewController:deveceType animated:YES];
}
-(void)refreshHead
{
//    if ([[ADASaveDefaluts getDeviceTypeForKey] integerValue] == 2) {
//        _titleLabel.text = NSLocalizedString(@"手表", nil);
//    } else {
//        _titleLabel.text = NSLocalizedString(@"手环", nil);
//    }
}
- (void)setXibLabel
{
    
    [self setButtonWithButton:_searchBtn andTitle:@"搜索设备"];
    _zhaoshouhuanLabel.text = NSLocalizedString(@"找手环", nil);
    _zhaoshouhuanDetailLabel.text = NSLocalizedString(@"", nil);
    _resetLabel.text = NSLocalizedString(@"清空设备数据", nil);
    
    _resetDetailLabel.text = NSLocalizedString(@"", nil);
    _clearCacheLabel.text = NSLocalizedString(@"清空app数据", nil);
    _clearCacheDetalLabel.text = NSLocalizedString(@"", nil);
    _sousuoTitle.text = NSLocalizedString(@"绑定设备", nil);
}


- (void)reloadOutTime
{
    [self.deviceTableView.mj_header endRefreshing];
    if (_deviceArray.count == 0 && ![BlueToothManager getInstance].isConnected) {
        [self addActityTextInView:self.view text:NSLocalizedString(@"未发现设备", nil) deleyTime:1.5f];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    }
}
#pragma  mark  --- XIB  -- target
- (IBAction)hidenSearchView:(id)sender
{
    self.deviceArray = nil;
    [UIView animateWithDuration:0.23 animations:^{
        _searchView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight);
    } completion:^(BOOL finished) {
        [_searchView removeFromSuperview];
    }];
}

- (IBAction)findBind:(id)sender
{
    if ([EirogaBlueToothManager sharedInstance].isconnected)
    {
        [[PZBlueToothManager sharedInstance] findBracelet];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"手环正在振动，点击停止可关闭振动", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"停止",nil) otherButtonTitles:nil, nil];
//        alert.tag = 103;
//        [alert show];
    }else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"手环未连接", nil) deleyTime:2.];
    }
}

- (IBAction)clearLocalData:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"当前操作将清除本应用所有历史数据，是否继续？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.tag = 102;
    [alert show];
    
}

- (IBAction)resetAction
{
    if([EirogaBlueToothManager sharedInstance].isconnected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString(@"当前操作将清除手环内所有数据，是否继续？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 101;
        [alert show];
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"手环未连接", nil) deleyTime:2.];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
//            [[PZBlueToothManager sharedInstance] disConnectedPeripheral];
//            [PZSaveDefaluts remobeObjectForKey:@"kBleBoundPeripheralIdentifierString"];
        }
    }else if (alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
            [_searchBtn setTitle:NSLocalizedString(@"搜索设备",nil) forState:UIControlStateNormal];
            _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"kBleBoundPeripheralIdentifierString"];
            _stateLabel.text = NSLocalizedString(@"未绑定",nil);
            _deviceName.text = NSLocalizedString(@"未绑定",nil);
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[PZBlueToothManager sharedInstance] disConnectedPeripheral];
            [PZSaveDefaluts remobeObjectForKey:@"kBleBoundPeripheralIdentifierString"];
            
        }
    }else if (alertView.tag == 102)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            [self clearLocalTabel];
        }
    }else if (alertView.tag == 103)
    {
        if (buttonIndex == 0)
        {
//            [[CositeaBlueTooth sharedInstance] CloseFindBindWithBlock:nil];
            return;
        }
    }
    else if (alertView.tag == 200)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"kBleBoundPeripheralIdentifierString"];
                
                if (![EirogaBlueToothManager sharedInstance].isconnected) {
                    if (value && ![value isEqualToString:@""])
                    {
                        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"kBleBoundPeripheralIdentifierString"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [[PZBlueToothManager sharedInstance] connectWithUUID:value perName:nil Mac:nil];
                    }
                }
            });

            [self performSelector:@selector(callbackUNbinding) withObject:nil afterDelay:1.f];
        }
    }
    
    
}
- (void)callbackUNbinding
{
    if (self.removeBindingBlock)
    {
        self.removeBindingBlock(200);
        //adaLog(@"调用  --- removeBindingBlock");
    }
    
}
- (void)clearLocalTabel
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sousuoAction:(UIButton *)sender
{
    if (![sender.titleLabel.text isEqualToString:@"搜索设备"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:NSLocalizedString( @"此操作将删除当前设备连接，并开始搜索新设备，是否继续？",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 100;
        [alert show];
    }
    else
    {
        [self showSearchView];
    }
}



- (void)showSearchView
{
    [AllTool clearDeviceBangding];
    //    [self refreshConnectView];
    [self performSelector:@selector(searchDeviceTimeOut) withObject:nil afterDelay:3.f];
    self.deviceArray = nil;
    
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] scanDevicesWithBlock:^(NSArray *array) {
        weakSelf.deviceArray = array;
        [weakSelf.deviceTableView reloadData];
    }];
    self.deviceTableView.tableFooterView = [[UIView alloc] init];
    //    _bluetoothScan.myDelegate = self;
    _searchView.frame = CGRectMake(0, CurrentDeviceHeight, CurrentDeviceWidth, CurrentDeviceHeight);
    [self.view addSubview:_searchView];
    [UIView animateWithDuration:0.23 animations:^{
        _searchView.frame = CurrentDeviceBounds;
    }];
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"搜索设备", nil) detailLabel:NSLocalizedString(@"搜索设备", nil)];
    
}

- (IBAction)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupConstraint
{
    CGFloat stateImageViewX = 30 * WidthProportion;
    CGFloat stateImageViewW = 105 * WidthProportion;
    CGFloat stateImageViewH = stateImageViewW;
    CGFloat stateImageViewY = (self.UpviewBackgroup.height - stateImageViewH) / 2;
    self.stateImageView.frame = CGRectMake(stateImageViewX, stateImageViewY, stateImageViewW, stateImageViewH);
    //    [self.UpviewBackgroup addSubview:self.stateImageView];
    self.stateImageView.sd_layout
    .leftSpaceToView(self.UpviewBackgroup,stateImageViewX)
    .centerYEqualToView(self.UpviewBackgroup)
    .widthIs(stateImageViewW)
    .heightIs(stateImageViewH);
    
    //    CGFloat stateLabelX = CGRectGetMaxX(_stateImageView.frame) + 20 * HeightProportion;
    //    CGFloat stateLabelW = 200 * WidthProportion;
    //    CGFloat stateLabelH = 30 * HeightProportion;
    //    CGFloat stateLabelY = stateImageViewH / 2 + stateImageViewY - stateLabelH;
    //    self.stateLabel.frame = CGRectMake(stateLabelX, stateLabelY, stateLabelW, stateLabelH);
}

- (void)searchDeviceTimeOut {
    [self removeActityIndicatorFromView:self.view];
    
    //    if (_deviceArray.count == 0 && ![BlueToothManager getInstance].isConnected) {
    //        [self addActityTextInView:self.view text:NSLocalizedString(@"未发现设备", nil) deleyTime:1.5f];
    //    }
}
#pragma mark - 解绑传值出去
-(void)changRemoveBinding:(removeBindingBlock)removeBindingBlock
{
    if (removeBindingBlock)
    {
        self.removeBindingBlock = removeBindingBlock;
        //adaLog(@"removeBindingBlock      - - -赋值");
    }
}
#pragma mark - BlueToothDataDelegate

- (void)BlueToothIsConnected:(BOOL)isconnected;
{
    [self removeActityIndicatorFromView:self.view];
    if (isconnected)
    {
        [self hidenSearchView:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
        
        //        _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
        //        _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
        //        _deviceName.text = NSLocalizedString(@"已连接",nil);
        //        [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
        //        [[NSUserDefaults standardUserDefaults] setObject:[BlueToothManager getInstance].connectUUID forKey:kLastDeviceUUID];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //        _stateImageView.image = [UIImage imageNamed:@"SB_yilianjie"];
        //        _stateLabel.text = [BlueToothManager getInstance].deviceName;
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已断开", nil) deleyTime:1.5f];
        
        //        _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
        //        _stateLabel.text = NSLocalizedString(@"设备未连接", nil);
        //        _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
        //        _deviceName.text = NSLocalizedString(@"连接中...",nil);
        [_searchBtn setTitle:NSLocalizedString(@"搜索设备",nil) forState:UIControlStateNormal];
    }
}

- (void)resetDeviceOK
{
    [self addActityTextInView:self.view text:NSLocalizedString(@"操作成功", nil) deleyTime:1.5];
}
#pragma mark - delegate

-(void)deviceisChange:(BOOL)change
{
    //adaLog(@"change = %d",change);
    
    self.isChange = change;
    BOOL ischange = NO;
//    if (ischange == YES) {
//        [self refreshHead];
//        [self changeDeviceAction];
//        NSString *typeName = [NSString string];
//        if([ADASaveDefaluts getDeviceTypeInt] == 2)
//        {  typeName = NSLocalizedString(@"设备类型已切换为手表", nil);
//        }
//        else
//        {  typeName = NSLocalizedString(@"设备类型已切换为手环", nil);
//        }
//        //adaLog(@"typeName = %@",typeName);
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:typeName preferredStyle:UIAlertControllerStyleActionSheet];
//        [self presentViewController:alert animated:YES completion:nil];
//        [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.5];
//    }
//    else if (change == NO)
//    {
//        NSString *typeName = [NSString string];
//        if([ADASaveDefaluts getDeviceTypeInt] == 2)
//        {
//            typeName = NSLocalizedString(@"设备类型已经是手表,无需切换", nil);
//        }
//        else
//        {
//            typeName = NSLocalizedString(@"设备类型已经是手环,无需切换", nil);
//        }
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:typeName preferredStyle:UIAlertControllerStyleActionSheet];
//        [self presentViewController:alert animated:NO completion:nil];
//        [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:0.8];
//    }
}
-(void)changeDeviceAction
{
    //    [ADASaveDefaluts remobeObjectForKey:AllDEVICETYPE];
    if([EirogaBlueToothManager sharedInstance].isconnected)
    {
//        [[CositeaBlueTooth sharedInstance] disConnectedWithUUID:[CositeaBlueTooth sharedInstance].connectUUID];
    }
    _stateImageView.image = [UIImage imageNamed:@"设备未连接"];
    //    _stateLabel.text = NSLocalizedString(@"设备未连接", nil);
    //    _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
    //    _deviceName.text = NSLocalizedString(@"连接中...",nil);
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *reuseID = @"Cell";
    SheBeiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_deviceArray && _deviceArray.count != 0) {
        PerModel *model =  _deviceArray[indexPath.row];
        CBPeripheral *peripheral = model.per;
        cell.titleLabel.text = peripheral.name;
        cell.macLabel.text = [self macWithMac:model.mac];
        //adaLog(@"PerModel - %@",model);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([EirogaBlueToothManager sharedInstance].isconnected) {
        return;
    }
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在连接",nil) detailLabel:nil];
    PerModel *model = self.deviceArray[indexPath.row];
    [[PZBlueToothManager sharedInstance] connectWithUUID:model.per.identifier.UUIDString perName:model.perName Mac:model.mac];
    _deviceName.text = model.mac;
    kHCH.mac = model.mac;
    [self searchDeviceTimeOut];
    [self performSelector:@selector(connectTimeOut) withObject:nil afterDelay:5.f];
}


-(void)dimissAlertController:(UIAlertController *)alert {
    if(alert)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - bluTooth Connect
- (void)connectTimeOut {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(connectTimeOut) object:nil];
    [self removeActityIndicatorFromView:self.view];
    if ([EirogaBlueToothManager sharedInstance].isconnected) {
        [self addActityTextInView:self.view text:NSLocalizedString(@"设备已连接", nil) deleyTime:1.5f];
        _stateImageView.image = [UIImage imageNamed:@"设备已连接"];
        //        _stateLabel.text = [CositeaBlueTooth sharedInstance].deviceName;
        //        _deviceName.text = NSLocalizedString(@"已连接",nil);
        [_searchBtn setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateNormal];
    }
    else
    {
        [self addActityTextInView:self.view text:NSLocalizedString(@"连接超时", nil) deleyTime:1.0f];
        //        [BlueToothManager getInstance].connectUUID = @"";
        //        if (_bluetoothScan) {
        //            [_bluetoothScan clearDeviceList];
        //        }
    }
    [self hidenSearchView:nil];
}



- (NSString *)macWithMac:(NSString *)mac {
    if (mac && mac.length > 0)
    {
        mac = [mac uppercaseString];
        NSMutableString * mutString;
        if (mac.length > 6)
        {
            mutString = [[NSMutableString alloc] initWithString:[mac substringWithRange:NSMakeRange(mac.length - 12, 12)]];
        }else
        {
            mutString = [[NSMutableString alloc] initWithString:mac];
        }
        
        for (int i = 1; i < 6 ; i ++)
        {
            [mutString insertString:@":" atIndex:12 - 2 * i];
        }
        return  mutString;
    }
    else return @"未获取到mac";
}

- (void)bindDevice:(NSString *)deviceName{
    NSString *uploadUrl = [NSString stringWithFormat:@"%@",BINDDEVICE];
    [self.view makeToastActivity];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID,@"watch":deviceName,@"token":TOKEN} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self.view hideToastActivity];
        if (error)
        {
            [self.view makeToast:@"网络连接错误" duration:1.5 position:CSToastPositionCenter];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                
            } else {
                [self.view makeToast:message duration:1.5 position:CSToastPositionCenter];
            }
        }
    }];
}

@end
