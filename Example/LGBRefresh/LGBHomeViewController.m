//
//  LGBHomeViewController.m
//  LGBRefresh
//
//  Created by lgb789 on 16/4/14.
//  Copyright © 2016年 lgb789. All rights reserved.
//

#import "LGBHomeViewController.h"
#import "LGBViewController.h"

@interface LGBHomeViewController ()

@end

@implementation LGBHomeViewController

#pragma mark - *********************** life cycle ***********************

-(void)loadView
{
    [super loadView];
    /* set navigation bar, self.view */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleRightBarButton)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /* add subviews */

    [self layoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* add notificatioin */
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* remove notificatioin */
}

#pragma mark - *********************** delegate ***********************

#pragma mark - *********************** event response ***********************

-(void)handleRightBarButton
{
    [self.navigationController pushViewController:[LGBViewController new] animated:YES];
}

#pragma mark - *********************** private methods ***********************

-(void)layoutSubviews
{
    
}

#pragma mark - *********************** getters and setters ***********************

@end
