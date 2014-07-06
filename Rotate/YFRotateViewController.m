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
        
        // 不让控制器自动调整UIScrollview位置.
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)loadView
{
    YFRotateView * rotateView = [[YFRotateView alloc] init];
    rotateView.delegate = self;
    rotateView.dataSource = self;
    
    self.view = rotateView;
    YFRelease(rotateView);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"影子新闻";
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"目录" style:UIBarButtonItemStylePlain target: nil action: NULL];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    YFRelease(leftButtonItem);
    
    UIBarButtonItem * rightButtonItem = self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"登录" style:UIBarButtonItemStylePlain target:nil action: NULL];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    YFRelease(rightButtonItem);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && nil == self.view.window) {
        self.view = nil;
    }
    
}

// !!!:测试bug专用!
//- (void)viewDidAppear:(BOOL)animated
//{
//    UIScrollView * scrollView = [[self.view YFRVHeaderView] YFRHScrollView];
//    CGRect frameOfScrollView = scrollView.frame;
//    CGRect boundsOfScrollView = scrollView.bounds;
//    CGPoint offsetOfScrollView = scrollView.contentOffset;
//    CGSize sizeOfScrollView= scrollView.contentSize;
//    
//    
//    UIScrollView * segmentedControl = [[self.view YFRVHeaderView] YFRHSegmentedControl];
//    CGRect frameOfSegmentedControl = segmentedControl.frame;
//    CGRect boundsOfSegmentedControl = segmentedControl.bounds;
//}

#pragma mark - YFRotateViewDataSource 协议方法
- (NSInteger)numberOfCellsInRotateView:(YFRotateView *)rotateView
{
    return 10;
}

- (UIView *)rotateView:(YFRotateView *)rotateView cellForColAtIndex:(NSUInteger) index
{
    NSString * imageName = [NSString stringWithFormat:@"00%@.jpg", [NSNumber numberWithUnsignedInteger:index+1]];

    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed: imageName]];
    view.backgroundColor = [UIColor blackColor];
    YFAutorelease(view);
    return view;
}

- (NSUInteger) indexForSetupCellInRotateView:(YFRotateView *) rotateView
{
    return 1;
}

- (NSString *)rotateView: (YFRotateView *) rotateView titleForCellAtIndex:(NSUInteger) index
{
    return @"颜风的歌";
}
#pragma mark - YFRotateViewDelegate 协议方法.
- (CGFloat)heightForHeaderInRotateView:(YFRotateView *)rotateView
{
    return 30.0;
}

@end
