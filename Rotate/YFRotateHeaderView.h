//
//  YFRotateHeaderView.h
//  Rotate
//
//  Created by 颜风 on 14-7-4.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFRotateHeaderView;
/**
 *  用于约定页眉的行为和行为.
 */
@protocol YFRotateHeaderViewDelegate <NSObject>

@optional
- (CGFloat) heightForCellInRotateHeaderView: (YFRotateHeaderView *) rotateHeaderView;

@end

/**
 * 用于约定为页眉提供数据.
 */
@protocol YFRotateHeaderViewDataSource <NSObject>

@required
/**
 *  所有用于在页眉中显示的标题.页眉中将按照数组给定的顺序显示这些标题.
 *
 *  @param rotateHeaderView 轮转视图页眉.
 *
 *  @return 一个数组,数组中存储的是字符串对象,表示所有要在页眉中的标题.
 */
- (NSArray *) titlesForShowInRotateHeaderView: (YFRotateHeaderView *) rotateHeaderView;

@end

@interface YFRotateHeaderView : UIView
@property (assign, nonatomic) id<YFRotateHeaderViewDelegate> delegate;//!< 布局代理.
@property (assign, nonatomic) id<YFRotateHeaderViewDataSource> dataSource; //!<数据源代理.
@end
