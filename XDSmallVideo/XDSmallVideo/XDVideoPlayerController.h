//
//  XDVideoPlayerController.h
//  AppNest
//
//  Created by xiaoda on 2018/3/10.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NSKYVideoPlayerControllerConfirmBlock)(void);

@interface XDVideoPlayerController : UIViewController

@property (nonatomic, copy) NSKYVideoPlayerControllerConfirmBlock confirmBlock;

@property (nonatomic,strong) NSURL *videoURL;

@end
