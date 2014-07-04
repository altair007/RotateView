//
//  YFRotateView.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

/**
 *  滚动视图移动方向.
 */
typedef enum{
    YFRVScrollLeft, //!< 左移.
    YFRVScrollRight //!< 右移.
}YFRVScrollDirection;

#import "YFRotateView.h"

@interface YFRotateView ()
#pragma mark - 私有属性.

@property (retain, nonatomic) UIScrollView * YFRVViewContainer; //!< 用于放置视图.
@property (retain, nonatomic) UISegmentedControl * YFRVHeaderView; //!< 页眉用于导航.
@property (retain, nonatomic) NSMutableDictionary * YFRVVisibleViews; //!< 存储已经放到到视图容器上的视图,以视图的位置为键,以视图对象为值.
@property (assign, nonatomic) NSUInteger  YFRVIndexOfCurrentPage; //!< 当前页面的位置.

#pragma mark - 私有方法.
/**
 *  获取页眉高度.
 *
 *  @return 页眉高度.
 */
- (NSNumber *) YFRVheightOfHeaderView;

/**
 *  获取导航栏高度.
 *
 *  @return 导航栏高度.
 */
- (NSNumber *) YFRVheightOfNavigation;


/**
 *  初始化子视图.
 */
- (void) YFRVSetupSubviews;

/**
 *  显示第几个位置的视图.
 *
 *  @param index 要显示的视图的位置.
 */
- (void) YFRVShowCellAtIndex: (NSUInteger) index;

@end

@implementation YFRotateView
- (void)dealloc
{
    self.YFRVViewContainer = nil;
    self.YFRVHeaderView = nil;
    self.YFRVVisibleViews = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YFRVSetupSubviews) name: UIWindowDidBecomeVisibleNotification object: nil];
    }
    return self;
}

- (void) YFRVSetupSubviews;
{
    if (nil == self.window) { // 说明当前还不需要显示此视图,直接返回.
        return;
    }
    
    /* 使用"约束"进行界面布局. */
    // 考虑一种特例: 子类无意中重写了父类私有属性的 设置器或者get方法,此时父类中的点语法,还能正常工作吗?如果不能,请给私有变量统一加前缀!
    NSNumber *  navHeight = self.YFRVheightOfNavigation; //!< 导航栏高度.
    NSNumber * headerHeight = self.YFRVheightOfHeaderView; //!< 页眉高度.
    
    /* 设置页眉. */
    // !!!:初始获取页眉要优化.位置在设置初始化视图时,更合适吧!
    NSMutableArray * titles = [NSMutableArray arrayWithCapacity: 42];
    for (NSUInteger i = 0; i < 3; i++) {
        [titles addObject:[self.dataSource rotateView:self titleForCellAtIndex:i]];
    }
    
    UISegmentedControl * headerView = [[UISegmentedControl alloc] initWithItems: titles];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.YFRVHeaderView = headerView;
    [self addSubview: self.YFRVHeaderView];
    YFRVRelease(headerView);
    
    // 设置视图容器.
    UIScrollView * viewContainer = [[UIScrollView alloc]init];
    viewContainer.backgroundColor = [UIColor greenColor];
    viewContainer.showsVerticalScrollIndicator = NO;
    viewContainer.showsHorizontalScrollIndicator = NO;
    viewContainer.pagingEnabled = YES;
    viewContainer.bounces = NO;
    
    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    viewContainer.delegate = self;
    self.YFRVViewContainer = viewContainer;
    YFRVRelease(viewContainer);
    [self addSubview: self.YFRVViewContainer];
    
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
    
    [self YFRVShowCellAtIndex: indexOfSetUpCell];
}

