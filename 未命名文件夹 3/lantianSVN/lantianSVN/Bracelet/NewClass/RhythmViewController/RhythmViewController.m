//
//  RhythmViewController.m
//  Wukong
//
//  Created by apple on 2019/3/28.
//  Copyright © 2019 huichenghe. All rights reserved.
//

#import "RhythmViewController.h"
#import "DirtyView.h"

@interface RhythmViewController ()<BlutToothManagerDelegate>

//脏腑的view
@property (nonatomic, strong) DirtyView *dirtyView;

@end

@implementation RhythmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavWithTitle:@"节律" backButton:YES shareButton:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"kBleBoundPeripheralIdentifierString"];
        
        if (![EirogaBlueToothManager sharedInstance].isconnected) {
            if (value && ![value isEqualToString:@""])
            {
                [[PZBlueToothManager sharedInstance] connectWithUUID:value perName:nil Mac:nil];
            }
        }
    });
    self.view.backgroundColor = KCOLOR(45, 128, 251);
    [self setupView];
}

-(void)setupView{
    CGFloat backScrollViewY = SafeAreaTopHeight;
    CGFloat backScrollViewW = CurrentDeviceWidth;
    CGFloat backScrollViewH = CurrentDeviceHeight - SafeAreaTopHeight - SafeAreaBottomHeight;
    
    _dirtyView = [[DirtyView alloc] initWithFrame:CGRectMake(0, backScrollViewY, backScrollViewW, backScrollViewH)];
    _dirtyView.controller = self;
    [self.view addSubview:_dirtyView];
    
    UIButton *guideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:guideButton];
    guideButton.frame = CGRectMake(CurrentDeviceWidth - 45 - 30, 32, 20, 20);
    [guideButton setImage:[UIImage imageNamed:@"zy-black"] forState:UIControlStateNormal];
    [guideButton addTarget:self action:@selector(guideAction) forControlEvents:UIControlEventTouchUpInside];
    
}

//指引
- (void)guideAction{
    GuideLinesViewController *guide = [GuideLinesViewController new];
    guide.index = 0;
    guide.imageArr = @[@"jielv1",@"jielv2",@"jielv3"];
    [self.navigationController pushViewController:guide animated:YES];
}


@end
