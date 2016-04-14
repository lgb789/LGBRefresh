//
//  LGBRefreshView.h
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/6.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RefreshPositionTop,
    RefreshPositionBottom,
    RefreshPositionInfinite,
} RefreshPosition;

@protocol LGBRefreshManagerDelegate <NSObject>

-(CGFloat)refreshViewHeight;

@optional
-(void)refreshViewRefreshing;

-(void)refreshViewNormal;

-(void)refreshViewWillRefresh;

-(void)refreshViewContentOffset:(CGFloat)offset
                    directionUp:(BOOL)up;

@end


@interface LGBRefreshManager : UIView
@property (nonatomic, assign) id<LGBRefreshManagerDelegate> delegate;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void(^action)(void);
@property (nonatomic, assign) RefreshPosition position;

-(void)endTopRefresh;

-(void)endBottomRefresh;

-(void)endInfiniteRefresh;

-(void)startTopRefresh;

@end
