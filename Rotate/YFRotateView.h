//
//  YFRotateView.h
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

// ???:在ARC编译下,看它是否真的支持.
/* 使工程同时支持 ARC 和 MRC 编译. */
#if ! __has_feature(objc_arc)
#define YFRVAutorelease(__v) ([__v autorelease]);
#define YFRVReturnAutoreleased YFRVAutorelease

#define YFRVRetain(__v) ([__v retain]);
#define YFRVReturnRetained YFRVRetain

#define YFRVRelease(__v) ([__v release]);
#else
// -fobjc-arc
#define YFRVAutorelease(__v)
#define YFRVReturnAutoreleased(__v) (__v)

#define YFRVRetain(__v)
#define YFRVReturnRetained(__v) (__v)

#define YFRVRelease(__v)
#endif

@class YFRotateView;

// ???:如何前向声明 协议! tableView好像做到了@
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

// !!!: 或许应该增加两个代理方法,来指明,在最左边和最右边,再拖动,应该做什么!
@interface YFRotateView : UIView <UIScrollViewDelegate>
//@property (retain, nonatomic) UIView * initView; //!< 相册初始化完成时,显示在相册上的视图.
@property (assign, nonatomic) id<YFRotateViewDelegate> delegate; //!< 代理.
@property (assign, nonatomic) id<YFRotateViewDataSource> dataSource; //!< 数据源.

@end

