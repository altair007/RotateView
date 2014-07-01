//
//  YFRotateViewController.h
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFRotateView.h"

// ???: 直接遵守 UIScrollViewAccessibilityDelegate 协议,好像可以自动设置正在显示 x/y 页
@interface YFRotateViewController : UIViewController <YFRotateViewDataSource, YFRotateViewDelegate>
@property (retain, nonatomic) YFRotateView * view; //!< 重新声明视图.
@end
