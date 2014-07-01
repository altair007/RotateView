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
    YFRotateView * rotateView = [[YFRotateView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    CGRect bounds = rotateView.bounds;
    bounds.origin.y -= 64;
    rotateView.bounds = bounds;
    
    rotateView.delegate = self;

    
    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"001.jpg"]];
    view.frame = CGRectMake(0, 0, 320, (568-64)*0.95);
    view.backgroundColor = [UIColor blueColor];
    [rotateView.viewContainer addSubview: view];
    
    self.view = rotateView;
    Release(rotateView);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - YFRotateViewDataSource 协议方法
- (NSInteger)numberOfCellsInRotateView:(YFRotateView *)rotateView
{
    return 2;
}

/**
 *  设置用于某个位置的单元格的视图.
 *
 *  @param rotateView 轮转视图对象.
 *  @param index      单元格位置.
 *
 *  @return 用于某个位置的单元格的视图.
 */
- (UIView *)rotateView:(YFRotateView *)rotateView cellForColAtIndex:(NSUInteger) index
{
    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"001.jpg"]];
    view.frame = CGRectMake(0, 0, 320, (568-64)*0.95);
    view.backgroundColor = [UIColor blueColor];
    
    return view;
}
@end
