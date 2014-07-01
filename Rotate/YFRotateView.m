//
//  YFRotateView.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFRotateView.h"

@interface YFRotateView ()
@property (retain, nonatomic) NSMutableArray * YFRVVisibleViews; //!< 存储相册上可以看到的视图.
@property (retain, nonatomic) UIScrollView * viewContainer; //!< 用于放置视图.
@property (retain, nonatomic) UIView * headerView; //!< 页眉用于导航.
@end

@implementation YFRotateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
    
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.05)];
        headerView.backgroundColor = [UIColor blackColor];
        self.headerView = headerView;
        Release(headerView);
        [self addSubview: self.headerView];
        
        
        UIScrollView * viewContainer = [[UIScrollView alloc] initWithFrame: CGRectMake(0, self.headerView.frame.size.height, self.frame.size.width, self.frame.size.height - self.headerView.frame.size.height-64)];
        viewContainer.contentSize =  CGSizeMake(2 * self.frame.size.width, 0);
        viewContainer.backgroundColor = [UIColor greenColor];
        viewContainer.pagingEnabled = YES;
        // ???: 迭代至此!
        // ???: 两个疑问:a.使用约束能否解决控制器 self.view会自动调整的影响?
        // ???: b.能否解决已有问题:设置 bouds 值时,相册位于固定位置.
//        [viewContainer addConstraint:<#(NSLayoutConstraint *)#>];
        self.viewContainer = viewContainer;
        Release(viewContainer);
        [self addSubview: self.viewContainer];
        
        // !!!:测试一个方法.
        viewContainer.autoresizingMask =     UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight;
        
//        UIImageView * leftView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        leftView.backgroundColor = [UIColor greenColor];
//        leftView.image = [UIImage imageNamed: @"001.jpg"];
//        [self addSubview: leftView];
//        Release(leftView);
//        
//        UIImageView * rightView = [[UIImageView alloc] initWithFrame: CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
//        rightView.image = [UIImage imageNamed: @"002.jpg"];
//        rightView.backgroundColor = [UIColor blueColor];
//        [self addSubview: rightView];
//        Release(rightView);
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSUInteger) numberOfVisibleView
{
    return _YFRVVisibleViews.count;
}

//- (void)setDataSource:(id<YFRotateViewDataSource>)dataSource
//{
//    
//}

# pragma mark - 协议方法
- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    CGFloat width = scrollView.frame.size.width; // 相册宽度.
    CGFloat x = scrollView.contentOffset.x; // 相册偏移.
    
    /* 计算相册上应该出现几张图片. */
    NSInteger countShould = 1;
    //    if (0 != x && width != x) {
    //        countShould = 2;
    //    }
    
    /* 屏幕上此时已经出现了几张图片. */
//    NSUInteger countVisible = [scrollView numberOfVisibleView];
//    
//    if (countShould == countVisible) { // 刚刚好.
//        return;
//    }
//    
//    if(countShould > countVisible){ // 需要增加显示另一个视图.
//        
//    }
}
@end
