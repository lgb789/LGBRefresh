//
//  InfiniteRefreshView.m
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/11.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import "InfiniteRefreshView.h"

@interface InfiniteRefreshView ()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation InfiniteRefreshView

#pragma mark - *********************** public methods ***********************

#pragma mark - *********************** overwrite methods ***********************
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.indicatorView];
        [self addSubview:self.titleLabel];
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds) * 0.5, CGRectGetMidY(self.bounds));
}

#pragma mark - *********************** delegate ***********************
-(CGFloat)refreshViewHeight
{
    return 44;
}

#pragma mark - *********************** event response ***********************

#pragma mark - *********************** private methods ***********************

#pragma mark - *********************** getters and setters ***********************
-(UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"正在加载数据....";
    }
    return _titleLabel;
}

@end
