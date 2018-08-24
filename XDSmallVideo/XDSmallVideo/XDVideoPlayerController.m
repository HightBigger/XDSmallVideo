//
//  XDVideoPlayerController.m
//  AppNest
//
//  Created by xiaoda on 2018/3/10.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import "XDVideoPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "XDSmallVideoDefine.h"

@interface XDVideoPlayerController ()

@property (nonatomic, strong) CALayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIButton *doneButton;
@end

@implementation XDVideoPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = videoURL;
    if (!self.player)
    {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addObserverToPlayerItem:playerItem];
    }
    [self.view.layer addSublayer:self.playerLayer];
    
    [self playerButtons];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

- (void)playbackFinished:(NSNotification *)notification
{
    [self showPlayButton];
    [self.player seekToTime:kCMTimeZero];
}

- (void)playerButtons
{
    CGFloat barHeight = ISIPHONEX ? 44 + (83 - 49) : 44;
    
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, XDScreenHeight - barHeight, XDScreenWidth, barHeight)];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_bottomView];
    }
    
    if (!_doneButton)
    {
        _doneButton = [[UIButton alloc]initWithFrame:CGRectMake(XDScreenWidth - 20 -44, 0, 44, 44)];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(didClickDoneButton) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_doneButton];
    }
    
    if (!_playButton)
    {
        _playButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, XDScreenWidth, XDScreenHeight-barHeight)];
        [_playButton setImage:[UIImage imageNamed:@"nsky_moment_publish_smallvideo_preview"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"nsky_moment_publish_smallvideo_preview_on"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(didClickPlayButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_playButton];
    }
}

#pragma mark - buttonAction
- (void)didClickPlayButton
{
//    CMTime currentTime = _player.currentItem.currentTime;
//    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f)
    {
        [self hidePlayButton];
        [_player play];
    }
    else
    {
        [self showPlayButton];
        [_player pause];
    }
}

- (void)didClickDoneButton
{
    if (self.confirmBlock)
    {
        self.confirmBlock();
    }
}

- (void)showPlayButton
{
    [UIView animateWithDuration:.25f animations:^{
        self.bottomView.transform =  CGAffineTransformIdentity;
    }];
    
    CGFloat barHeight = ISIPHONEX ? 44 + (83 - 49) : 44;
    _playButton.frame = CGRectMake(0, 0, XDScreenWidth, XDScreenHeight-barHeight);
    [_playButton setImage:[UIImage imageNamed:@"nsky_moment_publish_smallvideo_preview"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"nsky_moment_publish_smallvideo_preview_on"] forState:UIControlStateHighlighted];
}

- (void)hidePlayButton
{
    self.bottomView.transform =  CGAffineTransformMakeTranslation(0,self.bottomView.frame.size.height);
    
    [self.playButton setImage:nil forState:UIControlStateNormal];
    [self.playButton setImage:nil forState:UIControlStateHighlighted];
    self.playButton.frame = self.view.bounds;
}

#pragma mark - lazyLoad
- (CALayer *)playerLayer
{
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    return playerLayer;
}

- (void)dealloc
{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
