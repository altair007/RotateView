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
    YFRotateView * rotateView = [[YFRotateView alloc] init];
    rotateView.delegate = self;
    rotateView.dataSource = self;
    
    self.view = rotateView;
    YFRVRelease(rotateView);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"魅影传媒";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"目录" style:UIBarButtonItemStylePlain target: nil action: NULL];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"登录" style:UIBarButtonItemStylePlain target:nil action: NULL];
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
    CGFloat x =  self.view.YFRVViewContainer.contentOffset.x;
}

#pragma mark - YFRotateViewDataSource 协议方法
- (NSInteger)numberOfCellsInRotateView:(YFRotateView *)rotateView
{
    return 2;
}

- (UIView *)rotateView:(YFRotateView *)rotateView cellForColAtIndex:(NSUInteger) index
{
    if (0 == index) {
        UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"001.jpg"]];
        view.frame = CGRectMake(0, 0, 320, 568);
        view.backgroundColor = [UIColor blueColor];
        
        return view;
    }

    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"002.jpg"]];
    view.frame = CGRectMake(0, 0, 320, 568);
    view.backgroundColor = [UIColor blueColor];
    
    return view;
}

- (NSUInteger) indexForSetupCellInRotateView:(YFRotateView *) rotateView
{
    return 0;
}

#pragma mark - YFRotateViewDelegate 协议方法.
- (CGFloat)heightForHeaderInRotateView:(YFRotateView *)rotateView
{
    return 30.0;
}

@end
