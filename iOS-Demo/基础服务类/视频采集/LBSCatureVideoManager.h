//
//  LBSCatureVideoManager.h
//  iOS-Demo
//
//  Created by farben on 2022/8/20.
//  Copyright © 2022 LBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol LBSCatureVideoManagerDelegate <NSObject>

- (void)onPermissionOfCamer: (AVAuthorizationStatus)camerState;
- (void)onCaptureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
         fromConnection:(AVCaptureConnection *)connection;

@end


@interface LBSCatureVideoManager : NSObject

+ (instancetype)videoPreset:(NSString *)sessionPeset
devicePosition:(AVCaptureDevicePosition)devicePosition
                   deletate:(id<LBSCatureVideoManagerDelegate>)delegate;

@property (nonatomic, weak) id<LBSCatureVideoManagerDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *previewlayer;


/// 视频权限
- (void)videoPermission;


/// 开启视频流
- (void)startRunning;


/// 关闭视频流
- (void)stopRunning;

// 开始录像
- (void)startRecordVideoAction;

// 停止录像
- (void)stopRecordVideoAction:(void(^)(NSString *videoUrl))completeBlock;
@end

