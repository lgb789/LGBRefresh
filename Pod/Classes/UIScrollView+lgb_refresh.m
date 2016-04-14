//
//  UIScrollView+lgb_refresh.m
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/6.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import "UIScrollView+lgb_refresh.h"
#import "LGBRefreshManager.h"
#import <objc/runtime.h>

static char kTopRefreshManagerKey;
static char kBottomRefreshManagerKey;
static char kInfiniteRefreshManagerKey;

@implementation UIScrollView (lgb_refresh)

#pragma mark - *********************** public methods ***********************
-(void)lgb_addHeaderRefreshViewClass:(Class)viewClass
                              action:(void (^)(void))action
{
    [self lgb_addRefreshViewClass:viewClass action:action position:RefreshPositionTop];
}

-(void)lgb_addFooterRefreshViewClass:(Class)viewClass
                              action:(void (^)(void))action
{
    [self lgb_addRefreshViewClass:viewClass action:action position:RefreshPositionBottom];
}

-(void)lgb_addInfiniteRefreshViewClass:(Class)viewClass
                                action:(void (^)(void))action
{
    [self lgb_addRefreshViewClass:viewClass action:action position:RefreshPositionInfinite];
}

-(void)lgb_endHeaderRefresh
{
    LGBRefreshManager *manager = (LGBRefreshManager *)[self lgb_refreshManagerForKey:&kTopRefreshManagerKey];

    [manager endTopRefresh];
}

-(void)lgb_endFooterRefresh
{
    LGBRefreshManager *manager = (LGBRefreshManager *)[self lgb_refreshManagerForKey:&kBottomRefreshManagerKey];

    [manager endBottomRefresh];
}

-(void)lgb_endInfiniteRefresh
{
    LGBRefreshManager *manager = (LGBRefreshManager *)[self lgb_refreshManagerForKey:&kInfiniteRefreshManagerKey];
    
    [manager endInfiniteRefresh];
}

-(void)lgb_startHeaderRefresh
{
    LGBRefreshManager *manager = (LGBRefreshManager *)[self lgb_refreshManagerForKey:&kTopRefreshManagerKey];
    
    [manager startTopRefresh];
}

#pragma mark - *********************** private methods ***********************

-(void)lgb_addRefreshViewClass:(Class)viewClass
                        action:(void (^)(void))action
                      position:(RefreshPosition)position
{
    NSAssert([viewClass conformsToProtocol:@protocol(LGBRefreshManagerDelegate)], ([NSString stringWithFormat:@"\n**************************\n%@ must conforms to protocol:LGBRefreshManagerDelegate\n**************************\n", NSStringFromClass(viewClass)]));
    
    void *key = nil;
    if (position == RefreshPositionTop) {
        key = &kTopRefreshManagerKey;
    }else if (position == RefreshPositionBottom){
        key = &kBottomRefreshManagerKey;
    }else if (position == RefreshPositionInfinite){
        key = &kInfiniteRefreshManagerKey;
    }
    
    LGBRefreshManager *manager = (LGBRefreshManager *)[self lgb_refreshManagerForKey:key];

    if (manager == nil) {
        manager = [[LGBRefreshManager alloc] init];
        manager.scrollView = self;
        manager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:manager];

        [self lgb_setRefreshManager:manager key:key];
        
    }
    
    manager.action = action;
    manager.position = position;
    
    UIView *view = (UIView *)manager.delegate;
    if (view) {
        [view removeFromSuperview];
    }
    
    UIView<LGBRefreshManagerDelegate> *refreshView = [[viewClass alloc] init];
    
    refreshView.translatesAutoresizingMaskIntoConstraints = NO;
    
    manager.delegate = refreshView;
    
    [manager addSubview:refreshView];
    
    NSArray *constraints = nil;
    CGFloat refreshHeight = [refreshView refreshViewHeight];

    if (position == RefreshPositionTop) {
        constraints = @[
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:manager attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:refreshHeight],
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:manager attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:manager attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]
                        ];
    }else {
        constraints = @[
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:manager attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0],
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:refreshHeight],
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:manager attribute:NSLayoutAttributeBottom multiplier:1.0 constant:refreshHeight],
                        [NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:manager attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]
                        ];
    }
    
    
    
    [manager addConstraints:constraints];
}

#pragma mark - *********************** getters and setters ***********************

-(id)lgb_refreshManagerForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

-(void)lgb_setRefreshManager:(id)manager
                         key:(void *)key
{
    objc_setAssociatedObject(self, key, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
