//
//  XDSmallVideoPlayer.h
//  NSKYSmallVideo
//
//  Created by xiaoda on 2018/3/10.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^XDSmallVideoPlayerCancelBlock)(void);
typedef void(^XDSmallVideoPlayerConfirmBlock)(void);

@interface XDSmallVideoPlayer : UIView

@property (nonatomic, copy) XDSmallVideoPlayerCancelBlock cancelBlock;
@property (nonatomic, copy) XDSmallVideoPlayerConfirmBlock confirmBlock;
@property (nonatomic, strong) NSURL *playUrl;

- (void)showPlayerButtons;
@end
