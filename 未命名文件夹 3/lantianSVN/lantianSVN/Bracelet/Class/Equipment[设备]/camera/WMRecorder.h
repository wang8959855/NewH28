//
//  WMRecorder.h
//  WMCamera
//
//  Created by SZCE on 15/12/9.
//  Copyright (c) 2015年 xiaoxia liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class WMRecorder;

@protocol WMRecorderDelegate <NSObject>

@optional
- (void)recorderRecordingDidBegin:(WMRecorder *)recorder;

- (void)recorder:(WMRecorder *)recorder recordingDidFinishToOutputFileURL:(NSURL *)outputFielURL error:(NSError *)error;

@end

@interface WMRecorder : NSObject <AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (copy, nonatomic) NSURL *outputFileURL;
/** 是否录制视频 */
@property (readonly, nonatomic) BOOL recordsVideo;
/** 是否录制音频　*/
@property (readonly, nonatomic) BOOL recordsAudio;
/** 是否正在录制 */
@property (readonly, nonatomic, getter=isRecording) BOOL recording;

@property (weak, nonatomic) id<WMRecorderDelegate> delegate;

- (id)initWithSession:(AVCaptureSession *)session outputFileURL:(NSURL *)outputFileURL;

/** 根据指定录制方向开始录制 */
- (void)startRecordingWithOrientation:(AVCaptureVideoOrientation)videoOrientation;

/** 停止录制 */
- (void)stopRecording;

/** 根据给定媒体类型获取对应的AVCaptureConnection */
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;

@end


