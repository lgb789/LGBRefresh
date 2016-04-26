//
//  TableView.m
//  PullReflashDemo
//
//  Created by lgb789 on 16/4/5.
//  Copyright © 2016年 com.lgb. All rights reserved.
//

#import "TableView.h"

@interface TableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL firstLayout;
@property (nonatomic, assign) NSInteger rows;
@end

@implementation TableView

#pragma mark - *********************** public methods ***********************

-(void)configData
{
    self.rows += 5;
    [self.tableView reloadData];
}

#pragma mark - *********************** life cycle ***********************

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        self.rows = 5;
//        __weak typeof(self) weakSelf = self;
        
//        [self.tableView lgb_addHeaderRefreshViewClass:[HeaderRefreshView class] action:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                weakSelf.rows += 2;
//                [weakSelf.tableView reloadData];
//                [weakSelf.tableView lgb_endHeaderRefresh];
//            });
//        }];
//        
//        
////        [self.tableView lgb_addFooterRefreshViewClass:[FooterRefreshView class] action:^{
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                weakSelf.rows += 2;
////                [weakSelf.tableView reloadData];
////                [weakSelf.tableView lgb_endFooterRefresh];
////            });
////        }];
//        [self.tableView lgb_addInfiniteRefreshViewClass:[InfiniteRefreshView class] action:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                weakSelf.rows += 2;
//                [weakSelf.tableView reloadData];
//                [weakSelf.tableView lgb_endInfiniteRefresh];
//            });
//            
//        }];
    }
    return self;
}

#pragma mark - *********************** overwrite method ***********************
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    
}

#pragma mark - *********************** delegate ***********************

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rows;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell -- %ld", indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - *********************** event response ***********************

#pragma mark - *********************** private methods ***********************

#pragma mark - *********************** getters and setters ***********************
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
