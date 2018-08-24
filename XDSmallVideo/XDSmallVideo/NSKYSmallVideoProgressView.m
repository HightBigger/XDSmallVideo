//
//  XDSmallVideoProgressView.m
//  NSKYSmallVideo
//
//  Created by xiaoda on 2018/3/9.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#import "XDSmallVideoProgressView.h"

@implementation XDSmallVideoProgressView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2); //设置圆心位置
    CGFloat radius = self.frame.size.width/2 - 2; //设置半径
    CGFloat startA = - M_PI_2; //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress/self.totolProgress; //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx, 4); //设置线条宽度
    [[UIColor greenColor] setStroke]; //设置描边颜色
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx); //渲染
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
