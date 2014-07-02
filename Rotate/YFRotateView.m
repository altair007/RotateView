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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSubviews) name: UIWindowDidBecomeVisibleNotification object: nil];
    }
    return self;
}

- (NSUInteger) numberOfVisibleViews
{
    return _YFRVVisibleViews.count;
}

- (void) setupSubviews;
{
    if (nil == self.window) { // 说明当前还不需要显示此视图,直接返回.
        return;
    }
    
    /* 使用"约束"进行界面布局. */
    // ???: 如何动态获取导航栏高度?如何根据不同ios版本动态获取导航栏高度?
    NSNumber *  navHeight = [NSNumber numberWithFloat: 64.0]; //!< 导航栏高度.
    NSNumber * headerHeight = [NSNumber numberWithFloat: 20.0]; //!< 标题栏高度.
    
    // 设置页眉.
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView = headerView;
    [self addSubview: self.headerView];
    Release(headerView);
    
    // 设置视图容器.
    UIScrollView * viewContainer = [[UIScrollView alloc]init];
    viewContainer.backgroundColor = [UIColor greenColor];
    viewContainer.contentSize = CGSizeMake(self.frame.size.width * 2, 0);
    viewContainer.pagingEnabled = YES;
    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    viewContainer.delegate = self;
    self.viewContainer = viewContainer;
    Release(viewContainer);
    [self addSubview: self.viewContainer];
    
    /* 设置视图容器的两个子视图及其约束.*/
    UIView * firstView = [[UIView alloc] init];
    firstView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewContainer addSubview: firstView];
    Release(firstView);
    
    UIView * secondeView = [[UIView alloc] init];
    secondeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewContainer addSubview: secondeView];
    Release(secondeView);
    
    // 设置视图间的约束.
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[headerView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(headerView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewContainer]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(viewContainer)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-navHeight-[headerView(==headerHeight)][viewContainer]|" options:0 metrics: NSDictionaryOfVariableBindings(navHeight, headerHeight) views: NSDictionaryOfVariableBindings(headerView,viewContainer)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[firstView(==320)][secondeView(==320)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(firstView, secondeView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[firstView(>=300)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(firstView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[secondeView(==firstView)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(secondeView, firstView)]];
    
    [self addConstraints: constraintsArray];

    
    // !!!:临时设置的视图背景色
    firstView.backgroundColor = [UIColor redColor];
    secondeView.backgroundColor = [UIColor blueColor];

//    [self.viewContainer addConstraints: constraintsOfViewContainer];
    
//    [self addConstraints: constraintsArray];
    
    /* 设置页面上初始显示的视图. */
    NSUInteger indexOfSetUpCell = 0;
    if ([self.dataSource respondsToSelector: @selector(indexForSetupCellInRotateView:)]) {
        indexOfSetUpCell = [self.dataSource indexForSetupCellInRotateView: self];
        
        if (indexOfSetUpCell > [self.dataSource numberOfCellsInRotateView:self]) {
            indexOfSetUpCell = 0;
        }
    }
    [self showCellAtIndex: indexOfSetUpCell];
}

- (void) showCellAtIndex: (NSUInteger) index
{
    
    // ???: 这个方法,好像很鸡肋.
    // ???:tableView中,代理方法是在设置代理之后立即执行吗?仔细看一下执行时机.
    // ???: 此处只能使用"约束"了!
    // ???: 约束会受bouds的影响吗?
    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewContainer addSubview: cell];

    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    CGRect frame = self.viewContainer.frame;
    frame = self.viewContainer.bounds;
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"H:[cell(==320)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(cell)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==478)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(cell)]];
    
    [self.viewContainer addConstraints:constraintsArray];
//    cell.frame = CGRectMake(self.viewContainer.frame.size.width * index, 0, 320, 400);
//    [self.viewContainer addSubview: cell];
}

# pragma mark - 协议方法
- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    /* 获取视图位置. */
    // ???: 可能需要用到取整方法.
//    NSUInteger index = (scrollView.contentOffset.x / 320);
//    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
//    // ???: 暂时先不用"约束"!请改用"约束".
//    // ???: 可以用leftView和rightView,固定位置.作为cell的父视图.
//    cell.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
//    [scrollView addSubview: cell];
    
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
