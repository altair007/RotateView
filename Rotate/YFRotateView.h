//
//  YFRotateView.h
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFRotateHeaderView.h"

// !!!:帮连长解决掉那个BUG.即下一步研究上拉加载,下拉刷新.

@class YFRotateView;

/**
 *  轮转视图布局协议.
 */
@protocol YFRotateViewDelegate <NSObject>
@optional
/**
 *  设置轮转视图页眉的高度.默认30.0.
 *
 *  @param totateView 轮转视图.
 *
 *  @return 返回页眉高度.
 */
- (CGFloat) heightForHeaderInRotateView: (YFRotateView *) rotateView;

/**
 *  设置轮转视图所在页面导航栏的高度.默认为 64.0 .
 *
 *  注意: 导航栏并不是轮转视图内部封装的一部分.轮转视图本身将假设你会将其放到一个导航控制器(UINavigationController)
 *       进行管理.如果你使用了自定义的导航栏,且其高度不是64.0,请实现此代理方法,返回一个合适的高度.
 *
 *  @param totateView 轮转视图.
 *
 *  @return 返回页眉高度.
 */
- (CGFloat) heightForNavigationInRotateView: (YFRotateView *) rotateView;

@optional

@end

/**
 *  轮转视图数据源协议.
 */
@protocol YFRotateViewDataSource <NSObject>

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
@optional
/**
 *  设置初始显示哪个位置的视图.
 *
 *  @param rotateView 轮转视图对象.
 *
 *  @return 初始显示视图的位置.
 */
- (NSUInteger) indexForSetupCellInRotateView:(YFRotateView *) rotateView;

@end

// !!!:问题出现这里!自动-64,是我做的!!!
@interface YFRotateView : UIView <UIScrollViewDelegate, YFRotateHeaderViewDelegate, YFRotateHeaderViewDataSource>
//@property (retain, nonatomic) UIView * initView; //!< 相册初始化完成时,显示在相册上的视图.
@property (assign, nonatomic) id<YFRotateViewDelegate> delegate; //!< 代理.
@property (assign, nonatomic) id<YFRotateViewDataSource> dataSource; //!< 数据源.

@end

