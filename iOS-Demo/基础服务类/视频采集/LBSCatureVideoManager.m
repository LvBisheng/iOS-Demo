//
//  LBSCatureVideoManager.m
//  iOS-Demo
//
//  Created by farben on 2022/8/20.
//  Copyright © 2022 LBS. All rights reserved.
//

#import "LBSCatureVideoManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "AVAssetWriteManager.h"
#import "XCFileManager.h"

#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LBSCatureVideoManager ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t videoQueue;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewlayer;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;

@property (nonatomic, strong) AVAssetWriteManager *writeManager;

@end
@implementation LBSCatureVideoManager

+ (instancetype)videoPreset:(NSString *)sessionPeset
             devicePosition:(AVCaptureDevicePosition)devicePosition
                   deletate:(id<LBSCatureVideoManagerDelegate>)delegate {
    LBSCatureVideoManager *manager = [[LBSCatureVideoManager alloc] initWithVideoPreset:sessionPeset devicePosition:devicePosition deletate:delegate];
//    [manager _initialSesion];
    return manager;
}

- (instancetype)initWithVideoPreset:(NSString *)sessionPeset
devicePosition:(AVCaptureDevicePosition)devicePosition
                   deletate:(id<LBSCatureVideoManagerDelegate>)delegate {
    if(self = [super init]) {
        self.delegate = delegate;
//        self.sessionPeset = sessionPeset;
//        self.devicePosition = devicePosition;
//        self.movieManager = [[CCMovieManager alloc] init];
//        _videoQueue = dispatch_queue_create("com.lbs.test", DISPATCH_QUEUE_SERIAL);
//        self.maxFrame = 30;
//        [self _initialSesion];
        [self _setup];
    }
    return self;
}

#pragma mark - lazy load

- (AVCaptureSession *)session
{
    // 录制5秒钟视频 高画质10M,压缩成中画质 0.5M
    // 录制5秒钟视频 中画质0.5M,压缩成中画质 0.5M
    // 录制5秒钟视频 低画质0.1M,压缩成中画质 0.1M
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {//设置分辨率
            _session.sessionPreset=AVCaptureSessionPresetHigh;
        }
    }
    return _session;
}

- (dispatch_queue_t)videoQueue
{
    if (!_videoQueue) {
        _videoQueue = dispatch_queue_create("com.5miles", DISPATCH_QUEUE_SERIAL);
    }
    return _videoQueue;
}

- (AVCaptureVideoPreviewLayer *)previewlayer
{
    if (!_previewlayer) {
        _previewlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [_previewlayer setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewlayer;
}

- (AVAssetWriteManager *)writeManager {
    if(!_writeManager) {
        NSURL *videoUrl = [[NSURL alloc] initFileURLWithPath:[self createVideoFilePath]];
        _writeManager = [[AVAssetWriteManager alloc] initWithURL:videoUrl viewType:TypeFullScreen];
    }
    return  _writeManager;;
}

#pragma mark - public method

- (void)videoPermission {
    if([self.delegate respondsToSelector:@selector(onPermissionOfCamer:)] == NO) {
        return;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:  AVMediaTypeVideo];
    if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        [self.delegate onPermissionOfCamer:status];
    } else if (status == AVAuthorizationStatusAuthorized) {
        [self.delegate onPermissionOfCamer:status];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate onPermissionOfCamer:granted? AVAuthorizationStatusAuthorized : AVAuthorizationStatusNotDetermined];
            });
        }];
    }
}
- (void)startRunning {
    [self.session startRunning];

}

- (void)stopRunning {
    [self.session stopRunning];
}


// 开始录像
- (void)startRecordVideoAction {
    [self.writeManager startWrite];
}

// 停止录像
- (void)stopRecordVideoAction:(void(^)(NSString *videoUrl))completeBlock {
    [self.writeManager stopWrite];
}

#pragma mark - private method

//存放视频的文件夹
- (NSString *)videoFolder
{
    NSString *cacheDir = [XCFileManager cachesDir];
    NSString *direc = [cacheDir stringByAppendingPathComponent:VIDEO_FOLDER];
    if (![XCFileManager isExistsAtPath:direc]) {
        [XCFileManager createDirectoryAtPath:direc];
    }
    return direc;
}
//清空文件夹
- (void)clearFile
{
    [XCFileManager removeItemAtPath:[self videoFolder]];
    
}
//写入的视频路径
- (NSString *)createVideoFilePath
{
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
    
}

#pragma mark - setup
- (void)_setup {
    // 初始化捕捉会话，数据的采集都在会话中处理
    // 初始化视频的输入输出
    [self _setUpVideo];
    
    // 设置音频的输入输出
    [self _setUpAudio];

}

- (void)_setUpVideo
{
    // 2.1 获取视频输入设备(摄像头)
    AVCaptureDevice *videoCaptureDevice=[self _getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    // 2.2 创建视频输入源
    NSError *error=nil;
    self.videoInput= [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:&error];
    // 2.3 将视频输入源添加到会话
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.videoSettings = [NSDictionary dictionaryWithObject:@(kCVPixelFormatType_32BGRA) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    self.videoOutput.alwaysDiscardsLateVideoFrames = YES; //立即丢弃旧帧，节省内存，默认YES
    [self.videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if ([self.session canAddOutput:self.videoOutput]) {
        [self.session addOutput:self.videoOutput];
    }
}

- (void)_setUpAudio {
    // 2.2 获取音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    NSError *error=nil;
    // 2.4 创建音频输入源
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:&error];
    // 2.6 将音频输入源添加到会话
    if ([self.session canAddInput:self.audioInput]) {
        [self.session addInput:self.audioInput];
    }
    
    self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if([self.session canAddOutput:self.audioOutput]) {
        [self.session addOutput:self.audioOutput];
    }
}

#pragma mark - 获取摄像头
-(AVCaptureDevice *)_getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {
        
        //视频
        if (connection == [self.videoOutput connectionWithMediaType:AVMediaTypeVideo]) {
            
            if (!self.writeManager.outputVideoFormatDescription) {
                @synchronized(self) {
                    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                    self.writeManager.outputVideoFormatDescription = formatDescription;
                }
            } else {
                @synchronized(self) {
                    if (self.writeManager.writeState == FMRecordStateRecording) {
                        [self.writeManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
                    }
                    
                }
            }
            
            
        }
        
        //音频
        if (connection == [self.audioOutput connectionWithMediaType:AVMediaTypeAudio]) {
            if (!self.writeManager.outputAudioFormatDescription) {
                @synchronized(self) {
                    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                    self.writeManager.outputAudioFormatDescription = formatDescription;
                }
            }
            @synchronized(self) {

                if (self.writeManager.writeState == FMRecordStateRecording) {
                    [self.writeManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
                }

            }

        }
    }
    

}

- (void)_destroy
{
    [self.session stopRunning];
    self.session = nil;
    self.videoQueue = nil;
    self.videoOutput = nil;
    self.videoInput = nil;
    self.audioOutput = nil;
    self.audioInput = nil;
    
    [self.writeManager destroyWrite];
}

- (void)_saveMovieToCameraRoll:(NSURL *)url {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(status != PHAuthorizationStatusAuthorized) {
            return;
        }
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
            [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:url options:nil];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(error) {
                NSLog(@"save video error: %@", error);
            }
        }];
        
    }];
}

- (void)dealloc
{
    [self _destroy];
}
@end
