//
//  YFRotateViewController.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFRotateViewController.h"
#import "YFRotateView.h"

@interface YFRotateViewController ()

@end

@implementation YFRotateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    YFRotateView * rotateView = [[YFRotateView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    rotateView.delegate = self;
    
    UIImageView * leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"001.jpg"]];
    leftView.backgroundColor = [UIColor greenColor];
    rotateView.initView = leftView;
    Release(leftView);

    self.view = rotateView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIScrollViewAccessibilityDelegate协议方法
// ???: 这个协议方法怎么不执行?
- (NSString *)accessibilityScrollStatusForScrollView:(UIScrollView *)scrollView
{

    return @"0.0";
}

// !!!: 这些逻辑应该单独封装到视图里.
// !!!: 一个可能的思路: 检测轻扫手势,拜托对代理的依赖.同一个手势,可以有多个事件响应吗?或者显示先执行父类的的手势方法即可.?
- (void)scrollViewDidScroll:(YFRotateView *) rotateView
{
    CGFloat width = rotateView.frame.size.width; // 相册宽度.
    CGFloat x = rotateView.contentOffset.x; // 相册偏移.
    
    /* 计算相册上应该出现几张图片. */
    NSInteger countShould = 1;
    if (0 != x && width != x) {
        countShould = 2;
    }
    
    /* 屏幕上此时已经出现了几张图片. */
    NSUInteger countVisible = [rotateView numberOfVisibleView];
    
    if (countShould == countVisible) { // 刚刚好.
        return;
    }
    
    if(countShould > countVisible){ // 需要增加显示另一个视图.
    
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollVie
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    
}
@end
