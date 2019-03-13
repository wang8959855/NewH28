//
//  WMRecorder.m
//  WMCamera
//
//  Created by SZCE on 15/12/9.
//  Copyright (c) 2015年 xiaoxia liu. All rights reserved.
//

#import "WMRecorder.h"

@implementation WMRecorder

- (id)initWithSession:(AVCaptureSession *)session outputFileURL:(NSURL *)outputFileURL {
    self = [super init];
    
    if (self) {
        AVCaptureMovieFileOutput *aMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        if ([session canAddOutput:aMovieFileOutput]) {
            [session addOutput:aMovieFileOutput];
        }
        
        _movieFileOutput = aMovieFileOutput;
        _session = session;
        _outputFileURL = outputFileURL;
    }
    
    return self;
}

#pragma mark - Public

- (BOOL)recordsVideo {
    AVCaptureConnection *videoConnection = [WMRecorder connectionWithMediaType:AVMediaTypeVideo fromConnections:[self movieFileOutput].connections];
    return videoConnection.isActive;
}

- (BOOL)recordsAudio {
    AVCaptureConnection *audioConnection = [WMRecorder connectionWithMediaType:AVMediaTypeAudio fromConnections:[self movieFileOutput].connections];
    return audioConnection.isActive;
}

- (BOOL)isRecording {
    return _movieFileOutput.isRecording;
}

- (void)startRecordingWithOrientation:(AVCaptureVideoOrientation)videoOrientation {
    AVCaptureConnection *videoConnection = [WMRecorder connectionWithMediaType:AVMediaTypeVideo fromConnections:_movieFileOutput.connections];
    
    if ([videoConnection isVideoOrientationSupported]) {
        videoConnection.videoOrientation = videoOrientation;
    }
    
    [_movieFileOutput startRecordingToOutputFileURL:_outputFileURL recordingDelegate:self];
}

- (void)stopRecording {
    [_movieFileOutput stopRecording];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    if ([_delegate respondsToSelector:@selector(recorderRecordingDidBegin:)]) {
        [_delegate recorderRecordingDidBegin:self];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    if ([_delegate respondsToSelector:@selector(recorder:recordingDidFinishToOutputFileURL:error:)]) {
        [_delegate recorder:self recordingDidFinishToOutputFileURL:outputFileURL error:error];
    }
}

#pragma mark - Assistor

+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    // 遍历传入的所有AVCaptureConnection
    for(AVCaptureConnection *connection in connections)
    {
        // 遍历AVCaptureConnection关联的所有AVCaptureInputPort
        for(AVCaptureInputPort *port in [connection inputPorts])
        {
            // 如果某个AVCaptureInputPort的媒体类型等于要查找的mediaType
            if([port.mediaType isEqual:mediaType])
            {
                // 返回该AVCaptureConnection
                return connection;
            }
        }
    }
    
    return nil;
}

@end
