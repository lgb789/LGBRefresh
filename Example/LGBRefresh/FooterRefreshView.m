//
//  FooterRefreshView.m
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/8.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import "FooterRefreshView.h"

@interface FooterRefreshView ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation FooterRefreshView

#pragma mark - *********************** public methods ***********************

#pragma mark - *********************** overwrite methods ***********************
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.indicatorView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(0, 0, 15, 40);
    self.imgView.center = CGPointMake(CGRectGetMidX(self.bounds) * 0.5, CGRectGetMidY(self.bounds));
    self.indicatorView.center = self.imgView.center;
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMidY(self.bounds));
    self.subTitleLabel.frame = CGRectMake(0, CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - *********************** delegate ***********************

-(CGFloat)refreshViewHeight
{
    return 60.0;
}

-(void)refreshViewNormal
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imgView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        
        
    }];
    self.imgView.alpha = 1;
    self.indicatorView.alpha = 0;
    [self.indicatorView stopAnimating];
    self.titleLabel.text = @"上拉可以刷新";
    self.subTitleLabel.text = @"最后更新:今天 11:11";
}

-(void)refreshViewWillRefresh
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.imgView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    self.titleLabel.text = @"松开立即刷新";
}

-(void)refreshViewRefreshing
{
    [self.indicatorView startAnimating];
    self.imgView.alpha = 0;
    self.indicatorView.alpha = 1;
    self.titleLabel.text = @"正在刷新数据....";
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)refreshViewContentOffset:(CGFloat)offset directionUp:(BOOL)up
{
    
}

#pragma mark - *********************** event response ***********************

#pragma mark - *********************** private methods ***********************

#pragma mark - *********************** getters and setters ***********************
-(UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    }
    return _imgView;
}

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel
{
    if (_subTitleLabel == nil) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _subTitleLabel;
}

-(UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

@end
