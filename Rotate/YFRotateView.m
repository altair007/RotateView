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
        [self setupSubviews];
    }
    return self;
}

- (NSUInteger) numberOfVisibleViews
{
    return _YFRVVisibleViews.count;
}

- (void) setupSubviews;
{
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor blackColor];
    [self addSubview: headerView];
    
    UIScrollView * viewContainer = [[UIScrollView alloc]init];
    viewContainer.backgroundColor = [UIColor greenColor];
    viewContainer.pagingEnabled = YES;
    [self addSubview: viewContainer];
    
    /* 使用"约束"进行界面布局. */
    
    // ???: 如何动态获取导航栏高度?
    // ???: 如何根据不同ios版本动态获取导航栏高度?
    NSNumber *  navHeight = [NSNumber numberWithFloat: 64.0]; //!< 导航栏高度.
    NSNumber * headerHeight = [NSNumber numberWithFloat: 20.0]; //!< 标题栏高度.
    
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];

    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[headerView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(headerView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewContainer]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(viewContainer)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-navHeight-[headerView(==headerHeight)][viewContainer]|" options:0 metrics: NSDictionaryOfVariableBindings(navHeight, headerHeight) views: NSDictionaryOfVariableBindings(headerView,viewContainer)]];
    
    [self addConstraints: constraintsArray];
    
    self.headerView = headerView;
    Release(headerView);
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.viewContainer = viewContainer;
    Release(viewContainer);
    self.viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.viewContainer.contentSize = CGSizeMake(self.frame.size.width * 2, 0);
}

- (void)setDataSource:(id<YFRotateViewDataSource>)dataSource
{
    /* 设置属性. */
    [dataSource retain];
    [_dataSource release];
    _dataSource = dataSource;
    
    /* 设置页面上初始显示的视图. */
    NSUInteger indexOfSetUpCell = 0;
    if ([dataSource respondsToSelector: @selector(indexForSetupCellInRotateView:)]) {
        indexOfSetUpCell = [dataSource indexForSetupCellInRotateView: self];
        
        if (indexOfSetUpCell > [dataSource numberOfCellsInRotateView:self]) {
            indexOfSetUpCell = 0;
        }
    }

    // ???:此方法需要和一个显示视图的方法封装.
    [self showCellAtIndex: indexOfSetUpCell];
}

- (void) showCellAtIndex: (NSUInteger) index
{
    // ???: 这个方法,好像很鸡肋.
    // ???:tableView中,代理方法是在设置代理之后立即执行吗?仔细看一下执行时机.
    // ???: 此处只能使用"约束"了!
    // ???: 约束会受bouds的影响吗?
    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
    cell.frame = CGRectMake(self.viewContainer.frame.size.width * index, 0, 320, 400);
    CGRect rect = cell.frame;
    [self.viewContainer addSubview: cell];
}

# pragma mark - 协议方法
- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    /* 获取视图位置. */
    // ???: 可能需要用到取整方法.
    NSUInteger index = (scrollView.contentOffset.x / 320);
    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
    // ???: 暂时先不用"约束"!请改用"约束".
    // ???: 可以用leftView和rightView,固定位置.作为cell的父视图.
    cell.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [scrollView addSubview: cell];
    
//    CGFloat width = scrollView.frame.size.width; // 相册宽度.
//    CGFloat x = scrollView.contentOffset.x; // 相册偏移.
//    
//    /* 计算相册上应该出现几张图片. */
//    NSInteger countShould = 1;
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
