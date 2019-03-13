//
//  TakePhotoViewController.m
//  WMCamera
//
//  Created by SZCE on 15/12/9.
//  Copyright (c) 2015年 xiaoxia liu. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "WMCameraSet.h"
#import "WMRecordManager.h"
#import <AVFoundation/AVFoundation.h>
#import "WJPhotoTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SGImagePickerController/SGCollectionController.h"

@interface TakePhotoViewController () <WMRecordManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *flashStateButton;

@property (strong, nonatomic) WMRecordManager *recordManager;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (weak, nonatomic) IBOutlet UIButton *closeTag;
@property (weak, nonatomic) IBOutlet UIButton *toggleTag;
@property (weak, nonatomic) IBOutlet UIButton *photoShowBtn;
@property (nonatomic ,strong) NSMutableArray *groups;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;


@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self configureBase];
    [self configureNoti];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto) name:@"takePhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto) name:@"zipai" object:nil];
}

//视图消失，销毁通知
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _recordManager.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto) name:@"takePhoto" object:nil];
    
    [self groups];
    [self configureBase];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [WJPhotoTool latestAsset:^(WJAsset * _Nullable asset) {
        if(asset.image == nil)
        {
            [self.photoShowBtn setBackgroundImage:[UIImage imageNamed:@"cam_picture"] forState:UIControlStateNormal];
        }
        else
        {
            [self.photoShowBtn setBackgroundImage:asset.image forState:UIControlStateNormal];
        }
    }];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
        
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - action

- (IBAction)flashStateClick:(id)sender {
    CameraFlashState newState = [WMCameraSet cameraFlashState] << 1;
    [WMCameraSet setCameraFlashState:newState];
    
    [self reloadCameraFlashState];
}

- (IBAction)closeClick:(id)sender {
    if (sender)
    {
        [[PZBlueToothManager sharedInstance] changetakePhoteStateWithState:NO];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.navigationController)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
            [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)toggleCameraClick:(id)sender {
    
    [_recordManager toggleCamera];
    
    [self autoFocus];
}


- (IBAction)takePhotographClick:(id)sender {
    [self takePhoto];
}

- (IBAction)photosClick:(id)sender {
    
    if (_groups.count != 0)
    {
        SGCollectionController *collectionVC = [[SGCollectionController alloc] init];
        collectionVC.maxCount = 4;
        collectionVC.group = _groups[0];
        self.navigationController.navigationBar.hidden = NO;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = NSLocalizedString(@"返回", nil);
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController pushViewController:collectionVC animated:YES];
    }
}

#pragma mark - Assistor

- (void)takePhoto {
    [_recordManager captureStillImage];
    
    UIView *flashView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    flashView.backgroundColor = [UIColor whiteColor];
    [self.view.window addSubview:flashView];
    
    [UIView animateWithDuration:0.3f animations:^ {
        [flashView setAlpha:0];
    } completion:^ (BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

- (void)reloadCameraFlashState {
    CameraFlashState state = [WMCameraSet cameraFlashState];
    
    NSString *stateText = [NSString string];
    AVCaptureFlashMode flashMode;
    //    AVCaptureTorchMode torchMode;
    
    switch (state) {
        case CameraFlashStateAuto: {
            stateText = NSLocalizedString(@"自动", @"");
            flashMode = AVCaptureFlashModeAuto;
            //            torchMode = AVCaptureTorchModeAuto;
            break;
        }
        case CameraFlashStateON: {
            stateText = NSLocalizedString(@"开", @"");
            flashMode = AVCaptureFlashModeOn;
            //            torchMode = AVCaptureTorchModeOn;
            break;
        }
        case CameraFlashStateOFF: {
            stateText = NSLocalizedString(@"关", @"");
            flashMode = AVCaptureFlashModeOff;
            //            torchMode = AVCaptureTorchModeOff;
            break;
        }
    }
    
    // 赋值时不闪动, 则以下两值均要赋予
    _flashStateButton.titleLabel.text = stateText;
    [_flashStateButton setTitle:stateText forState:UIControlStateNormal];
    
    [_recordManager updateCaptureFlashMode:flashMode captureTorchMode:AVCaptureTorchModeAuto];
}

- (void)autoFocus {
    if ([_recordManager.videoInput.device isFocusPointOfInterestSupported]) {
        [_recordManager continuousFocusAtPoint:CGPointMake(0.5f, 0.5f)];
    }
}

#pragma mark - WMRecordManagerDelegate

- (void)recordManagerStillImageCaptured:(WMRecordManager *)recordManager
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [WJPhotoTool latestAsset:^(WJAsset * _Nullable asset) {
            [self.photoShowBtn setBackgroundImage:asset.image forState:UIControlStateNormal];
        }];
    });
    
}

#pragma mark - Configure

- (void)configureBase {
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // Localizable
    [_closeTag setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    
    [self reloadCameraFlashState];
    //
    self.view.backgroundColor = [UIColor blackColor];
    
    [self configureCamera];
}

- (void)configureCamera {
    if (!_recordManager) {
        _recordManager = [[WMRecordManager alloc] init];
        _recordManager.delegate = self;
        if ([_recordManager setupSession]) {
            _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_recordManager.session];
            _previewLayer.frame = [UIScreen mainScreen].bounds;
            [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [self.view.layer insertSublayer:_previewLayer atIndex:0];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
                [_recordManager.session startRunning];
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self reloadCameraFlashState];
                });
            });
            
            [self autoFocus];
        }
    }
}

- (void)configureNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleProtocolNotiTakePhoto) name:kBLEProtocolNotiTakePhoto object:nil];
}

- (ALAssetsLibrary *)assetsLibrary{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    [_groups removeAllObjects];

    dispatch_async(dispatch_get_main_queue(), ^{

        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if(group){
                [_groups addObject:group];
                //                UIImage *image =[UIImage imageWithCGImage:group.posterImage] ;
            }
        } failureBlock:^(NSError *error) {
            adaLog(@"%@",error);
        }];
    });
    
    return _groups;
}


#pragma mark - Selector
- (void)applicationDidEnterBackgroundNotification {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.navigationController popViewControllerAnimated:NO];
    });
}

- (void)applicationWillEnterForegroundNotification {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self configureCamera];
    });
}

//- (void)bleProtocolNotiTakePhoto {
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        [self takePhoto];
//    });
//}
@end
