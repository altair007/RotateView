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
@property (retain, nonatomic) NSMutableArray * visibleViews; //!< 存储已经放到到视图容器上的视图.
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
    
    // 设置视图间的约束.
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[headerView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(headerView)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewContainer]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(viewContainer)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-navHeight-[headerView(==headerHeight)][viewContainer]|" options:0 metrics: NSDictionaryOfVariableBindings(navHeight, headerHeight) views: NSDictionaryOfVariableBindings(headerView,viewContainer)]];
    
    [self addConstraints: constraintsArray];
    
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
    // ???: 此处应该有一个逻辑,决定index大于视图总数量时,是轮转,还是终止旋转.
    
    if (2 == self.visibleViews.count) { // 容器中的视图数量达到最大值,直接返回.
        return;
    }
    
    // !!!: 验证瞬移现象是否存在.(从用户角度来说.).
//    UIView * temp = [[UIView alloc]init];
//    temp.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.viewContainer addSubview: temp];
    
    // 区分两种情况:
    if(1 == self.visibleViews.count)
    {
        CGPoint point = self.viewContainer.contentOffset;
        
       NSArray * constraintstemp = self.viewContainer.constraints;
        [self.viewContainer removeConstraints: constraintstemp];
        NSArray * constraintstemp2 = self.viewContainer.constraints;
        
        UIView * temp = [self.viewContainer.subviews objectAtIndex: 2];
        UIView * cell = [[UIView alloc] init];
        cell.backgroundColor = [UIColor redColor];
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        [self.viewContainer addSubview: cell];
        
        NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cell(==320)][temp(==320)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(cell,temp)]];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==478)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(cell)]];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[temp(==478)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(temp)]];
        
        
        [self.viewContainer addConstraints:constraintsArray];
        NSArray * constraints = self.viewContainer.constraints;
        [self.visibleViews addObject: cell];
        point.x = 320 + point.x;
        self.viewContainer.contentOffset = point;
        point = self.viewContainer.contentOffset;
        
        return;
    }
    
    
    // 需要在某个时机,更新约束!
    // ???:如何移除指定约束?
    
    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
    cell.backgroundColor = [UIColor cyanColor];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewContainer addSubview: cell];
    
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cell(==320.5)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(cell)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==478)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(cell)]];
    
    [self.viewContainer addConstraints:constraintsArray];
    
    if (nil == self.visibleViews) {
        self.visibleViews = [NSMutableArray arrayWithCapacity: 42];
    }
    [self.visibleViews addObject: cell];
    // 先获取已经存在的子视图.
//    UIView * temp = [[UIView alloc]init];
//        temp.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.viewContainer addSubview: temp];
//    
//    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
//    cell.backgroundColor = [UIColor cyanColor];
//    cell.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.viewContainer addSubview: cell];
//
//    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[temp(==320)][cell(==320)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(temp,cell)]];
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==478)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(cell)]];
//    
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[temp(==478)]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(temp)]];
//    
//    [self addConstraints:constraintsArray];
//    cell.frame = CGRectMake(self.viewContainer.frame.size.width * index, 0, 320, 400);
//    [self.viewContainer addSubview: cell];
}

# pragma mark - 协议方法
- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    [self showCellAtIndex:0];
    CGSize size = scrollView.contentSize;
    NSLog(@"%g", size.width);
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
