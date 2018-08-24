//
//  XDSmallVideoRecordController.m
//  NSKYSmallVideo
//
//  Created by xiaoda on 2018/3/9.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import "XDSmallVideoRecordController.h"
#import "XDSmallVideoProgressView.h"
#import "XDSmallVideoManager.h"
#import "XDSmallVideoPlayer.h"

@interface XDSmallVideoRecordController ()<XDSmallVideoManagerDelegate>

@property (nonatomic, strong) XDSmallVideoManager *recorderManager;
@property (nonatomic, strong) UIView *recordBtn;
@property (nonatomic, strong) UIView *recordBackView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *focusImageView;

@property (nonatomic, strong) XDSmallVideoProgressView *progressView;
@property (nonatomic, strong) UIButton *switchCameraButton;

@property (nonatomic, strong) NSURL *recordVideoUrl;
@property (nonatomic, strong) NSURL *recordVideoOutPutUrl;
@property (nonatomic, strong) UIImage *recordVideoCoverImage;
@property (nonatomic, assign) BOOL videoCompressComplete;

@property (nonatomic, strong) XDSmallVideoPlayer *playView;
@end

@implementation XDSmallVideoRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];

    //界面绘制,注意添加顺序
    [self.view addSubview:self.recordBackView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.switchCameraButton];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.focusImageView];
    
    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusTap:)];
    [self.view addGestureRecognizer:focusTap];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.recorderManager = [[XDSmallVideoManager alloc]init];
        self.recorderManager.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recorderManager.preViewLayer.frame = self.view.bounds;
            [self.view.layer insertSublayer:self.recorderManager.preViewLayer atIndex:0];
        
            [self setFocusWithPoint:self.view.center];
        });
    });
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)focusTap:(UITapGestureRecognizer *)tap
{
    CGPoint point= [tap locationInView:self.view];
    
    if (point.y > self.tipLabel.frame.origin.y) return;
    
    [self setFocusWithPoint:point];
    
    [self.recorderManager setFoucusWithPoint:point];
    
}

-(void)setFocusWithPoint:(CGPoint)point{
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView animateWithDuration:0.2 animations:^{
        self.focusImageView.alpha = 1;
        self.focusImageView.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
        [self performSelector:@selector(autoHideFocusImageView) withObject:nil afterDelay:1];
    }];
}

- (void)autoHideFocusImageView{
    self.focusImageView.alpha = 0;
}

#pragma mark - lazyload
//录制按钮背景
- (UIView *)recordBackView{
    if (!_recordBackView) {
        CGRect rect = self.recordBtn.frame;
        CGFloat gap = 7.5;
        rect.size = CGSizeMake(rect.size.width + gap*2, rect.size.height + gap*2);
        rect.origin = CGPointMake(rect.origin.x - gap, rect.origin.y - gap);
        _recordBackView = [[UIView alloc]initWithFrame:rect];
        _recordBackView.backgroundColor = [UIColor whiteColor];
        _recordBackView.alpha = 0.6;
        [_recordBackView.layer setCornerRadius:_recordBackView.frame.size.width/2];
    }
    return _recordBackView;
}

//录制按钮
- (UIView *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [[UIView alloc]init];
        CGFloat deta = [UIScreen mainScreen].bounds.size.width/375;
        CGFloat width = 60.0*deta;
        _recordBtn.frame = CGRectMake((self.view.frame.size.width - width)/2, self.view.frame.size.height - 107*deta, width, width);
        [_recordBtn.layer setCornerRadius:_recordBtn.frame.size.width/2];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startRecord:)];
        [_recordBtn addGestureRecognizer:press];
        _recordBtn.userInteractionEnabled = YES;
    }
    return _recordBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 50)/2, self.recordBackView.frame.origin.y - 30, 100, 20)];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = @"长按拍摄";
        _tipLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipLabel;
}

- (UIImageView *)focusImageView{
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallvideo_focus"]];
        _focusImageView.alpha = 0;
        _focusImageView.frame = CGRectMake(0, 0, 75, 75);
    }
    return _focusImageView;
}

