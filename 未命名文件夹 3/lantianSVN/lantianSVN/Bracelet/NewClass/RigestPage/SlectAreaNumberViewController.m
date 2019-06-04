//
//  SlectAreaNumberViewController.m
//  Bracelet
//
//  Created by apple on 2019/6/4.
//  Copyright © 2019 com.czjk.www. All rights reserved.
//

#import "SlectAreaNumberViewController.h"

@interface SlectAreaNumberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation SlectAreaNumberViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择区号";
    [self getData];
    [self setSubbViews];
}

- (void)setSubbViews{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight-SafeAreaTopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.array.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *count = self.array[section][@"data"];
    return count.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *staticCell = @"sCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:staticCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:staticCell];
    }
    
    NSDictionary *dic = self.array[indexPath.section][@"data"][indexPath.row];
    cell.textLabel.text = dic[@"countryName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",dic[@"phoneCode"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.array[indexPath.section][@"data"][indexPath.row];
    if (self.backAreaNumBlock) {
        self.backAreaNumBlock(dic[@"phoneCode"]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 20)];
    [header addSubview:titleL];
    titleL.text = self.array[section][@"key"];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor grayColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)getData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"chineseCountryJson" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.array = [self jsonStringToKeyValues:content];
    
    [self.tableView reloadData];
}

//json字符串转化成OC键值对
- (id)jsonStringToKeyValues:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = nil;
    if (JSONData) {
        responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    }
    return responseJSON;
}

@end
