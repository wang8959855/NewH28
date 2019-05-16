//
//  BaseViewController.m
//  MasonryDemo
//
//  Created by 谢英泽 on 2016/11/11.
//  Copyright © 2016年 wtjr. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Color.h"
#import <UShareUI/UShareUI.h>
#import "AppDelegate.h"
#import "EditPersonalInformationOneViewController.h"
#import "MoreView.h"
#import "BaseWebViewController.h"

#define kCOLOR_BaseViewControllerBackground     [UIColor whiteColor]
#define kNav_BackIcon                           @"nav_back"

#define kImage_WithoutData                      @"wt_notData_header1"

//static CGFloat const kLeftWidthScale = 250.0/375.0;

@interface BaseViewController ()

@property (nonatomic, strong) UIImageView *RSSIImageView;

@property (nonatomic, assign) BOOL isC;

@end

@implementation BaseViewController

#pragma mark - *********************生命周期*********************

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self baseConfiguration];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:@"updateUserInfo" object:nil];
}

#pragma mark - *********************基础配置*********************

- (void)baseConfiguration
{
    //设置默认背景色
    self.view.backgroundColor = kCOLOR_BaseViewControllerBackground;

    //设置状态栏背景色跟内容一致
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //开启系统侧滑
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreView) name:@"PushMoreView" object:nil];
}

- (void)moreView{
    [MoreView moreView];
}

- (void)addNavWithTitle:(NSString *)title backButton:(BOOL)backButton shareButton:(BOOL)shareButton
{
    UIView *statuBarView = [[UIView alloc] init];
    statuBarView.backgroundColor = KCOLOR(6, 48, 46);
    statuBarView.frame = CGRectMake(0, 0, ScreenW, StatusBarHeight);
    [self.view addSubview:statuBarView];
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    navView.frame = CGRectMake(0, StatusBarHeight, ScreenW, 44);
    [self.view addSubview:navView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenW, 1)];
    line.backgroundColor = KCOLOR(222, 222, 222);
    [self.view addSubview:line];
    
    if (title && title.length != 0)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [navView addSubview:label];
        label.numberOfLines = 2;
        [label sizeToFit];
        label.sd_layout.centerXIs(ScreenW/2.)
        .centerYIs(22)
        .widthIs(150)
        .heightIs(44);
    }
    if (backButton)
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        backButton.tag = 10000;
        [navView addSubview:backButton];
        backButton.frame = CGRectMake(12, 7, 45, 30);
    }
    if (shareButton)
    {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"fenxiang-new"] forState:UIControlStateNormal];
        shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:shareButton];
        shareButton.frame = CGRectMake(ScreenW - 60, 0, 60, 44);
    }
}


- (void)addnavTittle:(NSString *)title RSSIImageView:(BOOL)RSSI shareButton:(BOOL)shareButton
{
    UIView *statuBarView = [[UIView alloc] init];
    statuBarView.backgroundColor = KCOLOR(44, 128, 251);
    statuBarView.frame = CGRectMake(0, 0, ScreenW, StatusBarHeight);
    [self.view addSubview:statuBarView];
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = kMainColor;
    navView.frame = CGRectMake(0, StatusBarHeight, ScreenW, 44);
    [self.view addSubview:navView];
    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 1)];
//    line.backgroundColor = KCOLOR(222, 222, 222);
//    [self.view addSubview:line];
    
    
    if (title && title.length != 0)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [navView addSubview:label];
        label.font = [UIFont systemFontOfSize:20];
        [label sizeToFit];
        label.sd_layout.centerXIs(ScreenW/2.)
        .centerYIs(22)
        .widthIs(label.width)
        .heightIs(30);
    }
    if (RSSI)
    {
        _RSSIImageView = [[UIImageView alloc] init];
        _RSSIImageView.userInteractionEnabled  =YES;
        _RSSIImageView.contentMode = UIViewContentModeScaleAspectFit;
        _RSSIImageView.image = [UIImage imageNamed:@"caidan"];
        _RSSIImageView.userInteractionEnabled = YES;
        
        UIImageView *click = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50 * kX, 44)];
        click.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick)];
        [click addGestureRecognizer:tap];
        
        [navView addSubview:_RSSIImageView];
        [navView addSubview:click];
