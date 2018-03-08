//
//  UIScrollView+lgb_refresh.h
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/6.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGBRefreshManagerDelegate;

@interface UIScrollView (lgb_refresh)

-(void)lgb_addHeaderRefreshView:(UIView<LGBRefreshManagerDelegate> *)refreshView
                         action:(void (^)(void))action;

-(void)lgb_endHeaderRefresh;

-(void)lgb_addFooterRefreshView:(UIView<LGBRefreshManagerDelegate> *)refreshView
                         action:(void (^)(void))action;

-(void)lgb_endFooterRefresh;

-(void)lgb_addInfiniteRefreshView:(UIView<LGBRefreshManagerDelegate> *)refreshView
                           action:(void (^)(void))action;

-(void)lgb_endInfiniteRefresh;

-(void)lgb_startHeaderRefresh;

@end
