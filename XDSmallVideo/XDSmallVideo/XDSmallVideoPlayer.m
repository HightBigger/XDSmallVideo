//
//  XDSmallVideoPlayer.m
//  NSKYSmallVideo
//
//  Created by xiaoda on 2018/3/10.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import "XDSmallVideoPlayer.h"

@interface XDSmallVideoPlayer()
@property (nonatomic, strong) CALayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation XDSmallVideoPlayer

- (CALayer *)playerLayer{
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    return playerLayer;
}

- (void)playerButtons{
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, screenH, screenW, 100)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_bottomView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(20, (100 - 36)/2, 36, 36);
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setTitle:@"重拍" forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor clearColor]];
    [_cancelButton sizeToFit];
    [_cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(screenW - 20 - 72, (100 - 36)/2 , 72, 36);
    
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setTitle:@"使用视频" forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:[UIColor clearColor]];
    [_confirmButton sizeToFit];
    
    [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:_confirmButton];
    [_bottomView addSubview:_cancelButton];
}

- (void)clickConfirm{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self.player pause];
//    [self removeFromSuperview];
}

- (void)clickCancel{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self.player pause];
    
    [self removeFromSuperview];
}

- (void)showPlayerButtons
{
    [UIView animateWithDuration:0.25f animations:^{
        self.bottomView.transform =  CGAffineTransformMakeTranslation(0,-100);
    }];
}

- (void)setPlayUrl:(NSURL *)playUrl{
    _playUrl = playUrl;
    if (!self.player) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.playUrl];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addObserverToPlayerItem:playerItem];
    }
    [self.layer addSublayer:self.playerLayer];
    if (!_bottomView)
    {
        [self playerButtons];
    }
    [self.player play];
    
}

- (void)playbackFinished:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)playtimeChange:(NSNotification *)notification
{
    self.backgroundColor = [UIColor blackColor];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playtimeChange:) name:AVPlayerItemTimeJumpedNotification object:playerItem];
}

- (void)dealloc{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
