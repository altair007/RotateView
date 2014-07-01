//
//  YFRotateView.m
//  Rotate
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFRotateView.h"

@interface YFRotateView ()
@property (retain, nonatomic, readwrite) NSMutableArray * YFRVVisibleViews; //!< 存储相册上可以看到的视图.
@end

@implementation YFRotateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentSize =  CGSizeMake(2 * self.frame.size.width, 0);
        self.backgroundColor = [UIColor redColor];
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(0, 0);
//        self.bounces = NO;
        
        
//        UIImageView * leftView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        leftView.backgroundColor = [UIColor greenColor];
//        leftView.image = [UIImage imageNamed: @"001.jpg"];
//        [self addSubview: leftView];
//        Release(leftView);
//        
//        UIImageView * rightView = [[UIImageView alloc] initWithFrame: CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
//        rightView.image = [UIImage imageNamed: @"002.jpg"];
//        rightView.backgroundColor = [UIColor blueColor];
//        [self addSubview: rightView];
//        Release(rightView);
        
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

- (void)setInitView:(UIView *)initView
{
    [initView retain];
    [_initView release];
    _initView = initView;
    
    self.initView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview: initView];
    [self.YFRVVisibleViews addObject: self.initView];
}
@end
