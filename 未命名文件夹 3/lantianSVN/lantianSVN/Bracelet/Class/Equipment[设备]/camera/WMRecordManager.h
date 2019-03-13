//
//  WMRecordManager.h
//  WMCamera
//
//  Created by SZCE on 15/12/9.
//  Copyright (c) 2015年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


@class WMRecordManager;
@class WMRecorder;

@protocol WMRecordManagerDelegate <NSObject>

@optional

- (void)recordManager:(WMRecordManager *)recordManager didFailWithError:(NSError *)error;

- (void)recordManagerRecordingBegan:(WMRecordManager *)recordManager;

- (void)recordManagerRecordingFinished:(WMRecordManager *)recordManager;

- (void)recordManagerStillImageCaptured:(WMRecordManager *)recordManager;

- (void)recordManagerDeviceConfigurationChanged:(WMRecordManager *)recordManager;

@end

@interface WMRecordManager : NSObject

// AVCaptureSession 对象, 管理输入设备到输出端的数据
@property (strong, nonatomic) AVCaptureSession *session;
@property (assign, nonatomic) AVCaptureVideoOrientation orientation;
// 捕捉视频和音频的设备
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
// 定义输出静态照片的输出端
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) WMRecorder *recorder;
@property (assign, nonatomic) id deviceConnectedObserver;
@property (assign, nonatomic) id deviceDisconnectedObserver;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (assign, nonatomic) id <WMRecordManagerDelegate> delegate;

- (BOOL)setupSession;

//- (void)startRecording;

//- (void)stopRecording;

/** 照相 */
- (void)captureStillImage;

/** 切换摄像头 */
- (BOOL)toggleCamera;

- (void)updateCaptureFlashMode:(AVCaptureFlashMode)flashMode captureTorchMode:(AVCaptureTorchMode)torchMode;

- (NSUInteger)cameraCount;

- (NSUInteger)micCount;

- (void)autoFocusAtPoint:(CGPoint)point;

- (void)continuousFocusAtPoint:(CGPoint)point;

@end
