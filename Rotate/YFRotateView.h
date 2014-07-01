//
//  YFRotateView.h
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFRotateView : UIScrollView
@property (retain, nonatomic) UIView * initView; //!< 相册初始化完成时,显示在相册上的视图.

/**
 *  相册上正在显示几张图片.
 *
 *  @return 相册上正在显示的图片数量.
 */
- (NSUInteger) numberOfVisibleView;

@end

// !!!: 协议: 可选的容错;必选的,直接崩程序.
// !!!: 一个潜在的优化方向: 允许用代理来设置 headerView,leftView,rightView.
@protocol YFRotateViewDelegate<UIScrollViewDelegate, UITableViewDataSource>

@optional

@end
