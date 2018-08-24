//
//  XDSmallVideoManager.h
//  NSKYSmallVideo
//
//  Created by xiaoda on 2018/3/9.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol XDSmallVideoManagerDelegate <NSObject>
//录制结束
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;

//录制时间
- (void)recordTimeCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;
@end

@interface XDSmallVideoManager : NSObject

@property (nonatomic, weak) id<XDSmallVideoManagerDelegate> delegate;

//摄像头视图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;

// 准备录制
- (void)prepareForRecord;

// 开始录制
- (void)startRecordToFile:(NSURL *)outPutFile;

// 停止录制
- (void)stopCurrentVideoRecording;

// 切换摄像头
- (void)switchCamera;

// 设置对焦
- (void)setFoucusWithPoint:(CGPoint)point;

//压缩视频
+ (void)compressVideo:(NSURL *)inputFileURL complete:(void(^)(BOOL success, NSURL* outputUrl,UIImage *coverImage))complete;

// 缓存路径
+ (NSString*)cacheFilePath:(BOOL)input;

//获取视频第一帧图片
+ (UIImage*) getVideoPreViewImage:(NSURL *)path;
@end
