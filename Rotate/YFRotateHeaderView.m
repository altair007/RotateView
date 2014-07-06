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
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

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
    
    /* 支持自定义页眉单元格宽度 */
    for (NSUInteger index = 0; index < self.YFRHSegmentedControl.numberOfSegments; index++) {
        [self.YFRHSegmentedControl setWidth:[self YFRHWidthOfCellAtIndex: index] forSegmentAtIndex: index];
    }
}

// ???:被选中的键,应该自动居中.
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    self.YFRHSegmentedControl.selectedSegmentIndex = selectedIndex;
    
    if ([self.delegate respondsToSelector:@selector(rotateHeaderView:actionForCellAtIndex:)]) {
        [self.delegate rotateHeaderView:self actionForCellAtIndex: selectedIndex];
    }
}

#pragma mark - 私有方法.
/**
 * 初始化子视图.
 */
- (void) YFRHSetupSubviews
{
    /* 创建视图. */
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    
    self.YFRHScrollView = scrollView;
    YFRelease(scrollView);
    [self addSubview: self.YFRHScrollView];
    
    
    // ???:如何去调 segmentedControl的边框,好难看! UISegmentedControlStyle 可能和这个有关.
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:[self.dataSource titlesForShowInRotateHeaderView: self]];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.YFRHSegmentedControl = segmentedControl;
    YFRelease(segmentedControl);
    [self.YFRHScrollView addSubview: self.YFRHSegmentedControl];
    
    /*设置视图约束*/
    
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[scrollView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scrollView)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[scrollView]|" options:0 metrics: nil views: NSDictionaryOfVariableBindings(scrollView)]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [self addConstraints: constraints];
}

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
