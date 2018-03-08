//
//  HeaderRefreshView.h
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/6.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import "LGBRefresh.h"

@interface HeaderRefreshView : UIView <LGBRefreshManagerDelegate>

@property (nonatomic, copy) NSString *dateKey;

-(instancetype)initWithDateKey:(NSString *)dateKey;

@end
