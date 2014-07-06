//
//  YFRotateView.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

/**
 *  视图容器的内容插入类型.
 */
typedef enum{
    YFRVViewContanierContentInsertTypeNone, //!< 没有往视图容器插入容器.
    YFRVViewContanierContentInsertTypeHead, //!< 从位置0往视图容器插入数据.
    YFRVViewContanierContentInsertTypeTail, //!< 从最后位置往视图容器插入数据.
    YFRVViewContanierContentInsertTypeMiddle //!< 从中间位置往视图容器插入数据.
}YFRVViewContanierContentInsertType;

#import "YFRotateView.h"

@interface YFRotateView ()
#pragma mark - 私有属性.

// ???: 建议把视图容器封装成一个单独的类.
@property (retain, nonatomic) UIScrollView * YFRVViewContainer; //!< 用于放置视图.
@property (retain, nonatomic) YFRotateHeaderView * YFRVHeaderView; //!< 页眉用于导航.
@property (assign, nonatomic) NSUInteger  YFRVIndexOfCurrentPage; //!< 当前页面的位置.
@property (assign, nonatomic) YFRVViewContanierContentInsertType YFRVInsertType; //!< 用于实时记录往容器视图插入视图的方式.
@end

@implementation YFRotateView
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    
    self.YFRVViewContainer = nil;
    self.YFRVHeaderView = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.YFRVIndexOfCurrentPage = NSUIntegerMax;
        self.YFRVInsertType = UIDataDetectorTypeNone;
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (nil == self.window) {
        [self YFRVSetupSubviews];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /* 正确布局视图容器上视图的相对位置. */
    CGRect bouds = self.YFRVViewContainer.bounds;
    if (YFRVViewContanierContentInsertTypeMiddle == self.YFRVInsertType ||
        YFRVViewContanierContentInsertTypeTail == self.YFRVInsertType) {
        bouds.origin.x = self.frame.size.width;
    }
    self.YFRVViewContainer.bounds = bouds;
    
}


#pragma mark - 私有方法
/**
 *  初始化子视图.
 */
- (void) YFRVSetupSubviews;
{
    /* 使用"约束"进行界面布局. */
    NSNumber *  navHeight = self.YFRVheightOfNavigation; //!< 导航栏高度.
    NSNumber * headerHeight = self.YFRVheightOfHeaderView; //!< 页眉高度.
    
    /* 设置页眉. */
    YFRotateHeaderView * headerView = [[YFRotateHeaderView alloc] init];
    headerView.dataSource = self;
    headerView.delegate = self;
    [headerView setTranslatesAutoresizingMaskIntoConstraints: ! [[headerView class] requiresConstraintBasedLayout]];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.YFRVHeaderView = headerView;
    [self addSubview: self.YFRVHeaderView];
    YFRelease(headerView);
    
    // 设置视图容器.
    UIScrollView * viewContainer = [[UIScrollView alloc]init];
    viewContainer.showsVerticalScrollIndicator = NO;
    viewContainer.showsHorizontalScrollIndicator = NO;
    viewContainer.pagingEnabled = YES;
    viewContainer.bounces = NO;
    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    viewContainer.delegate = self;
    
    self.YFRVViewContainer = viewContainer;
    YFRelease(viewContainer);
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

/**
 *  获取页眉高度.
 *
 *  @return 页眉高度.
 */
- (NSNumber *)YFRVheightOfHeaderView
{
    CGFloat height = 30.0; // 默认30.0.
    if (YES == [self.delegate respondsToSelector: @selector(heightForHeaderInRotateView:)]) { // 优先使用代理设置的页眉高度.
        height = [self.delegate heightForHeaderInRotateView: self];
    }
    
    NSNumber * heightValue = [NSNumber numberWithDouble: height];
    return heightValue;
}

/**
 *  获取导航栏高度.
 *
 *  @return 导航栏高度.
 */
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
    
    if (NSUIntegerMax == self.YFRVIndexOfCurrentPage) {
        return;
    }
    
    self.YFRVHeaderView.selectedIndex = YFRVIndexOfCurrentPage;
}

/**
 *  显示第几个位置的视图.
 *
 *  @param index 要显示的视图的位置.
 */
