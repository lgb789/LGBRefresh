//
//  UIScrollView+lgb_refresh.h
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/6.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (lgb_refresh)

-(void)lgb_addHeaderRefreshViewClass:(Class)viewClass
                              action:(void (^)(void))action;

-(void)lgb_endHeaderRefresh;

-(void)lgb_addFooterRefreshViewClass:(Class)viewClass
                              action:(void (^)(void))action;

-(void)lgb_endFooterRefresh;

-(void)lgb_addInfiniteRefreshViewClass:(Class)viewClass
                                action:(void (^)(void))action;

-(void)lgb_endInfiniteRefresh;

-(void)lgb_startHeaderRefresh;

@end