- (void) YFRVShowCellAtIndex: (NSUInteger) index
{
    if (index >= [self.dataSource numberOfCellsInRotateView:self]) { // 超出给定视图数量
        return;
    }
    
    if (nil == self.YFRVVisibleViews) { // 初始化 visibleViews 属性.
        self.YFRVVisibleViews = [NSMutableDictionary dictionaryWithCapacity: 42];
    }
    
    // 视图约束中需要使用这些数据.
    NSNumber * widthOfViewContainer = [NSNumber numberWithDouble: self.frame.size.width]; // 视图容器的宽度,默认与父视图同宽.
    NSNumber * heightOfViewContainer = [NSNumber numberWithDouble: self.frame.size.height - [self.YFRVheightOfHeaderView doubleValue] - [self.YFRVheightOfNavigation doubleValue]];
    
    if(1 == self.YFRVVisibleViews.count){
        NSString * indexStr = [NSString stringWithFormat:@"%@", [NSNumber numberWithUnsignedInteger: index]];
        UIView * visibleView = [self.YFRVVisibleViews objectForKey: indexStr];
        
        if (nil != visibleView) { // 说明此位置的视图已被设置,直接返回即可.
            return;
        }
        
        // 获取已经被设置的视图及其位置
        visibleView = [[self.YFRVVisibleViews allValues] lastObject];
        NSUInteger indexVisible = [[[self.YFRVVisibleViews allKeys] lastObject] integerValue];
        
        YFRVScrollDirection direction = YFRVScrollRight;
        if (index < indexVisible) { // 向左移.
            direction = YFRVScrollLeft;
        }
        
        // 移除已有的"约束",避免冲突.
        [self.YFRVViewContainer removeConstraints: self.YFRVViewContainer.constraints];
        
        UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
        cell.backgroundColor = [UIColor redColor];
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        [self.YFRVViewContainer addSubview: cell];
        
        /* 为视图容器设置新的视图约束. */
        NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];

        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[visibleView(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(visibleView)]];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(cell)]];
        
        // 水平方向上的视图约束,需要根据是左移还是右移,分别考虑.
        NSString * visualStr = @"|[cell(==widthOfViewContainer)][visibleView(==cell)]|"; // 向左滑.
        if (YFRVScrollLeft != direction) { // 向右滑.
            visualStr = @"|[visibleView(==widthOfViewContainer)][cell(==visibleView)]|";
        }
        
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: visualStr options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(cell,visibleView)]];
        
        [self.YFRVViewContainer addConstraints:constraintsArray];
        [self.YFRVVisibleViews setObject: cell forKey:[NSString stringWithFormat:@"%@", [NSNumber numberWithUnsignedInteger: index]]];

        if (YFRVScrollLeft == direction) { // 修正容器视图的bouds值,以正确显示图形.
            CGRect bounds = self.YFRVViewContainer.bounds;
            bounds.origin.x = self.YFRVViewContainer.frame.size.width;
            self.YFRVViewContainer.bounds = bounds;
        }
        
        return;
    }
    
    [self.YFRVViewContainer removeConstraints: self.YFRVViewContainer.constraints];
    
    // 必须要将让内容宽度比视图容器宽度略大,否则将不能滚动.
    NSNumber * withOfContent = [NSNumber numberWithDouble: self.frame.size.width + 0.25];
    
    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
    cell.backgroundColor = [UIColor cyanColor];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    [self.YFRVViewContainer addSubview: cell];
    
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[cell(==withOfContent)]|" options:0 metrics:NSDictionaryOfVariableBindings(withOfContent) views: NSDictionaryOfVariableBindings(cell)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(cell)]];
    
    [self.YFRVViewContainer addConstraints:constraintsArray];
    
    [self.YFRVVisibleViews setObject: cell forKey: [NSString stringWithFormat: @"%@", [NSNumber numberWithUnsignedInteger: index]]];
    
    self.YFRVIndexOfCurrentPage = index;
    
    /* 为视图容器设置合适的bouds值
     * 这一步是必须的.因为容器视图的子视图比容器视图本身略宽,此处如果不将容器视图的边框显式置为0,容器视图会自动调整,以试图完整显示内容,引起contentOffset向右偏移0.5,然后会出现非预期行为.
     */
    CGRect bounds = self.YFRVViewContainer.bounds;
    bounds.origin.x = 0;
    if([self.dataSource numberOfCellsInRotateView: self] ==
     [[self.YFRVVisibleViews allKeys][0]integerValue]+1) { // 当视图是最后一个视图时,需特殊处理.
        bounds.origin.x = 0.5;
    }
    self.YFRVViewContainer.bounds = bounds;
}

# pragma mark - 协议方法

