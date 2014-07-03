//
//  YFRotateView.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFRotateView.h"

@interface YFRotateView ()
#pragma mark - 私有属性.
@property (retain, nonatomic) NSMutableArray * YFRVVisibleViews; //!< 存储相册上可以看到的视图.
@property (retain, nonatomic) UIScrollView * viewContainer; //!< 用于放置视图.
@property (retain, nonatomic) UIView * headerView; //!< 页眉用于导航.
@property (retain, nonatomic) NSMutableDictionary * visibleViews; //!< 存储已经放到到视图容器上的视图,以视图的位置为键,以视图对象为值.

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
    // 考虑一种特例: 子类无意中重写了父类私有属性的 设置器或者get方法,此时父类中的点语法,还能正常工作吗?如果不能,请给私有变量统一加前缀!
    NSNumber *  navHeight = self.YFRVheightOfNavigation; //!< 导航栏高度.
    NSNumber * headerHeight = self.YFRVheightOfHeaderView; //!< 页眉高度.
    
    // 设置页眉.
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerView = headerView;
    [self addSubview: self.headerView];
    YFRVRelease(headerView);
    
    // 设置视图容器.
    UIScrollView * viewContainer = [[UIScrollView alloc]init];
    viewContainer.backgroundColor = [UIColor greenColor];
    viewContainer.contentSize = CGSizeMake(self.frame.size.width * 2, 0);
    viewContainer.pagingEnabled = YES;
    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    viewContainer.delegate = self;
    self.viewContainer = viewContainer;
    YFRVRelease(viewContainer);
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
    
    if (nil == self.visibleViews) { // 初始化 visibleViews 属性.
        self.visibleViews = [NSMutableDictionary dictionaryWithCapacity: 42];
    }
    
    if (2 == self.visibleViews.count) { // 容器中的视图数量达到最大值,直接返回.
        return;
    }
    
    // 视图约束中需要使用这些数据.
    NSNumber * widthOfViewContainer = [NSNumber numberWithDouble: self.frame.size.width]; // 视图容器的宽度,默认与父视图同宽.
    NSNumber * heightOfViewContainer = [NSNumber numberWithDouble: self.frame.size.height - [self.YFRVheightOfHeaderView doubleValue] - [self.YFRVheightOfNavigation doubleValue]];
    
    if(1 == self.visibleViews.count){
        NSString * indexStr = [NSString stringWithFormat:@"%lu", index];
        UIView * visibleView = [self.visibleViews objectForKey: indexStr];
        
        if (nil != visibleView) { // 说明此位置的视图已被设置,直接返回即可.
            return;
        }
        
        // 获取已经被设置的视图及其位置
        visibleView = [[self.visibleViews allValues] lastObject];
        NSUInteger indexVisible = [[[self.visibleViews allKeys] lastObject] integerValue];
     
        // 分析滑动方向,YES,向左;NO,向右.
        BOOL direction = NO;
        if (index < indexVisible) { // 向左移.
            direction = YES;
        }
        
        // 获取视图目前的偏移值,以供计算偏移后目标的偏移值.
        CGPoint offsetOriginal = self.viewContainer.contentOffset;
        
        // 移除已有的"约束",避免冲突.
        NSArray * constraintstemp = self.viewContainer.constraints;
        [self.viewContainer removeConstraints: constraintstemp];
        
        UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
        cell.backgroundColor = [UIColor redColor];
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        [self.viewContainer addSubview: cell];
        
        /* 为视图容器设置新的视图约束. */
        NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];

        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[visibleView(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(visibleView)]];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(cell)]];
        
        // 水平方向上的视图约束,需要根据是左移还是右移,分别考虑.
        NSString * visualStr = @"|[cell(==widthOfViewContainer)][visibleView(==cell)]|"; // 向左滑.
        if (YES != direction) { // 向右滑.
            visualStr = @"|[visibleView(==widthOfViewContainer)][cell(==visibleView)]|";
        }
        
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: visualStr options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(cell,visibleView)]];

        
        [self.viewContainer addConstraints:constraintsArray];
        [self.visibleViews setObject: cell forKey:[NSString stringWithFormat:@"%lu", index]];
        
        // 根据是左滑还是右滑,正确设置偏移修正值,并正确调整容器偏移.
        // ???: 猜测: 偶尔的闪图bug,可能就出现在没处理好 0.5 的误差上.尝试处理下.
        CGFloat  adjustValue = self.viewContainer.frame.size.width; // 向左移.
        if (YES != direction) { // 向右移.
            adjustValue = - adjustValue;
        }
        
        offsetOriginal.x = adjustValue + offsetOriginal.x;
        self.viewContainer.contentOffset = offsetOriginal;
        
        return;
    }
    
    /* 说明是初始化视图容器. */
    // ???:可不可以使其更小些.
    // ???:0.5的声明应该前置,否则 当显示第二个视图时,无法精确修正偏移值.!
    // ???:迭代至此!
    NSNumber * withOfContent = [NSNumber numberWithDouble: self.frame.size.width + 0.25];
    
    UIView * cell = [self.dataSource rotateView: self cellForColAtIndex: index];
    cell.backgroundColor = [UIColor cyanColor];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    [self.viewContainer addSubview: cell];
    
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"H:|[cell(==withOfContent)]|" options:0 metrics:NSDictionaryOfVariableBindings(withOfContent) views: NSDictionaryOfVariableBindings(cell)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[cell(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(cell)]];
    
    [self.viewContainer addConstraints:constraintsArray];
    
    [self.visibleViews setObject: cell forKey: [NSString stringWithFormat: @"%lu", index]];
}

# pragma mark - 协议方法
- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    [self showCellAtIndex:1];
    // ???: 此处缺少一个逻辑: 计算需要显示哪个位置的图片,显示即可.
    
    // ???: 需要向上或向下取整.
    
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