//        int RSSI = [EirogaBlueToothManager sharedInstance].RSSI;
//        if (RSSI == 0)
//        {
//            _RSSIImageView.image = [UIImage imageNamed:@"RSSI0"];
//        }else if (RSSI > -60)
//        {
//            _RSSIImageView.image = [UIImage imageNamed:@"RSSI5"];
//        }else if(RSSI > -70)
//        {
//            _RSSIImageView.image = [UIImage imageNamed:@"RSSI4"];
//        }else if (RSSI > -80)
//        {
//            _RSSIImageView.image = [UIImage imageNamed:@"RSSI3"];
//        }else if (RSSI > -90)
//        {
//            _RSSIImageView.image = [UIImage imageNamed:@"RSSI2"];
//        }else if (RSSI > -100)
//        {
//            _RSSIImageView.image = [UIImage imageNamed:@"RSSI1"];
//        }else
//        {
//            _RSSIImageView.image = [UIImage imageNamed:@"RSSI0"];
//        }
        _RSSIImageView.sd_layout.leftSpaceToView(navView, 13 * kX)
        .centerYIs(navView.height/2.)
        .widthIs(20 * kX)
        .heightIs(20);
        
      
        [[EirogaBlueToothManager sharedInstance] addObserver:self forKeyPath:@"RSSI" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    if (shareButton)
    {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"yujing"] forState:UIControlStateNormal];
        shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [shareButton addTarget:self action:@selector(yujingAcition) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:shareButton];
        shareButton.frame = CGRectMake(ScreenW - 60, 0, 60, 44);
    }

}

- (void)yujingAcition{
    [self.view makeToastActivity];
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",GETWARNING,TOKEN];
    NSDictionary *para = @{@"userid":USERID};
    [[AFAppDotNetAPIClient sharedClient] globalRequestWithRequestSerializerType:nil ResponseSerializeType:nil RequestType:NSAFRequest_POST RequestURL:url ParametersDictionary:para Block:^(id responseObject, NSError *error, NSURLSessionDataTask *task) {
        [self.view hideToastActivity];
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            NSInteger warnNum = [responseObject[@"data"][@"warnNum"] integerValue];
            if (warnNum > 0) {
                BaseWebViewController *h5 = [BaseWebViewController new];
                h5.titleStr = @"预警记录";
                h5.urlStr = [NSString stringWithFormat:@"http://test07.lantianfangzhou.com/report/current/h28_/%@/%@/0?page=current",USERID,TOKEN];
                [self.navigationController pushViewController:h5 animated:YES];
            }else{
                [self.view makeToast:@"暂无预警记录" duration:1.5 position:CSToastPositionCenter];
            }
        }else{
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    int RSSI = [EirogaBlueToothManager sharedInstance].RSSI;
//    if (RSSI == 0)
//    {
//        _RSSIImageView.image = [UIImage imageNamed:@"RSSI0"];
//    }else if (RSSI > -60)
//    {
//        _RSSIImageView.image = [UIImage imageNamed:@"RSSI5"];
//    }else if(RSSI > -70)
//    {
//        _RSSIImageView.image = [UIImage imageNamed:@"RSSI4"];
//    }else if (RSSI > -80)
//    {
//        _RSSIImageView.image = [UIImage imageNamed:@"RSSI3"];
//    }else if (RSSI > -90)
//    {
//        _RSSIImageView.image = [UIImage imageNamed:@"RSSI2"];
//    }else if (RSSI > -100)
//    {
//        _RSSIImageView.image = [UIImage imageNamed:@"RSSI1"];
//    }
}

- (void)leftButtonClick {
    if (self.isC) {
        [UIView animateWithDuration:0.3f animations:^{
            
            AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
            app.mainTabBarController.view.transform = CGAffineTransformIdentity;
            app.coverBtn.hidden = YES;
        }];
    }else{
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [UIView animateWithDuration:0.3f animations:^{
            
            CGAffineTransform rightScopeTransform = CGAffineTransformTranslate([tempAppDelegate window].transform, CurrentDeviceWidth * kLeftWidthScale, 0);
            
            
            tempAppDelegate.mainTabBarController.view.transform = rightScopeTransform;
            
        }completion:^(BOOL finished) {
            tempAppDelegate.coverBtn.hidden = NO;
        }];
    }
    self.isC = !self.isC;
}

- (void)shareButtonClick
{
    //    NSString *textString = @"LingYue";
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenW, ScreenH), NO, 0.0);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *activityItems = @[viewImage];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionWithItemsHandler = myBlock;
    }else{
        //此Block回调方法在iOS8.0之后就弃用了，被上面的所取代
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionHandler = myBlock;
    };
    
    //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
    
}


