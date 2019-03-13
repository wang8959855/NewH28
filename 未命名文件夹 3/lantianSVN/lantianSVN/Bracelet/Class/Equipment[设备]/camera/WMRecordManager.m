//
//  WMRecordManager.m
//  WMCamera
//
//  Created by SZCE on 15/12/9.
//  Copyright (c) 2015年 xiaoxia liu. All rights reserved.
//

#import "WMRecordManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WMRecorder.h"

@interface WMRecordManager (InternalUtilityMethods) <WMRecorderDelegate>

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;

- (AVCaptureDevice *)frontFacingCamera;

- (AVCaptureDevice *)backFacingCamera;

//- (AVCaptureDevice *)audioDevice;

- (NSURL *)tempFileURL;

- (void)removeFile:(NSURL *)outputFileURL;

- (void)copyFileToDocuments:(NSURL *)fileURL;

@end

@implementation WMRecordManager

- (id)init {
    self = [super init];
    
    if (self) {
        __block id weakSelf = self;
        
        // 定义输入设备连接执行时的代码块
        void (^ deviceConnectedBlock) (NSNotification *) = ^ (NSNotification *notification) {
            AVCaptureDevice *device = [notification object];
            BOOL sessionHasDeviceWithMatchingMediaType = NO;
            // 定义输入设备的类型
            NSString *deviceMediaType = nil;
            
            if ([device hasMediaType:AVMediaTypeAudio]) {
                deviceMediaType = AVMediaTypeAudio;
            } else if ([device hasMediaType:AVMediaTypeVideo]) {
                deviceMediaType = AVMediaTypeVideo;
            }
            
            // 如果输入设备类型不为 NIL
            if (deviceMediaType) {
                for (AVCaptureDeviceInput *input in _session.inputs) {
                    if ([input.device hasMediaType:deviceMediaType]) {
                        sessionHasDeviceWithMatchingMediaType = YES;
                        break;
                    }
                }
            }
            
            if (!sessionHasDeviceWithMatchingMediaType) {
                NSError *error;
                AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                
                if ([_session canAddInput:input]) {
                    [_session addInput:input];
                }
            }
            
            if ([_delegate respondsToSelector:@selector(recordManagerDeviceConfigurationChanged:)]) {
                [_delegate recordManagerDeviceConfigurationChanged:self];
            }
        };
        
        // 定义输入设备断开连接时的代码块
        void (^ deviceDisconnectedBlock) (NSNotification *) = ^ (NSNotification *notification) {
            AVCaptureDevice *device = [notification object];
            
            if ([device hasMediaType:AVMediaTypeVideo]) {
                [_session removeInput:[weakSelf videoInput]];
                [weakSelf setVideoInput:nil];
            } else if ([device hasMediaType:AVMediaTypeAudio]) {
                [_session removeInput:[weakSelf audioInput]];
                [weakSelf setAudioInput:nil];
            }
            
            if ([_delegate respondsToSelector:@selector(recordManagerDeviceConfigurationChanged:)]) {
                [_delegate recordManagerDeviceConfigurationChanged:self];
            }
        };
        
        // 定义通知中心
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [self setDeviceConnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:nil usingBlock:deviceConnectedBlock]];
        [self setDeviceDisconnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:nil usingBlock:deviceDisconnectedBlock]];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
//        [notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        _orientation = AVCaptureVideoOrientationPortrait;
    }
    
    return self;
}

- (void)updateCaptureFlashMode:(AVCaptureFlashMode)flashMode captureTorchMode:(AVCaptureTorchMode)torchMode {
    //如果后置有闪光灯
    if([self.backFacingCamera hasFlash]){
        if([self.backFacingCamera lockForConfiguration:nil]){
            if([self.backFacingCamera isFlashModeSupported:flashMode]){
                [self.backFacingCamera setFlashMode:flashMode];
            }
            [self.backFacingCamera unlockForConfiguration];
        }
    }
    //如果后置有电筒
    if([self.backFacingCamera hasTorch]){
        if([self.backFacingCamera lockForConfiguration:nil]){
            if ([self.backFacingCamera isTorchModeSupported:torchMode]) {
                [self.backFacingCamera setTorchMode:torchMode];
            }
        }
    }
}

- (BOOL)setupSession {
    BOOL success = NO;
    
//    //如果后置有闪光灯
//    if([self.backFacingCamera hasFlash]){
//        if([self.backFacingCamera lockForConfiguration:nil]){
//            if([self.backFacingCamera isFlashModeSupported:AVCaptureFlashModeAuto]){
//                [self.backFacingCamera setFlashMode:AVCaptureFlashModeAuto];
//            }
//            [self.backFacingCamera unlockForConfiguration];
//        }
//    }
//    //如果后置有电筒
//    if([self.backFacingCamera hasTorch]){
//        if([self.backFacingCamera lockForConfiguration:nil]){
//            if ([self.backFacingCamera isTorchModeSupported:AVCaptureTorchModeAuto]) {
//                [self.backFacingCamera setTorchMode:AVCaptureTorchModeAuto];
//            }
//        }
//    }
    
    [self updateCaptureFlashMode:AVCaptureFlashModeAuto captureTorchMode:AVCaptureTorchModeAuto];
    
    // 初始化输入设备
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
//    AVCaptureDeviceInput *newAudioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil];
    
    // 设置静态照片的输出端
    AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    // 设置输出照片的格式
    NSDictionary *outputSettings = @{AVVideoCodecJPEG : AVVideoCodecKey};
    [newStillImageOutput setOutputSettings:outputSettings];
    
    // 创建 AVCaptureSession
    AVCaptureSession *newCaptureSession = [[AVCaptureSession alloc] init];
    
    // 将输入, 输出设备添加到 AVCaptureSession 中
    if ([newCaptureSession canAddInput:newVideoInput]) {
        [newCaptureSession addInput:newVideoInput];
    }
//    if ([newCaptureSession canAddInput:newAudioInput]) {
//        [newCaptureSession addInput:newAudioInput];
//    }
    if ([newCaptureSession canAddOutput:newStillImageOutput]) {
        [newCaptureSession addOutput:newStillImageOutput];
    }
    
    [self setStillImageOutput:newStillImageOutput];
    [self setVideoInput:newVideoInput];
//    [self setAudioInput:newAudioInput];
    [self setSession:newCaptureSession];
    
    // 设置视频的输出设备
    // 不写 我只写照相
    
    success = YES;
    return success;
}

