//
//  YFRotateView.h
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

// !!!: 用于同时支持ARC和MRC的宏,不应该写在pch文件里.而且宏的命名欠妥.请移到此处.
// FIXME: 类的命名,不合适.
@class YFRotateView;

// !!!: 协议: 可选的容错;必选的,直接崩程序.
@protocol YFRotateViewDelegate
/**
 *  设置轮转视图页眉的高度.
 *
 *  @param totateView 轮转视图.
 *
 *  @return 返回页眉高度.
 */
- (CGFloat) heightForHeaderInRotateView: (YFRotateView *) rotateView;

@optional

@end

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

@interface YFRotateView : UIView <UIScrollViewDelegate>
//@property (retain, nonatomic) UIView * initView; //!< 相册初始化完成时,显示在相册上的视图.
@property (assign, nonatomic) id<YFRotateViewDelegate> delegate; //!< 代理.
@property (assign, nonatomic) id<YFRotateViewDataSource> dataSource; //!< 数据源.
// !!!: 不需要暴漏这个属性.
@property (retain, nonatomic, readonly) UIScrollView * viewContainer; //!< 用于放置视图.

/**
 *  相册上正在显示几张图片.
 *
 *  @return 相册上正在显示的图片数量.
 */
- (NSUInteger) numberOfVisibleViews;

/**
 *  初始化子视图.
 */
- (void) setupSubviews;

/**
 *  显示第几个位置的视图.
 *
 *  @param index 要显示的视图的位置.
 */
- (void) showCellAtIndex: (NSUInteger) index;

@end

