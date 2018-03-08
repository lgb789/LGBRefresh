//
//  LGBViewController.m
//  LGBRefresh
//
//  Created by lgb789 on 04/14/2016.
//  Copyright (c) 2016 lgb789. All rights reserved.
//

#import "LGBViewController.h"
#import "TableView.h"
#import "LGBRefresh.h"


@interface LGBViewController ()
@property (nonatomic, strong) TableView *tableView;
@end

@implementation LGBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView.tableView lgb_addHeaderRefreshView:[[HeaderRefreshView alloc] initWithDateKey:@"header_key"] action:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView configData];
            
            [weakSelf.tableView.tableView lgb_endHeaderRefresh];
        });
        
        
    }];
#if 1
    [self.tableView.tableView lgb_addInfiniteRefreshView:[InfiniteRefreshView new] action:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView configData];
            
            [weakSelf.tableView.tableView lgb_endInfiniteRefresh];
        });
        
        
    }];
#else
    [self.tableView.tableView lgb_addFooterRefreshView:[[FooterRefreshView alloc] initWithDateKey:@"footer_key"] action:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView configData];
            
            [weakSelf.tableView.tableView lgb_endFooterRefresh];
        });
        
        
    }];
#endif
    
    [self.tableView.tableView lgb_startHeaderRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [TableView new];
    }
    return _tableView;
}

@end
