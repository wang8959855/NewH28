//
//  NewFriendsViewController.m
//  Wukong
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "WLBarcodeViewController.h"
#import "FriendListCell.h"
#import "FriendDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "AttentionView.h"

@interface NewFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) AttentionView *attentionView;

@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UIButton *topButton1;
@property (weak, nonatomic) IBOutlet UIButton *topButton2;


@end

@implementation NewFriendsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[PSDrawerManager instance] cancelDragResponse];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[PSDrawerManager instance] beginDragResponse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubViews];
}

- (void)setSubViews{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 139;
    [self getFriendList];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendListCell *cell = [FriendListCell tableView:tableView identfire:@"listCell"];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:dic[@"friendimg"]]];
    cell.nickName.text = dic[@"friendName"];
    cell.heartRateLabel.text = [NSString stringWithFormat:@"%ld",[dic[@"friendHeartRate"] integerValue]];
    cell.sportsLabel.text = [NSString stringWithFormat:@"%ld",[dic[@"friendStep"] integerValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
    FriendDetailViewController *detail = [FriendDetailViewController new];
    detail.url = [NSString stringWithFormat:@"http://test07.lantianfangzhou.com/report/current/h28/%@/%@/%@",USERID,TOKEN,dic[@"friendid"]];
    [self.navigationController pushViewController:detail animated:YES];
}

//左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除好友？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    kWEAKSELF
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteInfo:indexPath.row];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//我的关注
- (IBAction)topAction1:(UIButton *)sender {
    sender.selected = YES;
    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.topButton2.selected = NO;
    [self.view sendSubviewToBack:self.attentionView];
}

//关注我的
- (IBAction)topAction2:(UIButton *)sender {
    sender.selected = YES;
    self.line2.hidden = NO;
    self.line1.hidden = YES;
    self.topButton1.selected = NO;
    [self.view bringSubviewToFront:self.attentionView];
}

//获取好友列表
- (void)getFriendList{
    [self.dataSource removeAllObjects];
    [self addActityIndicatorInView:self.view labelText:@"正在获取好友列表" detailLabel:@"正在获取好友列表"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/?token=%@",GETFRIENDLIST,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        if (error)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [self.dataSource addObjectsFromArray:responseObject[@"data"]];
                [self.tableView reloadData];
                
            } else {
                [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
            }
        }
    }];
}

- (void)deleteInfo:(NSInteger)row{
    NSDictionary *dic = self.dataSource[row];
    [self addActityIndicatorInView:self.view labelText:@"正在删除好友" detailLabel:@"正在删除好友"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/?token=%@",DELETEFRIEND,TOKEN];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", @"text/json", nil];
    [manager POST:uploadUrl parameters:@{@"userid":USERID,@"friendid":dic[@"friendid"]} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self removeActityIndicatorFromView:self.view];
        int code = [[responseObject objectForKey:@"code"] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 0) {
            [self.dataSource removeObjectAtIndex:row];
            [self.tableView reloadData];
            [self addActityTextInView:self.view text:@"删除成功" deleyTime:1.5f];
        } else {
            [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self removeActityIndicatorFromView:self.view];
        [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
    }];
}

//返回
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//扫一扫
- (IBAction)saoYiSao:(UIButton *)sender{
    WLBarcodeViewController *vc=[[WLBarcodeViewController alloc] initWithBlock:^(NSString *str, BOOL isScceed) {
        
        if (isScceed) {
            NSLog(@"扫描后的结果~%@",str);
//            NSString *str1 = [str substringFromIndex:15];
            [self addFriendWithId:str];
        }else{
            NSLog(@"扫描后的结果~%@",str);
            [self addActityTextInView:self.view text:@"无法识别" deleyTime:1.5f];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (AttentionView *)attentionView{
    if (!_attentionView) {
        _attentionView = [[AttentionView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenW, ScreenH-SafeAreaTopHeight)];
        _attentionView.vc = self;
        [self.view addSubview:_attentionView];
        [self.view sendSubviewToBack:_attentionView];
    }
    return _attentionView;
}

//添加好友
- (void)addFriendWithId:(NSString *)friendId{
    [self addActityIndicatorInView:self.view labelText:@"正在添加好友" detailLabel:@"正在添加好友"];
    [self performSelector:@selector(loginTimeOut) withObject:nil afterDelay:60.f];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@/?token=%@",ADDFRIEND,TOKEN];
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:uploadUrl fileUrl:nil params:@{@"userid":USERID,@"friendid":friendId} Block:^(id responseObject, NSError *error) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loginTimeOut) object:nil];
        
        [self removeActityIndicatorFromView:self.view];
        if (error)
        {
            [self addActityTextInView:self.view text:NSLocalizedString(@"网络连接错误", nil) deleyTime:1.5f];
        }
        else
        {
            int code = [[responseObject objectForKey:@"code"] intValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                [self addActityTextInView:self.view text:NSLocalizedString(@"添加成功", nil) deleyTime:1.5f];
                [self removeActityIndicatorFromView:self.view];
                [self getFriendList];
            } else {
                [self addActityTextInView:self.view text:NSLocalizedString(message, nil)  deleyTime:1.5f];
            }
        }
    }];
}

@end