//取消按钮
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(20, self.recordBtn.center.y - 18, 36, 36);
        [_backButton sizeToFit];
        [_backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
//切换摄像头
- (UIButton *)switchCameraButton
{
    if (!_switchCameraButton) {
        _switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraButton setImage:[UIImage imageNamed:@"smallvideo_switch"] forState:UIControlStateNormal];
        _switchCameraButton.frame = CGRectMake(self.view.frame.size.width - 20 - 36, self.recordBtn.center.y - 18, 36, 36);
        [_switchCameraButton addTarget:self action:@selector(clickSwitchCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraButton;
}
//进度视图
- (XDSmallVideoProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[XDSmallVideoProgressView alloc]initWithFrame:self.recordBackView.frame];
    }
    return _progressView;
}

#pragma mark - clickAction
//切换摄像头事件
- (void)clickSwitchCamera
{
    [self.recorderManager switchCamera];
}

//开始录制事件
- (void)startRecord:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //开始录制时，信息重置
        self.recordVideoUrl = nil;
        self.videoCompressComplete = NO;
        self.recordVideoOutPutUrl = nil;
        //开始录制的放大动画
        [self startRecordAnimate];

        //录制开始重置进度view的frame
        CGRect rect = self.progressView.frame;
        rect.size = CGSizeMake(self.recordBackView.frame.size.width - 3, self.recordBackView.frame.size.height - 3);
        rect.origin = CGPointMake(self.recordBackView.frame.origin.x + 1.5, self.recordBackView.frame.origin.y + 1.5);
        self.progressView.frame = self.recordBackView.frame;
        
        self.backButton.hidden = YES;
        self.tipLabel.hidden = YES;
        self.switchCameraButton.hidden = YES;
        NSURL *url = [NSURL fileURLWithPath:[XDSmallVideoManager cacheFilePath:YES]];
        [self.recorderManager startRecordToFile:url];
        
    }else if(gesture.state == UIGestureRecognizerStateEnded
             || gesture.state == UIGestureRecognizerStateRecognized
             || gesture.state == UIGestureRecognizerStateCancelled
             || gesture.state == UIGestureRecognizerStateFailed
             )
    {
        [self stopRecord];
    }
}
//停止录制
- (void)stopRecord
{
    [self.recorderManager stopCurrentVideoRecording];
}
//开始录制时的放大动画
- (void)startRecordAnimate
{
    [UIView animateWithDuration:0.2 animations:^{
        self.recordBtn.transform = CGAffineTransformMakeScale(0.66, 0.66);
        self.recordBackView.transform = CGAffineTransformMakeScale(6.5/5, 6.5/5);
    }];
}

//取消按钮事件
- (void)clickBackButton
{
    if ([self.delegate respondsToSelector:@selector(smallVideoControllerDidCancel:)])
    {
        [self.delegate smallVideoControllerDidCancel:self];
    }
}

//取消录制的视频，重新录制
- (void)clickCancel
{
    self.recordBtn.transform = CGAffineTransformMakeScale(1, 1);
    self.recordBackView.transform = CGAffineTransformMakeScale(1, 1);
    [self.recorderManager prepareForRecord];
    self.backButton.hidden = NO;
    self.tipLabel.hidden = NO;
    self.switchCameraButton.hidden = NO;
    
    [[NSFileManager defaultManager]removeItemAtURL:_recordVideoUrl error:nil];
    [[NSFileManager defaultManager]removeItemAtURL:_recordVideoOutPutUrl error:nil];
}


#pragma mark - XDSmallVideoManagerDelegate
//录制结束
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    //把进度清空
    [self.progressView setProgress:0];
    if (!error)
    {
        //记录当前的url地址
        self.recordVideoUrl = outputFileURL;
        //循环播放视频
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showVedio:outputFileURL];
        });
        //处理视频
        [self compressVideo];
    }
    else
    {
        NSString *msg = error.userInfo[NSLocalizedDescriptionKey];
        
        NSLog(@"发生错误：%@",msg);
        
        [self clickCancel];
    }
}

//录制时间
- (void)recordTimeCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime
{
    self.progressView.totolProgress = totalTime;
    self.progressView.progress = currentTime;
}
#pragma mark - 录制结束，处理视频
//录制结束循环播放视频
- (void)showVedio:(NSURL *)playUrl
{
    _playView= [[XDSmallVideoPlayer alloc]initWithFrame:self.view.bounds];
    _playView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_playView];
    _playView.playUrl = playUrl;
    __weak typeof(self) weakself = self;
    _playView.cancelBlock = ^{
        [weakself clickCancel];
    };
    _playView.confirmBlock = ^{
        [weakself hideAllView];
        //保存数据
        [weakself saveVideo];
        //完成后返回数据
        if ([weakself.delegate respondsToSelector:@selector(smallVideoController:didFinishRecordVideoWithURL:coverImage:)])
        {
            [weakself.delegate smallVideoController:weakself didFinishRecordVideoWithURL:weakself.recordVideoOutPutUrl coverImage:weakself.recordVideoCoverImage];
        }
    };
}

//保存视频
- (void)saveVideo
{
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([self.recordVideoUrl path])) {
        //保存视频到相簿
        UISaveVideoAtPathToSavedPhotosAlbum([self.recordVideoUrl path], self,
                                            @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //视频保存完成删除本地缓存，只留下压缩之后的视频
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.recordVideoUrl.absoluteString])
    {
        [[NSFileManager defaultManager] removeItemAtPath:self.recordVideoUrl.absoluteString error:nil];
    }
}

//使用视频时，隐藏所有图标
- (void)hideAllView
{
    self.backButton.hidden = YES;
    self.tipLabel.hidden = YES;
    self.switchCameraButton.hidden = YES;
    self.recordBtn.hidden = YES;
    self.recordBackView.hidden = YES;
}
//处理视频
- (void)compressVideo{
    __weak typeof(self) weakself = self;
    [XDSmallVideoManager compressVideo:self.recordVideoUrl complete:^(BOOL success, NSURL *outputUrl, UIImage *coverImage) {
        if (success && outputUrl) {
            weakself.recordVideoOutPutUrl = outputUrl;
            weakself.recordVideoCoverImage = coverImage;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.playView showPlayerButtons];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
