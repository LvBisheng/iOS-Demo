//
//  CaptureVideoManager.m
//  lbs_video
//
//  Created by farben on 2022/8/13.
//

#import "CaptureVideoManager.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CaptureVideoManager ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    dispatch_queue_t _videoQueue;
}

@property (nonatomic, copy) NSString *sessionPeset;
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, assign) int maxFrame;


@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;

@end

@implementation CaptureVideoManager

+ (instancetype)videoPreset:(NSString *)sessionPeset
             devicePosition:(AVCaptureDevicePosition)devicePosition
                   deletate:(id<CaptureVideoManagerDelegate>)delegate {
    CaptureVideoManager *manager = [[CaptureVideoManager alloc] initWithVideoPreset:sessionPeset devicePosition:devicePosition deletate:delegate];
    [manager _initialSesion];
    return manager;
}

- (instancetype)initWithVideoPreset:(NSString *)sessionPeset
devicePosition:(AVCaptureDevicePosition)devicePosition
                   deletate:(id<CaptureVideoManagerDelegate>)delegate {
    if(self = [super init]) {
        self.delegate = delegate;
        self.sessionPeset = sessionPeset;
        self.devicePosition = devicePosition;
        self.movieManager = [[CCMovieManager alloc] init];
        _videoQueue = dispatch_queue_create("com.lbs.test", DISPATCH_QUEUE_SERIAL);
        self.maxFrame = 30;
        [self _initialSesion];
    }
    return self;
}

- (void)_initialSesion {
    if(_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = self.sessionPeset;
        
        AVCaptureDevice *videoDevice = [self _cameraWithPosition:self.devicePosition];
        
        self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
        if([self.session canAddInput:self.videoInput]) {
            [self.session addInput:self.videoInput];
        }
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [output setSampleBufferDelegate:self queue:_videoQueue];
        output.videoSettings = [NSDictionary dictionaryWithObject:@(kCVPixelFormatType_32BGRA) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        output.alwaysDiscardsLateVideoFrames = YES; // 丢弃延时的视频帧
        if([self.session canAddOutput:output]) {
            [self.session addOutput:output];
        }
        
        self.videoConnection = [output connectionWithMediaType:AVMediaTypeVideo];
        
        // 设置采集的视频为屏幕的方向
        UIInterfaceOrientation currentInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
        if([self.videoConnection isVideoOrientationSupported]) {
            if(currentInterfaceOrientation == UIInterfaceOrientationPortrait) {
                videoOrientation = AVCaptureVideoOrientationPortrait;
            } else if (currentInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            } else if(currentInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            }
            [self.videoConnection setVideoOrientation:videoOrientation];
        }
        
        // ????????
        if(_devicePosition == AVCaptureDevicePositionFront &&
           [self.videoConnection isVideoMirroringSupported]) {
            [self.videoConnection setVideoMirrored:YES];
        }
        
        int frameRate = 0;
        CMTime frameDuration = kCMTimeInvalid;
        if([NSProcessInfo processInfo].processorCount == 1) {
            frameRate = 10;
        } else {
            frameRate = self.maxFrame; // 默认1/30的计算能力 非高帧率10-120
        }
        frameDuration = CMTimeMake(1, frameRate);
        
        // 添加判断条件 判定是否为接收方的activeFormat支持的值范围
        NSArray *supportedFrameRateRanges = [videoDevice.activeFormat videoSupportedFrameRateRanges];
        BOOL frameRateSupported = NO;
        for(AVFrameRateRange *r in supportedFrameRateRanges) {
            if(CMTIME_COMPARE_INLINE(frameDuration, >=, r.minFrameDuration) &&
               CMTIME_COMPARE_INLINE(frameDuration, <=, r.maxFrameDuration)) {
                frameRateSupported = YES;
            }
        }
        NSError *error= nil;
        if(frameRateSupported && [videoDevice lockForConfiguration:&error]) {
            videoDevice.activeVideoMaxFrameDuration = frameDuration;
            videoDevice.activeVideoMinFrameDuration = frameDuration;
            [videoDevice unlockForConfiguration];
        } else {
            NSLog(@"videoDevice lockForConfiguration returned error %@", error);
        }
    }
}

- (AVCaptureDevice *)_cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *d in devices) {
        if([d position] == position) {
            return d;
        }
    }
    return  nil;
}

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

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if(nil == _videoPreviewLayer) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [_videoPreviewLayer setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
    return _videoPreviewLayer;
}

- (void)startRunning {
    if(self.session) {
        [self.session startRunning];
    }
}

- (void)stopRunning {
    if(self.session) {
        [self.session stopRunning];
    }
}


// 前后摄像头的切换
- (void)toggleCamera:(AVCaptureDevicePosition)position {
    AVCaptureDevicePosition currentPosition = [[self.videoInput device] position];
    if(position == currentPosition || position == AVCaptureDevicePositionUnspecified) {
        return;
    }
    NSError *error;
    AVCaptureDeviceInput *newVideoInput;
    newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self _cameraWithPosition:position] error:&error];
    if(newVideoInput != nil) {
        [self.session beginConfiguration];
        [self.session removeInput:self.videoInput];
        if([self.session canAddInput:newVideoInput]) {
            [self.session addInput:newVideoInput];
            self.videoInput = newVideoInput;
        } else {
            [self.session addInput:self.videoInput];
        }
        self.devicePosition = [[self.videoInput device] position];
        [self.session commitConfiguration];
    } else if(error) {
        NSLog(@"toggle carema faild, error = %@", error);
    }
    
}

// 开始录像
- (void)startRecordVideoAction {
    _movieManager.currentDevice = self.videoInput.device;
    _movieManager.currentorientation = AVCaptureVideoOrientationLandscapeLeft;
    [_movieManager start:^(NSError * _Nonnull error) {
        if(error) {
            NSLog(@"start record error:%@", error);
        }
    }];
}

// 停止录像
- (void)stopRecordVideoAction:(void(^)(NSString *videoUrl))completeBlock {
    [_movieManager stop:^(NSURL * _Nonnull url, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"stop record error:%@", error);
            completeBlock(nil);
        } else {
            completeBlock([url path]);
        }
    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    [self.movieManager writeData:connection video:_videoConnection audio:nil buffer:sampleBuffer];
    @autoreleasepool {
        if(connection == self.videoConnection) {
//            CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
            if([self.delegate respondsToSelector:@selector(onCaptureOutput:didOutputSampleBuffer:fromConnection:)]) {
                [self.delegate onCaptureOutput:output didOutputSampleBuffer:sampleBuffer fromConnection:connection];
            }
        }
    }
}

+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    //释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
    
}
@end
