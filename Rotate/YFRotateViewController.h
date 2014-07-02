//
//  YFRotateViewController.h
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFRotateView.h"

@interface YFRotateViewController : UIViewController <YFRotateViewDataSource, YFRotateViewDelegate>
@property (retain, nonatomic) YFRotateView * view; //!< 重新声明视图.
@end
