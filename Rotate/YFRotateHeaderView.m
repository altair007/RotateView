//
//  YFRotateHeaderView.m
//  Rotate
//
//  Created by 颜风 on 14-7-4.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFRotateHeaderView.h"

@interface YFRotateHeaderView ()
@property (retain, nonatomic) UIScrollView * YFRHScrollView;
@property (retain, nonatomic) UISegmentedControl * YFRHSegmentedControl;
@end
@implementation YFRotateHeaderView

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    
    self.YFRHScrollView = nil;
    self.YFRHSegmentedControl = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (nil == self.window) {
        [self YFRHSetupSubviews];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //!!!: 支持自定义页眉单元格宽度. 好像有潜在BUG.
    for (NSUInteger index = 0; index < self.YFRHSegmentedControl.numberOfSegments; index++) {
        [self.YFRHSegmentedControl setWidth:[self YFRHWidthOfCellAtIndex: index] forSegmentAtIndex: index];
    }
}

#pragma mark - 私有方法.
/**
 * 初始化子视图.
 */
- (void) YFRHSetupSubviews
{
    //!!!: 临时加个空视图,修复BUG.
//    UIView * emptyView = [[UIView alloc] init];
//    emptyView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview: emptyView];
    self.backgroundColor = [UIColor blueColor];
    
    
    
    /* 创建视图. */
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor blueColor];
    scrollView.delegate = self;
    
    self.YFRHScrollView = scrollView;
    YFRelease(scrollView);
//    [self addSubview: self.YFRHScrollView];
//    [self sendSubviewToBack: self.YFRHScrollView];
    
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:[self.dataSource titlesForShowInRotateHeaderView: self]];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
//    //!!!:根本无效! 支持自定义页眉单元格高度.
//    for (NSUInteger index = 0; index < self.YFRHSegmentedControl.numberOfSegments; index++) {
//        [self.YFRHSegmentedControl setWidth:30 forSegmentAtIndex: index];
//    }
//
    self.YFRHSegmentedControl = segmentedControl;
    YFRelease(segmentedControl);
//    [self.YFRHScrollView addSubview: self.YFRHSegmentedControl];
    
    // 临时测试.
    [self addSubview: self.YFRHSegmentedControl];
    
    /*设置视图约束*/
    NSNumber * heightOfView = [NSNumber numberWithDouble: [self.delegate hightForRotateHeaderView: self]]; //视图高度.
    
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[scrollView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scrollView)]];
    
    // !!!: 临时测试.
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[emptyView][scrollView]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfView) views: NSDictionaryOfVariableBindings(scrollView, emptyView)]];
    
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[scrollView]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfView) views: NSDictionaryOfVariableBindings(scrollView)]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    // !!!:临时测试.
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[segmentedControl]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfView) views: NSDictionaryOfVariableBindings(segmentedControl)]];

    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[segmentedControl]|" options:0 metrics:NSDictionaryOfVariableBindings(heightOfView) views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [self addConstraints: constraints];
}

// ???:如果考虑到下拉按钮的话,这个值是不适宜的.
/**
 *  单个单元格宽度.默认为屏幕宽度的1/5.可通过代理设置.
 *
 *  @return 单个单元格宽度.
 */
- (CGFloat) YFRHWidthOfCellAtIndex: (NSUInteger) index
{
    CGFloat width = self.frame.size.width / 5;
    if ([self.delegate respondsToSelector: @selector(rotateHeaderView:widthForCellAtIndex:)]) {
        width = [self.delegate rotateHeaderView: self widthForCellAtIndex: index];
    }
    
    return width;
}

#pragma mark - UIScrollViewDelegate协议方法.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}
@end
