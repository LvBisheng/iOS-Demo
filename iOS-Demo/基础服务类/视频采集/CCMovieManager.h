//
//  CCMovieManager.h
//  iOS-Demo
//
//  Created by farben on 2022/8/14.
//  Copyright © 2022 LBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface CCMovieManager:NSObject

@property(nonatomic,assign)AVCaptureVideoOrientation referenceOrientation;//视频播放方向
@property(nonatomic,assign)AVCaptureVideoOrientation currentorientation;
@property(nonatomic,strong)AVCaptureDevice *currentDevice; -(void)start:(void(^)(NSError *error))handle;

-(void)stop:(void(^)(NSURL *url,NSError *error))handle;

-(void)writeData:(AVCaptureConnection *)connection video:(nullable AVCaptureConnection *)video audio:(nullable AVCaptureConnection *)audio
          buffer:(CMSampleBufferRef)buffer;
@end
NS_ASSUME_NONNULL_END