- (void)dealloc
{
    if (_RSSIImageView)
    {
        [[EirogaBlueToothManager sharedInstance] removeObserver:self forKeyPath:@"RSSI"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)backBarButtonPressed:(UIButton *)button
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - *********************基础方法*********************

#pragma mark - 跳转

-(void)modal:(UIViewController *)modal from:(UIViewController*)from
{
    from.hidesBottomBarWhenPushed = YES;
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:modal];
    [from presentViewController:navi animated:YES completion:nil];
}

-(void)push:(UIViewController*)push from:(UINavigationController *)from
{
    [push setHidesBottomBarWhenPushed:YES];
    [from pushViewController:push animated:YES];
}

#pragma mark - 设置导航栏返回按钮



-(void)onNaviBack
{
    [self finishNavi];
}

-(void)finishNavi
{
    if (self.navigationController) {
        if ([self.navigationController.viewControllers firstObject] == self) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}





#pragma mark - 跳转到注册登录


#pragma mark - 没有数据提示页面


#pragma mark -- hud相关
- (void)addActityIndicatorInView :(UIView *)view labelText : (NSString *)labelString detailLabel : (NSString *)detailString{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    //    hud.dimBackground = YES ;
    
    if(labelString != nil)
        //        hud.labelText =  labelString ;
        hud.label.text = labelString;
    if(detailString != nil)
        //        hud.detailsLabelText = detailString ;
        hud.detailsLabel.text = detailString;
    hud.square = YES;
//    hud.contentColor = [UIColor blackColor];
    
    [view addSubview:hud];
    //    [hud show:YES];
    [hud showAnimated:YES];
}

- (void)removeActityIndicatorFromView : (UIView *)view{
    for( UIView *viewInView in [view subviews]){
        if( [viewInView isKindOfClass:[MBProgressHUD class] ]){
            [viewInView removeFromSuperview];
            break;
        }
    }
}

- (void)addActityTextInView : (UIView *)view text : (NSString *)textString deleyTime : (float)times {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = textString ;
    hud.label.text = textString;
    hud.margin = 10.f;
    //    	hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.square = YES;
    //    [hud hide:YES afterDelay:times];
    [hud hideAnimated:YES afterDelay:times];
}

#pragma mark -- 设置frame
- (CGRect)setCGRectWithX:(float)x Y:(float)Y Width:(float)width Heigth:(float)height
{
    return CGRectMake(x * kX, Y * kX, kX * width, kX * height);
}

#pragma mark -- 设置placeholderLabel

- (void)configTextField:(UITextField *)textFiled
{
    [textFiled setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [textFiled setValue:[UIFont systemFontOfSize:17] forKeyPath:@"_placeholderLabel.font"];
}

-(UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        activityView.center = self.view.center;
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        //        activityView.hidden = YES;
        [self.view addSubview:activityView];
        
        _activityView = activityView;
    }
    return _activityView;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIResponder *)checkNextResponderIsKindOfViewController : (Class)viewClass{
    UIResponder *reResponder = nil ;
    
    for (UIView* next = self.view.superview ; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass: viewClass ]) {
            reResponder = nextResponder ;
            
            break;
        }
    }
    
    return reResponder ;
}

- (void)showAlertView:(NSString *)string
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:string delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self performSelector:@selector(hidenAlertView:) withObject:alertView afterDelay:2.];
}

- (void)hidenAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)setButtonWithButton:(UIButton *)button andTitle:(NSString *)string
{
    [button setBackgroundColor:kColor(73, 126, 227)];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
}

