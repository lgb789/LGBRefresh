//
//  LGBRefreshView.m
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/6.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import "LGBRefreshManager.h"

static NSString * const kContentOffsetKey = @"contentOffset";
static NSString * const kContentSizeKey   = @"contentSize";

static const CGFloat kPullOffset = 10;

typedef enum : NSUInteger {
    LGBRefreshViewStateUnknown = -1,
    LGBRefreshViewStateNormal = 0,
    LGBRefreshViewStateWillRefresh,
    LGBRefreshViewStateRefreshing,
    
} LGBRefreshViewState;

@interface LGBRefreshManager ()
@property (nonatomic, assign) CGFloat originOffsetY;
@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, assign) LGBRefreshViewState refreshState;
@property (nonatomic, assign) UIEdgeInsets originInsets;

@property (nonatomic, assign) CGFloat lastOffset;
@property (nonatomic, assign) BOOL directionUp;

@property (nonatomic, assign) BOOL startTopRefreshFlag;

@end

@implementation LGBRefreshManager

#pragma mark - *********************** public methods ***********************

-(void)endTopRefresh
{
    [self resetScrollInsetsForPosition:RefreshPositionTop];
}

-(void)endBottomRefresh
{
    [self resetScrollInsetsForPosition:RefreshPositionBottom];
}

-(void)endInfiniteRefresh
{
    self.refreshState = LGBRefreshViewStateNormal;
}

-(void)startTopRefresh
{
    self.startTopRefreshFlag = YES;
}

#pragma mark - *********************** overwrite methods ***********************

-(void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.firstLoad) {
        self.firstLoad = YES;
        
        [self.scrollView bringSubviewToFront:self];
        
        self.originOffsetY = self.scrollView.contentOffset.y;
        self.originInsets = self.scrollView.contentInset;
        
        self.refreshState = LGBRefreshViewStateNormal;
        
        if (self.position == RefreshPositionInfinite) {
            self.scrollView.contentInset = UIEdgeInsetsMake(self.originInsets.top, self.originInsets.left, self.originInsets.bottom + [self.delegate refreshViewHeight], self.originInsets.right);
        }
        
        if (self.startTopRefreshFlag) {
            self.startTopRefreshFlag = NO;
            self.refreshState = LGBRefreshViewStateWillRefresh;
            [self.scrollView setContentOffset:CGPointMake(0, -[self.delegate refreshViewHeight] * 2)];
        }
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (self.superview == nil && newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        [newSuperview addObserver:self forKeyPath:kContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:kContentSizeKey options:NSKeyValueObservingOptionNew context:nil];
        
    }

    if (self.superview && newSuperview == nil) {
        [self.superview removeObserver:self forKeyPath:kContentOffsetKey];
        [self.superview removeObserver:self forKeyPath:kContentSizeKey];
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.refreshState = LGBRefreshViewStateUnknown;
    }
    return self;
}

#pragma mark - *********************** delegate ***********************

#pragma mark - *********************** event response ***********************

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (keyPath == kContentOffsetKey) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [self scrollViewDidChangeContentOffset:offset];
    }else if (keyPath == kContentSizeKey){
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        [self scrollViewDidChangeContentSize:size];
    }
    
}

#pragma mark - *********************** private methods ***********************

