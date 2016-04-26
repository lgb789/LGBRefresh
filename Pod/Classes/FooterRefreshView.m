//
//  FooterRefreshView.m
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/8.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import "FooterRefreshView.h"

static NSString * const kLastUpdateTimeKey = @"kLastUpdateTimeKey";

@interface FooterRefreshView ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation FooterRefreshView

#pragma mark - *********************** public methods ***********************

#pragma mark - *********************** overwrite methods ***********************
-(instancetype)initWithDateKey:(NSString *)dateKey
{
    self = [super init];
    if (self) {
        self.dateKey = dateKey;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateKey = kLastUpdateTimeKey;
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.indicatorView];
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
    self.subTitleLabel.text = [NSString stringWithFormat:@"上次更新:  %@", [self lastUpdateTime]];
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
    [self saveCurrentTime];
}

#pragma mark - *********************** event response ***********************

#pragma mark - *********************** private methods ***********************
-(NSString *)lastUpdateTime
{
    
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
    if (lastDate == nil) {
        return @"无纪录";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *lastComponents = [calendar components:unit fromDate:lastDate];
    NSDateComponents *currentComponents = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (lastComponents.year == currentComponents.year && lastComponents.month == currentComponents.month && lastComponents.day == currentComponents.day) {
        formatter.dateFormat = @"今天  HH:mm";
    }else if (lastComponents.year == currentComponents.year){
        formatter.dateFormat = @"MM月dd日 HH:mm";
    }else {
        formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    }
    
    return [formatter stringFromDate:lastDate];
}

-(void)saveCurrentTime
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.dateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - *********************** getters and setters ***********************
-(UIImageView *)imgView
{
    if (_imgView == nil) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"LGBRefresh" ofType:@"bundle"];
        NSString *imageName = [path stringByAppendingPathComponent:@"arrow.png"];
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
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
