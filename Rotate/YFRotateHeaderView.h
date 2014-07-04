//
//  YFRotateHeaderView.h
//  Rotate
//
//  Created by 颜风 on 14-7-4.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用于约定页眉的行为和行为.
 */
@protocol YFRotateHeaderViewDelegate <NSObject>

@end

/**
 * 用于约定为页眉提供数据.
 */
@protocol YFRotateHeaderViewDataSource <NSObject>

@end

@interface YFRotateHeaderView : UIScrollView

@end
