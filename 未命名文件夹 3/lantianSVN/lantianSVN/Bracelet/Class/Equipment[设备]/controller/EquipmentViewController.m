//
//  EquipmentViewController.m
//  Bracelet
//
//  Created by SZCE on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "EquipmentViewController.h"
#import "XXDeviceInfomation.h"
#import "DeviceCell.h"

@interface EquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIImageView *connectStateImageView;

@property (nonatomic, weak) UIButton *bindButton;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSArray *deviceArray;

@end

@implementation EquipmentViewController

static NSString *reuseID = @"EquipmentCell";

#pragma mark - viewDidLoad入口
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
    kWEAKSELF;
    [[EirogaBlueToothManager sharedInstance] BlueToothStateChangedWithBLock:^(BOOL isconnected, CBPeripheral *peripheral) {
        weakSelf.bindButton.selected = isconnected;
        [weakSelf.tableView reloadData];
        
        if (isconnected)
        {
            [weakSelf removeActityIndicatorFromView:self.view];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            weakSelf.connectStateImageView.image = [UIImage imageNamed:@"myConnected"];

        [XXDeviceInfomation setDeviceIdentifierString:peripheral.identifier.UUIDString];
        }else
        {
            weakSelf.connectStateImageView.image = [UIImage imageNamed:@"myDisconnected"];
        }
    }];
}

- (void)loadUI
{
    [self addNavWithTitle:NSLocalizedString(@"我的设备",nil) backButton:YES shareButton:NO];
    [self connectStateImageView];
    
    UIImageView *braceletImageView = [[UIImageView alloc] init];
    braceletImageView.contentMode = UIViewContentModeScaleAspectFit;
    braceletImageView.image = [UIImage imageNamed:@"myEquipment"];
    [self.view addSubview:braceletImageView];
    braceletImageView.sd_layout.topEqualToView(_connectStateImageView)
    .bottomEqualToView(_connectStateImageView)
    .widthIs(_connectStateImageView.width)
    .rightSpaceToView(_connectStateImageView, 30 * kX);
    
    UIImageView *phoneImageView = [[UIImageView alloc] init];
    phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
    phoneImageView.image = [UIImage imageNamed:@"myPhoneImage"];
    [self.view addSubview:phoneImageView];
    phoneImageView.sd_layout.topEqualToView(_connectStateImageView)
    .bottomEqualToView(_connectStateImageView)
    .widthIs(_connectStateImageView.width)
    .leftSpaceToView(_connectStateImageView, 30 * kX);
    
    [self bindButton];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = NSLocalizedString(@"绑定过程中请确保手环点亮",nil);
    tipLabel.textColor = kmaintextGrayColor;
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];
    tipLabel.sd_layout.topSpaceToView(_bindButton, 10 * kX)
    .centerXIs(self.view.width/2.)
    .widthIs(self.view.width)
    .heightIs(40);
    
    [self tableView];
}


- (UIImageView *)connectStateImageView
{
    if (!_connectStateImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([EirogaBlueToothManager sharedInstance].isconnected)
        {
            imageView.image = [UIImage imageNamed:@"myConnected"];
        }else
        {
            imageView.image = [UIImage imageNamed:@"myDisconnected"];
        }
        [self.view addSubview:imageView];
        imageView.sd_layout.topSpaceToView(self.view, 112 * kX)
        .centerXIs(self.view.width/2.)
        .widthIs(70 * kX)
        .heightIs(70 * kX);
        _connectStateImageView = imageView;
    }
    return _connectStateImageView;
}

- (UIButton *)bindButton
{
    if (!_bindButton)
    {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:kmainDarkColor forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateSelected];
        [button setTitle:NSLocalizedString(@"解绑设备",nil) forState:UIControlStateSelected | UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(@"搜索设备",nil) forState:UIControlStateNormal];
        [button sizeToFit];
        button.selected = [EirogaBlueToothManager sharedInstance].isconnected;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(bindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.sd_layout.topSpaceToView(_connectStateImageView, 34 * kX)
        .centerXIs(self.view.width/2.)
        .widthIs(button.width + 10)
        .heightIs(36 * kX);
        _bindButton = button;
    }
    return _bindButton;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView.sd_layout.topSpaceToView(self.view, 315 * kX)
        .centerXIs(self.view.width/2.)
        .widthIs(self.view.width)
        .bottomEqualToView(self.view);
        _tableView = tableView;
        [_tableView registerClass:[DeviceCell class] forCellReuseIdentifier:reuseID];
    }
    return _tableView;
}

- (void)bindButtonClick:(UIButton *)button
{
    if (button.selected)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"确认解绑设备?",nil) preferredStyle:UIAlertControllerStyleActionSheet];
        kWEAKSELF;
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.bindButton.selected = NO;
            [[PZBlueToothManager sharedInstance] disConnectedPeripheral];
            [PZSaveDefaluts remobeObjectForKey:@"kBleBoundPeripheralIdentifierString"];
        }];
        [alert addAction:action];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        [self scanDevice];
    }
}

- (void)scanDevice
{
    kWEAKSELF;
    [[PZBlueToothManager sharedInstance] scanDevicesWithBlock:^(NSArray *array) {
        weakSelf.deviceArray = array;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([EirogaBlueToothManager sharedInstance].isconnected)
    {
        return 1;
    }
    return self.deviceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  58 * kX;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([EirogaBlueToothManager sharedInstance].isconnected)
    {
        cell.per = [EirogaBlueToothManager sharedInstance].peripheral;
    }else
    {
        cell.model = self.deviceArray[indexPath.row];
    }
    cell.isConnected = [EirogaBlueToothManager sharedInstance].isconnected;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([EirogaBlueToothManager sharedInstance].isconnected)
    {
        return NSLocalizedString(@"已绑定设备",nil);
    }else return NSLocalizedString(@"待绑定设备列表",nil);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([EirogaBlueToothManager sharedInstance].isconnected) {
        return;
    }
    [self addActityIndicatorInView:self.view labelText:NSLocalizedString(@"正在连接",nil) detailLabel:nil];
    PerModel *model = self.deviceArray[indexPath.row];
    [[PZBlueToothManager sharedInstance] connectWithUUID:model.per.identifier.UUIDString perName:model.perName Mac:model.mac];
    [self performSelector:@selector(connectTimeout) withObject:nil afterDelay:5.f];
}

- (void)connectTimeout
{
    
    [BlueToothManager getInstance].connectUUID = nil;
    [self removeActityIndicatorFromView:self.view];
    [self addActityTextInView:self.view text:NSLocalizedString(@"连接超时",nil) deleyTime:1.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


@end