/* 在快速拖动时,有一定几率出现BUG:看到部分空白.原因是UIScrollView的回弹功能引起的.
 修复方案是:开始加速前关闭"回弹"; 结束加速时,重新开启"回弹".
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.bounces = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 当视图是最左或最右的视图时,不能打开"回弹"效果.
    if (0 == [self.YFRVVisibleViews.allKeys[0] integerValue]) { // 说明正在显示最左端视图.
        return;
    }
    
    if ([self.dataSource numberOfCellsInRotateView: self] == [self.YFRVVisibleViews.allKeys[0] integerValue] + 1) { // 说明正在显示最右端视图.
        
        /* 临时关闭pagingEnbaled属性,否则单击最后一个视图,会闪跳至倒数第二个视图.*/
        CGRect bouds = scrollView.bounds;
        bouds.origin.x = 0.5;
        scrollView.bounds = bouds;
        scrollView.pagingEnabled = NO;
        return;
    }
    
    scrollView.bounces = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    if (0 == self.YFRVVisibleViews.count) { // 说明滚动视图还没初始化,直接返回即可.
        return;
    }
    
    /* 当视图是最后一个视图时,会关闭分页功能,所以此处需要显示开启分页功能. */
    scrollView.pagingEnabled = YES;
    
    if (1 == self.YFRVVisibleViews.count) { // 说明此时可能需要一个额外的视图.
        
        
        // 获取偏移位置.
        YFRVScrollDirection direction = YFRVScrollLeft;
        
        if (self.YFRVViewContainer.contentOffset.x > 0.25) {
            direction = YFRVScrollRight;
        }

        // 获取当前显示的视图的位置.
        NSUInteger index = [[[self.YFRVVisibleViews allKeys] lastObject] integerValue];
        
        // 根据偏移方向判断显示哪个位置的视图.
        NSUInteger changeIndex = 1;
        if (YFRVScrollLeft == direction) {
            changeIndex = - 1;
        }
        NSUInteger indexToVisible = index + changeIndex;
        
        // 使指定位置视图可视.
        [self YFRVShowCellAtIndex: indexToVisible];
        return;
    }
    
    // 说明此时视图容器上已经显示了两张视图.
    if (0 == self.YFRVViewContainer.contentOffset.x) { // 隐藏后一张视图.
        NSArray * keys = [self.YFRVVisibleViews allKeys];
        NSUInteger indexSmaller = [(NSString *)keys[0] integerValue];
        
        if ([keys[1] integerValue] < [keys[0] integerValue]) {
            indexSmaller = [(NSString *)keys[1] integerValue];
        }
        
        [self.YFRVVisibleViews enumerateKeysAndObjectsUsingBlock:^(id key, UIView * obj, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self.YFRVVisibleViews removeAllObjects];
        
        [self YFRVShowCellAtIndex: indexSmaller];
        
        return;
    }
    
    if (self.YFRVViewContainer.frame.size.width == self.YFRVViewContainer.contentOffset.x) { // 隐藏前一张视图,即只显示已存在的两张视图中的后一张视图.

        // 获取视图位置的较大值.
        NSArray * keys = [self.YFRVVisibleViews allKeys];
        NSUInteger indexBigger = [(NSString *)keys[0] integerValue];
        
        if ([keys[1] integerValue] > [keys[0] integerValue]) {
            indexBigger = [(NSString *)keys[1] integerValue];
        }

        [self.YFRVVisibleViews enumerateKeysAndObjectsUsingBlock:^(id key, UIView * obj, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self.YFRVVisibleViews removeAllObjects];
        
        [self YFRVShowCellAtIndex: indexBigger];
        
        return;
    }
}

#pragma mark - 私有方法
- (NSNumber *)YFRVheightOfHeaderView
{
    CGFloat height = 30.0; // 默认30.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForHeaderInRotateView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForHeaderInRotateView: self];
    }
    
    NSNumber * heightValue = [NSNumber numberWithDouble: height];
    return heightValue;
}

- (NSNumber *) YFRVheightOfNavigation
{
    CGFloat height = 64.0; // 默认64.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForNavigationInRotateView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForNavigationInRotateView: self];
    }
    
    NSNumber * heightValue = [NSNumber numberWithDouble: height];
    return heightValue;
}

- (void)setYFRVIndexOfCurrentPage:(NSUInteger)YFRVIndexOfCurrentPage
{
    _YFRVIndexOfCurrentPage = YFRVIndexOfCurrentPage;
    
    self.YFRVHeaderView.selectedSegmentIndex = YFRVIndexOfCurrentPage;
}
@end
