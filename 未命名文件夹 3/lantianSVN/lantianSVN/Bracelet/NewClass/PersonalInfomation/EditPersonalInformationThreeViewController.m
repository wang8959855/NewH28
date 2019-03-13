//
//  EditPersonalInformationThreeViewController.m
//  Wukong
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 huichenghe. All rights reserved.
//

#import "EditPersonalInformationThreeViewController.h"
#import "AFAppDotNetAPIClient1.h"
#import "BMIViewController.h"

@interface EditPersonalInformationThreeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *selectXieYi;


@end

@implementation EditPersonalInformationThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.versionLabel.text = showAppVersion;
    [self performSelector:@selector(setSubViews) withObject:nil afterDelay:0.5];
}

- (void)setSubViews{
    self.completeButton.layer.mask = [AllTool getCornerRoundWithSelfView:self.completeButton byRoundingCorners:UIRectCornerBottomLeft |UIRectCornerBottomRight cornerRadii:CGSizeMake(8,8)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)uploadInfoDic {
    if (!_uploadInfoDic) {
        _uploadInfoDic = [NSMutableDictionary dictionary];
    }
    return _uploadInfoDic;
    
}

#pragma mark - 点击事件
//完成
- (IBAction)completeClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (![self checkUserName:self.rafTel1TF.text]) {
        return;
    }
    if (!self.selectXieYi.selected) {
        [self addActityTextInView:self.view text:@"请先同意协议" deleyTime:1.5f];
        return;
    }
    [self.uploadInfoDic setObject:self.rafTel1TF.text forKey:@"friendTel1"];
    if (self.rafTel2TF.text.length == 11) {
        [self.uploadInfoDic setObject:self.rafTel2TF.text forKey:@"friendTel2"];
    }
    if (self.rafTel3TF.text.length == 11) {
        [self.uploadInfoDic setObject:self.rafTel3TF.text forKey:@"friendTel3"];
    }
    [self.uploadInfoDic setObject:USERID forKey:@"userid"];
    [self.uploadInfoDic setObject:@(false) forKey:@"is_Glu"];
    
//    [self.uploadInfoDic setObject:SystolicPressure forKey:@"systolicP"];
//    [self.uploadInfoDic setObject:DiastolicPressure forKey:@"diastolicP"];
//    [self.uploadInfoDic setObject:@"6" forKey:@"Glu"];
    
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",UPLOADUSERINFO,TOKEN];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html", @"text/json", nil];
    kWEAKSELF;
    [manager POST:url parameters:self.uploadInfoDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int code = [[responseObject objectForKey:@"code"] intValue];
        NSString *message = [responseObject objectForKey:@"message"];
        if (code == 0) {
            [weakSelf addActityTextInView:weakSelf.view text:NSLocalizedString(@"上传成功", nil) deleyTime:1.5f];
            [HCHCommonManager getInstance].isLogin = YES;
//            [[NSNotificationCenter defaultCenter] postNotificationName:changeMainNofication object:nil];
            BMIViewController *bmi = [BMIViewController new];
            bmi.height = [self.uploadInfoDic[@"height"] floatValue];
            bmi.weight = [self.uploadInfoDic[@"weight"] floatValue];
            [self.navigationController pushViewController:bmi animated:YES];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf removeActityIndicatorFromView:weakSelf.view];
        [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", ni) deleyTime:1.5f];
        [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:LastLoginUser_Info];
    }];
    
}


//返回
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//协议
- (IBAction)xieyiAction:(UIButton *)sender {
}

//选择协议
- (IBAction)selectXieyi:(UIButton *)sender {
    sender.selected = !sender.selected;
}


-(void)dimissAlertController:(UIAlertController *)alert {
    if(alert)
    {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
