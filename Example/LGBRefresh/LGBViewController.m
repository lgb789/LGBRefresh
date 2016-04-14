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
#import "HeaderRefreshView.h"
#import "FooterRefreshView.h"
#import "InfiniteRefreshView.h"

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
    [self.tableView.tableView lgb_addHeaderRefreshViewClass:[HeaderRefreshView class] action:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView configData];
            
            [weakSelf.tableView.tableView lgb_endHeaderRefresh];
        });
        
        
    }];
    
    [self.tableView.tableView lgb_addInfiniteRefreshViewClass:[InfiniteRefreshView class] action:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView configData];
            
            [weakSelf.tableView.tableView lgb_endInfiniteRefresh];
        });
        
        
    }];
    
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
