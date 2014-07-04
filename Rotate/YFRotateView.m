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
@property (retain, nonatomic) UIView * YFRVHeaderView; //!< 页眉用于导航.
@property (retain, nonatomic) NSMutableDictionary * YFRVVisibleViews; //!< 存储已经放到到视图容器上的视图,以视图的位置为键,以视图对象为值.

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

- (void) setupSubviews;
{
    if (nil == self.window) { // 说明当前还不需要显示此视图,直接返回.
        return;
    }
    
    /* 使用"约束"进行界面布局. */
    // 考虑一种特例: 子类无意中重写了父类私有属性的 设置器或者get方法,此时父类中的点语法,还能正常工作吗?如果不能,请给私有变量统一加前缀!
    NSNumber *  navHeight = self.YFRVheightOfNavigation; //!< 导航栏高度.
    NSNumber * headerHeight = self.YFRVheightOfHeaderView; //!< 页眉高度.
    
    // 设置页眉.
    UIView * headerView = [[UIView alloc] init];
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
    viewContainer.delaysContentTouches = YES;
    viewContainer.pagingEnabled = YES;
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
    
    [self showCellAtIndex: indexOfSetUpCell];
}

- (void) showCellAtIndex: (NSUInteger) index
{
    if (nil == self.YFRVVisibleViews) { // 初始化 visibleViews 属性.
        self.YFRVVisibleViews = [NSMutableDictionary dictionaryWithCapacity: 42];
    }
    
    // 视图约束中需要使用这些数据.
    NSNumber * widthOfViewContainer = [NSNumber numberWithDouble: self.frame.size.width]; // 视图容器的宽度,默认与父视图同宽.
    NSNumber * heightOfViewContainer = [NSNumber numberWithDouble: self.frame.size.height - [self.YFRVheightOfHeaderView doubleValue] - [self.YFRVheightOfNavigation doubleValue]];
    
    if(1 == self.YFRVVisibleViews.count){
        // !!!:临时加一个判断:
        NSLog(@"show1:%g",self.YFRVViewContainer.contentOffset.x);
        
        
        NSString * indexStr = [NSString stringWithFormat:@"%lu", index];
        UIView * visibleView = [self.YFRVVisibleViews objectForKey: indexStr];
        
        if (nil != visibleView) { // 说明此位置的视图已被设置,直接返回即可.
            return;
        }
        
        // 获取已经被设置的视图及其位置
        visibleView = [[self.YFRVVisibleViews allValues] lastObject];
        NSUInteger indexVisible = [[[self.YFRVVisibleViews allKeys] lastObject] integerValue];
     
        // 分析滑动方向,YES,向左;NO,向右.
        BOOL direction = NO;
        if (index < indexVisible) { // 向左移.
            direction = YES;
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
        // !!!:临时测试.
        NSString * visualStr = @"|[cell(==widthOfViewContainer)][visibleView(==cell)]|"; // 向左滑.
        if (YES != direction) { // 向右滑.
            visualStr = @"|[visibleView(==widthOfViewContainer)][cell(==visibleView)]|";
        }
        
// !!!:原可用代码.
//        NSString * visualStr = @"|[cell(==widthOfViewContainer)][visibleView(==cell)]|"; // 向左滑.
//        if (YES != direction) { // 向右滑.
//            visualStr = @"|[visibleView(==widthOfViewContainer)][cell(==visibleView)]|";
//        }
        
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: visualStr options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(cell,visibleView)]];
        
        [self.YFRVViewContainer addConstraints:constraintsArray];
        [self.YFRVVisibleViews setObject: cell forKey:[NSString stringWithFormat:@"%lu", index]];

        // 临时添加
        // !!!:向左滑,需要设置offset值.
        if (YES == direction) {
//            CGPoint offset = self.YFRVViewContainer.contentOffset;
//            offset.x = 0; // 此处不能使用值self.YFRVViewContainer.frame.size.width,以免被误判为"要删除前一张图片的情况."
//            self.YFRVViewContainer.contentOffset = offset;
            CGRect bounds = self.YFRVViewContainer.bounds;
            bounds.origin.x = 320;
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
    
    [self.YFRVVisibleViews setObject: cell forKey: [NSString stringWithFormat: @"%lu", index]];
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
    scrollView.bounces = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{

    NSLog(@"观察bouds 与 offset的关系");
    NSLog(@"offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
    NSLog(@"bouds:%@", NSStringFromCGRect(scrollView.bounds));
    
    // ???:这种特殊情况产生的特殊原因到底是什么?为什么会来不及更新"约束"?
    /* 当scrollView.contentOffset.x的值由320突变到0或者0.5时,此代理方法也会被执行.
     此种情况必须排除,否则会引起非预期行为.
     可以验证:scrollViewDidScroll检测到的单次偏移的最小值是0.5
     可以验证:但视图容器只存在单个视图视图时,其x=0,y=0.*/
    if (scrollView.contentOffset.x >0 && scrollView.contentOffset.x < 0.51) {
        // ???:此处修正bouds值,真的有意义吗?
        CGRect bounds = self.YFRVViewContainer.bounds;
        bounds.origin.x = 0;
        self.YFRVViewContainer.bounds = bounds;
        return;
    }
    
    if (0 == self.YFRVVisibleViews.count) { // 说明滚动视图还没初始化,直接返回即可.

        
        return;
    }
    
    if (1 == self.YFRVVisibleViews.count) { // 说明此时需要一个额外的视图.
        NSLog(@"要添加视图:%g", scrollView.contentOffset.x);
        
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
        [self showCellAtIndex: indexToVisible];
        
        CGPoint offset = self.YFRVViewContainer.contentOffset;
        CGSize contentSize = self.YFRVViewContainer.contentSize;
        NSArray * array = self.YFRVViewContainer.constraints;
        CGRect frame = self.YFRVViewContainer.frame;
        CGRect bounds = self.YFRVViewContainer.bounds;
        
        return;
    }
    
    // 说明此时视图容器上已经显示了两张视图.
    if (0 == self.YFRVViewContainer.contentOffset.x) { // 隐藏后一张视图.
        // !!!:建议封装隐藏视图的算法.
        NSArray * keys = [self.YFRVVisibleViews allKeys];
        NSUInteger indexSmaller = [(NSString *)keys[0] integerValue];
        
        if ([keys[1] integerValue] < [keys[0] integerValue]) {
            indexSmaller = [(NSString *)keys[1] integerValue];
        }
        
        [self.YFRVVisibleViews enumerateKeysAndObjectsUsingBlock:^(id key, UIView * obj, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [self.YFRVVisibleViews removeAllObjects];
        
        [self showCellAtIndex: indexSmaller];
        
        return;
    }
    
    NSLog(@"offset:%g", self.YFRVViewContainer.contentOffset.x);
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
        
        [self showCellAtIndex: indexBigger];
        
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
    YFRVAutorelease(heightValue);

    return heightValue;
}

- (NSNumber *) YFRVheightOfNavigation
{
    // ???:不同机型下,导航栏高度一样吗?如何动态获取导航栏高度.?
    
    CGFloat height = 64.0; // 默认64.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForNavigationInRotateView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForNavigationInRotateView: self];
    }
    
    NSNumber * heightValue = [NSNumber numberWithDouble: height];
    YFRVAutorelease(heightValue);
    
    return heightValue;
}

@end
