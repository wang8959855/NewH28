//
//  LXXIntroductionViewController.m
//  
//
//  Created by 刘晓霞 on 15/4/23.
//
//

#import "LXXIntroductionViewController.h"

@interface LXXIntroductionViewController () <UIScrollViewDelegate>
{
    NSInteger _pageCount;
}
/**页面控制控件*/
@property(nonatomic,weak)UIPageControl * pageControl;

@end

@implementation LXXIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageCount = 3;
    
    //    创建scrollerView
    UIScrollView *scrollerView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollerView];
    
    scrollerView.frame = [UIScreen mainScreen].bounds;
    
    //    添加照片
    CGFloat imageW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageH = [UIScreen mainScreen].bounds.size.height;
    
    for (int i = 1; i <= _pageCount; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Guide-page-%d",i]];
        imageView.image = image;
        
        imageView.frame = CGRectMake(imageW * (i-1) , 0, imageW, imageH);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [scrollerView addSubview:imageView];
    }
    
    //    设置属性
    scrollerView.contentSize = CGSizeMake(imageW * _pageCount, 0);
    scrollerView.pagingEnabled = YES;
    scrollerView.bounces = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.delegate = self;
    
    //    添加页面控制控件
    UIPageControl * pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, 0, 0)];
    pageControl.center = CGPointMake(self.view.center.x, pageControl.center.y);
    pageControl.numberOfPages = _pageCount;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:pageControl];
    _pageControl = pageControl;
    
    //   添加进入按钮
    UIButton *enterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 88, 200, 33)];
    enterButton.center = CGPointMake(imageW *(_pageCount - 1) + self.view.center.x, enterButton.center.y);
    [enterButton setBackgroundColor:[UIColor redColor]];
    [enterButton setTitle:NSLocalizedString(@"立即体验", nil) forState:UIControlStateNormal];
    [scrollerView addSubview:enterButton];
    [enterButton addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    1、取得偏移量
    CGPoint contentOffSet = scrollView.contentOffset;
    
    //    2、根据偏移量计算当前显示在第几页
    NSInteger page = (contentOffSet.x + scrollView.frame.size.width * 0.5) /scrollView.frame.size.width;
    //    3、修改pageContorl的指示
    self.pageControl.currentPage = page;
}

-(void)enter
{
    if (self.DidSeclectEnterBlock) {
        
        self.DidSeclectEnterBlock();
    }
    
}

-(void)setEnterBlock:(DidSeclectEnterBlock)didSeclectEnterBlock
{
    self.DidSeclectEnterBlock = didSeclectEnterBlock;
}

@end
