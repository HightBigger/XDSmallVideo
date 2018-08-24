//
//  XDSmallVideoRecordController.h
//  NSKYSmallVideo
//
//  Created by xiaoda on 2018/3/9.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDSmallVideoRecordController;
@protocol XDSmallVideoRecordControllerDelegate <NSObject>
/**
 录制结束，请将文件剪切至自己的文件夹下，不要放在公共区域

 @param recoder 小视频控制器
 @param videoURL 文件地址（压缩完成之后的地址）
 @param coverImage 封面图片
 */
- (void)smallVideoController:(XDSmallVideoRecordController *)recoder didFinishRecordVideoWithURL:(NSURL *)videoURL coverImage:(UIImage *)coverImage;

/**
取消录制

 @param recoder 小视频控制器
 */
- (void)smallVideoControllerDidCancel:(XDSmallVideoRecordController *)recoder;
@end

@interface XDSmallVideoRecordController : UIViewController

@property (nonatomic, weak) id<XDSmallVideoRecordControllerDelegate> delegate;

@end
