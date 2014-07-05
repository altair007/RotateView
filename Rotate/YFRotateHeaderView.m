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
    
    CGRect rect =  self.YFRHScrollView.bounds;
    rect.origin.y = 0;
    self.YFRHScrollView.bounds = rect;
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
    
    // ???:此处设置,真的有效吗?
//    scrollView.contentSize = CGSizeMake([self.dataSource numberOfCellsInRotateHeaderView: self] * [self YFRHWidthOfCell], 0);
    
    // !!!:临时加的背景色.
    scrollView.backgroundColor = [UIColor blackColor];
    
    self.YFRHScrollView = scrollView;
    YFRelease(scrollView);
    [self addSubview: self.YFRHScrollView];
    
    
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:[self.dataSource titlesForShowInRotateHeaderView: self]];
    
    // !!!: 临时测试.
    // !!!:迭代至此!可能需要用layer来控制布局.
    // !!!:建议:先逻辑和整体布局,后样式.
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.alpha = 0.5;
    // !!!:临时加的背景色.
//    segmentedControl.backgroundColor = [UIColor blueColor];
    
    self.YFRHSegmentedControl = segmentedControl;
    YFRelease(segmentedControl);
    [self.YFRHScrollView addSubview: self.YFRHSegmentedControl];
    
    /*设置视图约束*/
    NSMutableArray * constraints = [NSMutableArray arrayWithCapacity: 42];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[scrollView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scrollView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[scrollView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(scrollView)]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[segmentedControl]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(segmentedControl)]];
    
    [self addConstraints: constraints];
}

// ???:如果考虑到下拉按钮的话,这个值是不适宜的.
/**
 *  单个单元格宽度.默认为屏幕宽度的1/5.可通过代理设置.
 *
 *  @return 单个单元格宽度.
 */
- (CGFloat) YFRHWidthOfCell
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 5;
    if ([self.delegate respondsToSelector: @selector(heightForCellInRotateHeaderView:)]) {
        width = [self.delegate heightForCellInRotateHeaderView: self];
    }
    
    return width;
}
@end
