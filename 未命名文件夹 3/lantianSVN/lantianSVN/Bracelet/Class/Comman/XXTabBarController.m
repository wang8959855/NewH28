//
//  XXTabBarController.m
//  Bracelet
//
//  Created by SZCE on 16/1/12.
//  Copyright © 2016年 xiaoxia liu. All rights reserved.
//

#import "XXTabBarController.h"
#import "XXNavigationController.h"
#import "HomeView.h"


@interface XXTabBarController ()

@end

@implementation XXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化子控制器
        [self initTabBarSubControler];
        
        //初始化tabBar的属性和状态
        [self initTabBar];
        
    }
    return self;
}

#pragma mark - initialize

/**
 *  初始化子控制器
 */
- (void)initTabBarSubControler{
    
    /**
     *  根据plist中的数组对象静态的添加控制器数量
     */
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TabBarPlist" ofType:@"plist"]];
    
    for (NSDictionary *dict in arr) {
        [self addchildControllerWithClass:NSClassFromString(dict[@"class"]) andTitle:dict[@"title"] andImageName:dict[@"imageName"] andSelectImageName:dict[@"selectImageName"]];
    }
}
        
/**
 *  初始化tabBar的属性和状态
 */
- (void)initTabBar{
    //设置tabbar文字颜色
    self.tabBar.tintColor = [UIColor whiteColor];
    
    //设置tabBar是否透明
    self.tabBar.backgroundImage = [self imageWithColor:kmainBackgroundColor];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}   forState:UIControlStateNormal];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0.0f, -0.5f, self.tabBar.bounds.size.width, 0.5f)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar insertSubview:line atIndex:1];
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

#pragma mark - 添加子控制器

/**
 *  添加TabBar控制器的子控制器
 *
 *  @param cls             子控制器的类对象
 *  @param title           tabbar显示的标题
 *  @param imageName       tabbar图片的名称
 *  @param selectImageName tabbar被选时图片的名字
 *
 *  @return 装载成功的字控制器
 */
- (UIViewController *)addchildControllerWithClass:(id)cls andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImageName:(NSString *)selectImageName
{
    UIViewController *viewController = [[cls alloc]init];
    
    XXNavigationController *nav = [[XXNavigationController alloc]initWithRootViewController:viewController];
    viewController.navigationController.navigationBar.hidden = YES;
    [self addChildViewController:nav];
    
    //    设置文字
    viewController.title = NSLocalizedString(title, nil);
    //    设置默认图片，图片颜色为原始颜色，不着色
    viewController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    设置选中图片，图片颜色为原始颜色，不着色
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return viewController;
}

-(UIButton *)coverBtn
{
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc]init];
        _coverBtn.backgroundColor = [UIColor grayColor];
        _coverBtn.alpha = 0.3;
        _coverBtn.frame = CGRectMake(0, 0, CurrentDeviceWidth, CurrentDeviceHeight);
        _coverBtn.hidden = YES;
        [_coverBtn addTarget:self action:@selector(coverBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}
-(void)coverBtnAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.3f animations:^{
        
        AppDelegate *app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.mainTabBarController.view.transform = CGAffineTransformIdentity;
        app.coverBtn.hidden = YES;
    }];
    
    //adaLog(@"----    - - - - 点击的关闭侧滑！！");
}

@end
