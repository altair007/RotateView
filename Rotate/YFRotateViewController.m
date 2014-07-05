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
    // ???: 有一个BGU!  上面会出现竖线.奇怪的竖线.
    YFRotateView * rotateView = [[YFRotateView alloc] init];
    rotateView.delegate = self;
    rotateView.dataSource = self;
//    rotateView.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.navigationItem.titleView.backgroundColor = [UIColor redColor];
    
    self.view = rotateView;
    YFRelease(rotateView);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"魅影传媒";
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

- (void)viewDidAppear:(BOOL)animated
{
    UIView * view = [[self.view YFRVHeaderView] YFRHScrollView];
    CGSize size = [view contentSize];
    CGRect bouds = (CGRect)view.bounds;
    CGRect visilbe = view.layer.visibleRect;
//    UIView * superView = view.superview;
//    CGSize size2 = [view contentSize];
//    CGRect bouds2 = (CGRect)view.bounds;
//    CGRect visilbe2 = view.layer.visibleRect;
}

#pragma mark - YFRotateViewDataSource 协议方法
- (NSInteger)numberOfCellsInRotateView:(YFRotateView *)rotateView
{
    return 10;
}

- (UIView *)rotateView:(YFRotateView *)rotateView cellForColAtIndex:(NSUInteger) index
{
    NSString * imageName = [NSString stringWithFormat:@"00%@.jpg", [NSNumber numberWithUnsignedInteger:index+1]];

    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed: imageName]];
    view.backgroundColor = [UIColor blueColor];
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