-(void)scrollViewDidChangeContentOffset:(CGPoint)contentOffset
{
    if (self.firstLoad == NO) {
        return;
    }
    
    if (self.refreshState == LGBRefreshViewStateRefreshing) {
        return;
    }
    
    CGFloat newOffsetY = contentOffset.y;
    
    if (newOffsetY >= self.originOffsetY && self.position == RefreshPositionTop) {
        return;
    }
    
    if (newOffsetY <= self.originOffsetY && (self.position == RefreshPositionBottom || self.position == RefreshPositionInfinite)) {
        return;
    }
    
    CGFloat y = 0;
    CGFloat top = 0;
    CGFloat bottom = 0;
    CGFloat refreshHeight = [self.delegate refreshViewHeight];
    CGFloat offset = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds);
    
    if (self.position == RefreshPositionInfinite || self.position == RefreshPositionBottom) {
        UIView *view = (UIView *)self.delegate;
        if (offset < 0) {
            view.hidden = YES;
            return;
        }else{
            view.hidden = NO;
        }
    }
    
    if (self.position == RefreshPositionInfinite) {
        
        if (newOffsetY > MAX(offset, 0)) {
            self.refreshState = LGBRefreshViewStateRefreshing;
        }
        return;
    }
    
    if (self.position == RefreshPositionBottom) {

        if(newOffsetY < MAX(offset, 0)){
            return;
        }else{
            y = fabs(newOffsetY - MAX(offset, 0));
            
            if (offset <= 0) {
                bottom = refreshHeight + fabs(offset);
            }else{
                bottom = MIN(y, refreshHeight);
            }
            
            if (y > self.lastOffset) {
                self.directionUp = YES;
            }else if(y < self.lastOffset){
                self.directionUp = NO;
            }
            self.lastOffset = y;
        }
    }else if(self.position == RefreshPositionTop) {
        y = fabs(newOffsetY - self.originOffsetY);
        top = MIN(y, refreshHeight);
        
        if (y > self.lastOffset) {
            self.directionUp = NO;
        }else if(y < self.lastOffset){
            self.directionUp = YES;
        }
        self.lastOffset = y;
    }
    
    if ([self.delegate respondsToSelector:@selector(refreshViewContentOffset:directionUp:)]) {
        [self.delegate refreshViewContentOffset:y directionUp:self.directionUp];
    }
    
    if (self.scrollView.isDragging) {
        if (y >= (refreshHeight + kPullOffset) && self.refreshState == LGBRefreshViewStateNormal){
            
            self.refreshState = LGBRefreshViewStateWillRefresh;
            
        }else if (y < (refreshHeight + kPullOffset) && self.refreshState != LGBRefreshViewStateNormal ){
            
            self.refreshState = LGBRefreshViewStateNormal;
            
        }
    }else if (self.refreshState == LGBRefreshViewStateWillRefresh){
        
        self.refreshState = LGBRefreshViewStateRefreshing;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(top + self.originInsets.top, self.originInsets.left, bottom + self.originInsets.bottom, self.originInsets.right);
        } completion:^(BOOL finished) {
            
        }];
    }

}

-(void)scrollViewDidChangeContentSize:(CGSize)size
{
    self.frame = CGRectMake(0, 0, size.width, MAX(size.height, CGRectGetHeight(self.scrollView.bounds)));
}

-(void)resetScrollInsetsForPosition:(RefreshPosition)position
{
    UIEdgeInsets insets = self.scrollView.contentInset;
    
    if (position == RefreshPositionTop) {
        insets = UIEdgeInsetsMake(self.originInsets.top, insets.left, insets.bottom, insets.right);
    }else if (position == RefreshPositionBottom){
        insets = UIEdgeInsetsMake(insets.top, insets.left, self.originInsets.bottom, insets.right);
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.scrollView.contentInset = insets;
    } completion:^(BOOL finished) {
        self.refreshState = LGBRefreshViewStateNormal;
    }];
}

#pragma mark - *********************** getters and setters ***********************

-(void)setRefreshState:(LGBRefreshViewState)refreshState
{

    if (_refreshState == refreshState) {
        return;
    }
    
    _refreshState = refreshState;
    
    switch (_refreshState) {
        
        case LGBRefreshViewStateNormal:
        {
            if ([self.delegate respondsToSelector:@selector(refreshViewNormal)]) {
                [self.delegate refreshViewNormal];
            }
            
        }

            break;
        case LGBRefreshViewStateWillRefresh:
        {
            if ([self.delegate respondsToSelector:@selector(refreshViewWillRefresh)]) {
                [self.delegate refreshViewWillRefresh];
            }
            
        }
            
            break;
        case LGBRefreshViewStateRefreshing:
        {
            if ([self.delegate respondsToSelector:@selector(refreshViewRefreshing)]) {
                [self.delegate refreshViewRefreshing];
            }
            
            if (self.action) {
                self.action();
            }
        }
            
            break;
        default:
            
            break;
    }
}

@end