- (void)captureStillImage {
    AVCaptureConnection *stillImageConnection = [WMRecorder connectionWithMediaType:AVMediaTypeVideo fromConnections:[self stillImageOutput].connections];
    
    if ([stillImageConnection isVideoOrientationSupported]) {
        [stillImageConnection setVideoOrientation:_orientation];
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^ (CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        ALAssetsLibraryWriteImageCompletionBlock completionBlock = ^ (NSURL *assetURL, NSError *error) {
            if (error) {
                if ([_delegate respondsToSelector:@selector(recordManager:didFailWithError:)]) {
                    [_delegate recordManager:self didFailWithError:error];
                }
            } else {
                
                if (_delegate && [_delegate respondsToSelector:@selector(recordManagerStillImageCaptured:)]) {
                    [_delegate recordManagerStillImageCaptured:self];
                }
            }
        };
        
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:completionBlock];
        } else {
            completionBlock(nil, error);
        }
    }];
}
- (BOOL)toggleCamera {
    BOOL success = NO;
    
    if ([self cameraCount] > 1) {
        NSError *error;
        
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [_videoInput.device position];
        
        if (position == AVCaptureDevicePositionBack) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        } else if (position == AVCaptureDevicePositionFront) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        } else {
            return success;
        }
        
        if (newVideoInput) {
            [_session beginConfiguration];
            [_session removeInput:_videoInput];
            if ([_session canAddInput:newVideoInput]) {
                [_session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [_session addInput:_videoInput];
            }
            
            [_session commitConfiguration];
            success = YES;
        } else if (error) {
            if ([_delegate respondsToSelector:@selector(recordManager:didFailWithError:)]) {
                [_delegate recordManager:self didFailWithError:error];
            }
        }
    }
    
    return success;
}

- (NSUInteger)cameraCount {
    return [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
}

- (NSUInteger)micCount {
    return [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].count;
}

- (void)autoFocusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [_videoInput device];
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            if ([_delegate respondsToSelector:@selector(recordManager:didFailWithError:)]) {
                [_delegate recordManager:self didFailWithError:error];
            }
        }
    }
}

- (void)continuousFocusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = _videoInput.device;
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        } else {
            if ([_delegate respondsToSelector:@selector(recordManager:didFailWithError:)]) {
                [_delegate recordManager:self didFailWithError:error];
            }
        }
    }
}

#pragma mark - WMRecorderDelegate

- (void)recorderRecordingDidBegin:(WMRecorder *)recorder {
    if ([_delegate respondsToSelector:@selector(recordManagerRecordingBegan:)]) {
        [_delegate recordManagerRecordingBegan:self];
    }
}

@end

@implementation WMRecordManager (InternalUtilityMethods)

// 跟踪设备方向的改变，保证视频和相片的方向与设备方向一致
- (void)deviceOrientationDidChange
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation == UIDeviceOrientationPortrait)
    {
        self.orientation = AVCaptureVideoOrientationPortrait;
    }
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        self.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    // 需要指出的是：AVCapture与UIDevice的横屏方向是相反的。
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
    {
        self.orientation = AVCaptureVideoOrientationLandscapeRight;
    }
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
    {
        self.orientation = AVCaptureVideoOrientationLandscapeLeft;
    }
}

// 定义一个方法，获取前置或后置的视频设备
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    // 获取所偶的视频设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    // 遍历所有的视频设备
    for (AVCaptureDevice *device in devices)
    {
        // 如果该设备的位置与被查找位置相同，返回该视频设备
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

// 定义获取前置摄像头的方法
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}
// 定义获取后置摄像头的方法
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}
// 定义获取临时文件URL的方法
- (NSURL *) tempFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",
                                   NSTemporaryDirectory(), @"output.mov"]];
}

// 定义删除文件的方法
- (void) removeFile:(NSURL *)fileURL
{
    NSString *filePath = [fileURL path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 如果要删除的文件存在
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSError *error;
        // 删除文件。如果删除失败，发送消息给代理对象
        if ([fileManager removeItemAtPath:filePath error:&error] == NO)
        {
            if ([self.delegate respondsToSelector:
                 @selector(recordManager:didFailWithError:)])
            {
                [self.delegate recordManager:self didFailWithError:error];
            }
        }
    }
}
// 复制文件的方法
- (void) copyFileToDocuments:(NSURL *)fileURL
{
    // 获取Home路径
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // 创建日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    // 定义复制文件的目标文件名
    NSString *destinationPath = [documentsDirectory
                                 stringByAppendingFormat:@"/output_%@.mov",
                                 [dateFormatter stringFromDate:[NSDate date]]];
    NSError	*error;
    // 复制文件。如果复制失败，发送消息给代理对象
    if (![[NSFileManager defaultManager] copyItemAtURL:fileURL
                                                 toURL:[NSURL fileURLWithPath:destinationPath] error:&error])
    {
        if ([[self delegate] respondsToSelector:
             @selector(recordManager:didFailWithError:)])
        {
            [[self delegate] recordManager:self didFailWithError:error];
        }
    }
}

@end