- (void) YFRVShowCellAtIndex: (NSUInteger) index
{
    // 更新当前视图.
    self.YFRVIndexOfCurrentPage = index;
    
    // 移除已有的子视图及其"约束",避免冲突.
    [self.YFRVViewContainer removeConstraints: self.YFRVViewContainer.constraints];
    [self.YFRVViewContainer.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    /* 设置新的约束. */
    NSNumber * widthOfViewContainer = [NSNumber numberWithDouble: self.frame.size.width];
    NSNumber * heightOfViewContainer = [NSNumber numberWithDouble: self.frame.size.height - [self.YFRVheightOfHeaderView doubleValue] - [self.YFRVheightOfNavigation doubleValue]];
    
    // 用于存储新的约束.
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    
    /* 考虑一种特殊情况:整个轮转视图,只有一个页面.*/
    if (1 == [self.dataSource numberOfCellsInRotateView: self]) {
        self.YFRVInsertType = YFRVViewContanierContentInsertTypeHead;
        
        // 获取视图.
        UIView * view = [self.dataSource rotateView: self cellForColAtIndex: 0];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.YFRVViewContainer addSubview: view];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[view(==widthOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(view)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[view(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(view)]];
        
        [self.YFRVViewContainer addConstraints: constraints];
        return;
    }
    
    /* 考虑位置为0的情况,此时仅需要设置位置0和1的视图. */
    if (0 == index) {
        self.YFRVInsertType = YFRVViewContanierContentInsertTypeHead;
        
        // 优先从已经存储的视图中获取.
        UIView * viewZero = [self.dataSource rotateView:self cellForColAtIndex:0];
        viewZero.translatesAutoresizingMaskIntoConstraints = NO;
        [self.YFRVViewContainer addSubview: viewZero];
        
        UIView * viewOne = [self.dataSource rotateView:self cellForColAtIndex:1];
        viewOne.translatesAutoresizingMaskIntoConstraints = NO;
        [self.YFRVViewContainer addSubview: viewOne];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewZero(==widthOfViewContainer)][viewOne(==viewZero)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(viewZero, viewOne)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewZero(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewZero)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewOne(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewOne)]];
        
        [self.YFRVViewContainer addConstraints: constraints];
        return;
    }
    
    /* 考虑视图为最后一个视图的情况:此时仅需要设置最后两张图片. */
    if (index == [self.dataSource numberOfCellsInRotateView: self] - 1) {
        self.YFRVInsertType = YFRVViewContanierContentInsertTypeTail;
        
        // 优先从已经存储的视图中获取视图.
        UIView * viewTrail = [self.dataSource rotateView: self cellForColAtIndex: index];
        viewTrail.translatesAutoresizingMaskIntoConstraints = NO;
        [self.YFRVViewContainer addSubview: viewTrail];
        
        UIView * viewLast = [self.dataSource rotateView: self cellForColAtIndex: index - 1];
        viewLast.translatesAutoresizingMaskIntoConstraints = NO;
        [self.YFRVViewContainer addSubview: viewLast];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewLast(==widthOfViewContainer)][viewTrail(==viewLast)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(viewLast, viewTrail)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewLast(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewLast)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewTrail(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewTrail)]];
        
        [self.YFRVViewContainer addConstraints: constraints];
        [self.YFRVViewContainer setNeedsUpdateConstraints];
        return;
    }
    
    
    /* 下面就是最平常的情况:需要设置自己及其左右邻近位置的视图. */
    
    self.YFRVInsertType = YFRVViewContanierContentInsertTypeMiddle;
    
    // 依然优先从已经存储的视图中获取视图.
    UIView * viewLeft = [self.dataSource rotateView: self cellForColAtIndex: index -1];
    viewLeft.translatesAutoresizingMaskIntoConstraints = NO;
    [self.YFRVViewContainer addSubview: viewLeft];
    
    UIView * viewMiddle = [self.dataSource rotateView: self cellForColAtIndex: index];
    viewMiddle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.YFRVViewContainer addSubview: viewMiddle];
    
    UIView * viewRight = [self.dataSource rotateView: self cellForColAtIndex: index + 1];
    viewRight.translatesAutoresizingMaskIntoConstraints = NO;
    [self.YFRVViewContainer addSubview: viewRight];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewLeft(==viewRight)][viewMiddle(==viewRight)][viewRight(==widthOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(widthOfViewContainer) views: NSDictionaryOfVariableBindings(viewLeft, viewMiddle, viewRight)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewLeft(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewLeft)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewMiddle(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewMiddle)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[viewRight(==heightOfViewContainer)]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfViewContainer) views: NSDictionaryOfVariableBindings(viewRight)]];
    
    [self.YFRVViewContainer addConstraints: constraints];
}

# pragma mark - 协议方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /* 更新视图 */
    if (YFRVViewContanierContentInsertTypeHead == self.YFRVInsertType &&
        self.frame.size.width == scrollView.contentOffset.x) {
        [self YFRVShowCellAtIndex: self.YFRVIndexOfCurrentPage + 1];
        return;
    }
    
    if (YFRVViewContanierContentInsertTypeTail == self.YFRVInsertType &&
        0 == scrollView.contentOffset.x) {
        [self YFRVShowCellAtIndex: self.YFRVIndexOfCurrentPage - 1];
        return;
    }
    
    if (YFRVViewContanierContentInsertTypeMiddle == self.YFRVInsertType) {
        if (0 == scrollView.contentOffset.x) {
            [self YFRVShowCellAtIndex: self.YFRVIndexOfCurrentPage - 1];
        }
        if (2 * self.frame.size.width == scrollView.contentOffset.x) {
            [self YFRVShowCellAtIndex: self.YFRVIndexOfCurrentPage + 1];
        }
    }
}

#pragma mark - YFRotateHeaderViewDataSource协议方法.
- (NSArray *) titlesForShowInRotateHeaderView: (YFRotateHeaderView *) rotateHeaderView
{
    return @[@"头条", @"聚合阅读", @"轻松一刻", @"本地", @"科技",@"头条", @"聚合阅读", @"轻松一刻", @"本地", @"科技"];
}
@end
