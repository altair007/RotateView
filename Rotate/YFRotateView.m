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
    
        
//        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.05)];
//        headerView.backgroundColor = [UIColor blackColor];
//        self.headerView = headerView;
//        Release(headerView);
//        [self addSubview: self.headerView];
//        
//        
//        UIScrollView * viewContainer = [[UIScrollView alloc] initWithFrame: CGRectMake(0, self.headerView.frame.size.height, self.frame.size.width, self.frame.size.height - self.headerView.frame.size.height-64)];
//        viewContainer.contentSize =  CGSizeMake(2 * self.frame.size.width, 0);
//        viewContainer.backgroundColor = [UIColor greenColor];
//        viewContainer.pagingEnabled = YES;
////        [viewContainer addConstraint:<#(NSLayoutConstraint *)#>];
//        self.viewContainer = viewContainer;
//        Release(viewContainer);
//        [self addSubview: self.viewContainer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSUInteger) numberOfVisibleView
{
    return _YFRVVisibleViews.count;
}

//- (void)setDataSource:(id<YFRotateViewDataSource>)dataSource
//{
//    
//}

- (void) setupSubviews;
{
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: headerView];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;

    
    UIScrollView * viewContainer = [[UIScrollView alloc]init];
    viewContainer.contentSize = CGSizeMake(2 * self.frame.size.width, 0);
    
    // ???:最后设置可以吗?
    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;

    // !!!:临时添加的背景色.
    viewContainer.backgroundColor = [UIColor greenColor];
    viewContainer.pagingEnabled = YES;
    [self addSubview: viewContainer];
    
    // ???: 迭代至此!  不是 必须的吗? NO,YES? 和导航栏有关吗?
//    [viewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /* 使用"约束"进行界面布局. */
    
    // ???: 如何动态获取导航栏高度?
    // ???: 如何根据不同ios版本动态获取导航栏高度?
    NSNumber *  navHeight = [NSNumber numberWithFloat: 64.0]; //!< 导航栏高度.
    NSNumber * headerHeight = [NSNumber numberWithFloat: 20.0]; //!< 标题栏高度.
    
    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
    // ???:可以将多个"约束" 写到一块吗?
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[headerView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(headerView)]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewContainer]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(viewContainer)]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-navHeight-[headerView(==headerHeight)][viewContainer]|" options:0 metrics: NSDictionaryOfVariableBindings(navHeight, headerHeight) views: NSDictionaryOfVariableBindings(headerView,viewContainer)]];
    
    [self addConstraints: constraintsArray];
    
    self.headerView = headerView;
    Release(headerView);
    self.viewContainer = viewContainer;
    Release(viewContainer);
}

# pragma mark - 协议方法
- (void)scrollViewDidScroll:(UIScrollView *) scrollView
{
    CGFloat width = scrollView.frame.size.width; // 相册宽度.
    CGFloat x = scrollView.contentOffset.x; // 相册偏移.
    
    /* 计算相册上应该出现几张图片. */
    NSInteger countShould = 1;
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
