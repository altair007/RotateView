//
//  YFAppDelegate.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFAppDelegate.h"
#import "YFRotateViewController.h"

@implementation YFAppDelegate
- (void)dealloc
{
    self.window = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow * window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    Release(window);
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    YFRotateViewController * roteteViewController = [[YFRotateViewController alloc] init];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: roteteViewController];
    
    
    self.window.rootViewController = navController;
//    // 测试:
//    UIView * view = [[UIView alloc] init];
////    view.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    UIView * headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor blackColor];
////    headerView.translatesAutoresizingMaskIntoConstraints = NO;
//    [view addSubview: headerView];
////    headerView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    
//    UIScrollView * viewContainer = [[UIScrollView alloc]init];
//    
//    // !!!:设置过早!
////    viewContainer.contentSize = CGSizeMake(2 * view.frame.size.width, 0);
//    
//    // ???:最后设置可以吗?
////    viewContainer.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    
//    // !!!:临时添加的背景色.
//    viewContainer.backgroundColor = [UIColor greenColor];
//    viewContainer.pagingEnabled = YES;
//    [view addSubview: viewContainer];
//    
//    
//    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    [viewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    
//    /* 使用"约束"进行界面布局. */
//    
//    // ???: 如何动态获取导航栏高度?
//    // ???: 如何根据不同ios版本动态获取导航栏高度?
//    NSNumber *  navHeight = [NSNumber numberWithFloat: 64.0]; //!< 导航栏高度.
//    NSNumber * headerHeight = [NSNumber numberWithFloat: 20.0]; //!< 标题栏高度.
//    
//    NSMutableArray * constraintsArray = [NSMutableArray arrayWithCapacity: 42];
//    // ???:可以将多个"约束" 写到一块吗?
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[headerView]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(headerView)]];
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"|[viewContainer]|" options:0 metrics:nil views: NSDictionaryOfVariableBindings(viewContainer)]];
//    
//    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|-navHeight-[headerView(==headerHeight)][viewContainer]|" options:0 metrics: NSDictionaryOfVariableBindings(navHeight, headerHeight) views: NSDictionaryOfVariableBindings(headerView,viewContainer)]];
//    
//    [view addConstraints: constraintsArray];
//    
////    self.headerView = headerView;
//    Release(headerView);
////    self.viewContainer = viewContainer;
//    Release(viewContainer);
//    NSArray * array = view.subviews;
//    
//    view.frame = CGRectMake(0, 0, 320, 568);
//    view.backgroundColor = [UIColor redColor];
//    [self.window addSubview:view];
//    
    
    
//    self.window.rootViewController = navController;
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
