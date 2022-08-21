//
//  AVAssetWriteManager.h
//  iOS-Demo
//
//  Created by farben on 2022/8/20.
//  Copyright © 2022 LBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


//录制状态，（这里把视频录制与写入合并成一个状态）
typedef NS_ENUM(NSInteger, FMRecordState) {
    FMRecordStateInit = 0,
    FMRecordStatePrepareRecording,
    FMRecordStateRecording,
    FMRecordStateFinish,
    FMRecordStateFail,
};

//录制视频的长宽比
typedef NS_ENUM(NSInteger, FMVideoViewType) {
    Type1X1 = 0,
    Type4X3,
    TypeFullScreen
};


@protocol AVAssetWriteManagerDelegate <NSObject>

- (void)finishWriting;
- (void)updateWritingProgress:(CGFloat)progress;

@end

@interface AVAssetWriteManager : NSObject

@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;

@property (nonatomic, assign) FMRecordState writeState;
@property (nonatomic, weak) id <AVAssetWriteManagerDelegate> delegate;
- (instancetype)initWithURL:(NSURL *)URL viewType:(FMVideoViewType )type;

- (void)startWrite;
- (void)stopWrite;
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType;
- (void)destroyWrite;

@end