#pragma mark - 判断帐号密码
- (BOOL) isUserName:(NSString *)userName
{
    
    if (userName.length == 0)
    {
        //        [self showAlertView:NSLocalizedString( @"帐号不能为空，请输入不少于4个字符的帐号", nil)];
        return NO;
    }
    else
    {
        if (userName.length<4 || userName.length>32)
        {
            //            [self showAlertView:NSLocalizedString(@"帐号输入错误，请输入不少于4个字符的帐号", nil) ];
            return NO;
        }
        NSString * regex = @"([A-Za-z0-9\_]{4,32}$)";
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        //        BOOL isRight = [pred evaluateWithObject:userName];
        if (![pred evaluateWithObject:userName])
        {
            //            [self showAlertView:NSLocalizedString(@"帐号输入只允许大小写字母、数字、下划线", nil) ];
            return NO;
        }
    }
    return YES;
}



- (BOOL) isPassWord:(NSString *)passWord
{
    if (passWord.length == 0)
    {
        //        [self showAlertView:NSLocalizedString(@"密码不能为空，请输入不少于6个字符的密码", nil) ];
        return NO;
    }
    else if (passWord.length < 6)
    {
        //        [self showAlertView:NSLocalizedString(@"密码输入错误，请输入不少于6个字符的密码", nil) ];
        return NO;
    }
    return YES;
}
- (BOOL) checkUserName:(NSString *)userName
{
    if (userName.length == 0)
    {
        [self showAlertView:NSLocalizedString( @"手机号不能为空", nil)];
        return NO;
    }
    else
    {
        if (userName.length != 11)
        {
            [self showAlertView:NSLocalizedString(@"请输入正确的手机号", nil) ];
            return NO;
        }
    }
    return YES;
    
}

- (BOOL) checkPassWord:(NSString *)passWord
{
    if (passWord.length == 0)
    {
        [self showAlertView:NSLocalizedString(@"验证码不能为空", nil) ];
        return NO;
    }
    return YES;
    
}

#pragma mark - 获取用户信息
- (void)getUserInfo{
    NSString *url = [NSString stringWithFormat:@"%@/?token=%@",GETUSERINFO,TOKEN];
    if (!USERID) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userid"];
        return;
    }
    NSLog(@"%@",USERID);
    kWEAKSELF;
    [[AFAppDotNetAPIClient sharedClient] globalmultiPartUploadWithUrl:url fileUrl:nil params:@{@"userid":USERID} Block:^(id responseObject, NSError *error) {
        if (error){
            [weakSelf removeActityIndicatorFromView:weakSelf.view];
            [weakSelf addActityTextInView:self.view text:NSLocalizedString(@"服务器异常", ni) deleyTime:1.5f];
        }else{
            NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 0) {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
                for (NSString *str in [tempDic allKeys]) {
                    if ((NSNull *)tempDic[str] == [NSNull null]) {
                        [tempDic setValue:@"" forKey:str];
                    }
                }
                [HCHCommonManager getInstance].userInfoDictionAry = [NSMutableDictionary dictionaryWithDictionary:tempDic];
                [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:@"loginCache"];
                
                if ([tempDic[@"Name"] length] == 0) {
                    EditPersonalInformationOneViewController *editVC = [[UIStoryboard storyboardWithName:@"EditPersonalInformationViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"EditPersonalOne"];
                    editVC.uploadInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:USERID ,@"userid", nil];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editVC];
                    [self setRootViewController:nav animationType:nil];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UserInformationUpDateNotification object:nil];
            }else if (code == 1001){
                [[NSNotificationCenter defaultCenter] postNotificationName:changeLoginNofication object:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [self performSelector:@selector(dimissAlertController:) withObject:alert afterDelay:1.5];
            }
        }
    }];
}

- (void)dimissAlertController:(UIAlertController *)alert{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 更换主页面
- (void)setRootViewController:(UIViewController *)viewController animationType:(NSString *)animationType
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    CATransition *animation = [CATransition  animation ];
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.25;
    animation.type = kCATransitionPush;
    [window.layer addAnimation:animation forKey:nil];
    window.rootViewController = viewController;
}

- (void)loginTimeOut{
    [self removeActityIndicatorFromView:self.view];
    [self addActityTextInView:self.view text:NSLocalizedString(@"请求失败", nil)  deleyTime:1.5f];
}

@end
