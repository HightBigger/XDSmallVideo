//
//  ViewController.m
//  XDSmallVideo
//
//  Created by xiaoda on 2018/8/24.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import "ViewController.h"
#import "XDSmallVideoRecordController.h"

@interface ViewController ()<XDSmallVideoRecordControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"录制" forState: UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didClickVideoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


- (void)didClickVideoButton
{
    XDSmallVideoRecordController *vc = [[XDSmallVideoRecordController alloc]init];
    vc.delegate = self;

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)smallVideoController:(XDSmallVideoRecordController *)recoder didFinishRecordVideoWithURL:(NSURL *)videoURL coverImage:(UIImage *)coverImage {
    
    [recoder dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"拍摄结束，存储地址为:%@",videoURL.absoluteString);
}

- (void)smallVideoControllerDidCancel:(XDSmallVideoRecordController *)recoder {
    
    NSLog(@"拍摄取消");
    [recoder dismissViewControllerAnimated:YES completion:nil];
    
}

@end
