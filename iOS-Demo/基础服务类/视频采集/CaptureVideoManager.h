//
//  CaptureVideoManager.h
//  lbs_video
//
//  Created by farben on 2022/8/13.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CaptureVideoManagerDelegate <NSObject>

- (void)onPermissionOfCamer: (AVAuthorizationStatus)camerState;
- (void)onCaptureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
         fromConnection:(AVCaptureConnection *)connection;

@end


/// 采集视频管理类。需要NSCameraUsageDescription权限
@interface CaptureVideoManager : NSObject

@property (nonatomic, weak) id<CaptureVideoManagerDelegate> delegate;

/// 视频流的预览layer。默认全屏大小
@property (nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, assign, readonly) AVCaptureDevicePosition devicePosition;

+ (instancetype)videoPreset:(NSString *)sessionPeset
devicePosition:(AVCaptureDevicePosition)devicePosition
                   deletate:(id<CaptureVideoManagerDelegate>)delegate;


/// 视频权限
- (void)videoPermission;


/// 开启视频流
- (void)startRunning;


/// 关闭视频流
- (void)stopRunning;

/// 前后摄像头的切换
/// @param position 摄像头类型
- (void)toggleCamera:(AVCaptureDevicePosition)position;

+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

@end

