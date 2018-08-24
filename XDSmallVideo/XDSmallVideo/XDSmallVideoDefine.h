//
//  XDSmallVideoDefine.h
//  XDSmallVideo
//
//  Created by xiaoda on 2018/8/24.
//  Copyright © 2018年 xiaoda. All rights reserved.
//

#ifndef XDSmallVideoDefine_h
#define XDSmallVideoDefine_h

#define XDScreenWidth [UIScreen mainScreen].bounds.size.width
#define XDScreenHeight [UIScreen mainScreen].bounds.size.height
#define XDStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define ISIPHONEX ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
#define iPhone_X_Present   (ISIPHONEX ? 34:0)

#endif /* XDSmallVideoDefine_h */
