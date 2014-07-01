//
//  YFRotateView.h
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFRotateView;

// !!!: 协议: 可选的容错;必选的,直接崩程序.
// !!!: 一个潜在的优化方向: 允许用代理来设置 headerView,leftView,rightView.
@protocol YFRotateViewDelegate
/**
 *  设置轮转视图页眉的高度.
 *
 *  @param totateView 轮转视图.
 *
 *  @return 返回页眉高度.
 */
- (CGFloat) heightForHeaderInRotateView: (YFRotateView *) totateView;

@optional

@end

@protocol YFRotateViewDataSource <NSObject>

// !!!: 允许设置是否轮转.
@required

/**
 *  设置轮转视图中单元格的数量.
 *
 *  @param rotateView 轮转视图对象.
 *
 *  @return 单元格数量.
 */
- (NSInteger)numberOfCellsInRotateView:(YFRotateView *)rotateView;

/**
 *  设置用于某个位置的单元格的视图.
 *
 *  @param rotateView 轮转视图对象.
 *  @param index      单元格位置.
 *
 *  @return 用于某个位置的单元格的视图.
 */
- (UIView *)rotateView:(YFRotateView *)rotateView cellForColAtIndex:(NSUInteger) index;

@end

// ???: 优化目标: 使用 "约束"来布局视图.
// ???: 通过当 frame 变化时. UIView的"Alternatives to Subclassing"动态改变视图,而不是手动去设置.
@interface YFRotateView : UIView <UIScrollViewDelegate>
//@property (retain, nonatomic) UIView * initView; //!< 相册初始化完成时,显示在相册上的视图.
// !!!: 备用属性.
@property (assign, nonatomic) id<YFRotateViewDelegate> delegate; //!< 代理.
@property (assign, nonatomic) id<YFRotateViewDataSource> dataSource; //!< 数据源.
// !!!: 不需要暴漏这个属性.
@property (retain, nonatomic, readonly) UIScrollView * viewContainer; //!< 用于放置视图.

/**
 *  相册上正在显示几张图片.
 *
 *  @return 相册上正在显示的图片数量.
 */
- (NSUInteger) numberOfVisibleView;

/**
 *  初始化子视图.
 */
- (void) setupSubviews;

@end

