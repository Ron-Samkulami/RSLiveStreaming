//
//  MainPageViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "MainPageViewController.h"
#import "AVCaptreViewController.h"


#pragma mark - MainPageViewController
@interface MainPageViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@end

@implementation MainPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //覆盖navigationBar的分割线，并使navigationBar的背景显示为白色
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    
    UIStoryboard *tableViewSB = [UIStoryboard storyboardWithName:@"tableView" bundle:nil];
    UITableViewController *tableViewVC = [tableViewSB instantiateViewControllerWithIdentifier:@"tableViewID"];
    self.tableViewContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableViewVC.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:tableViewVC];
    [self.tableViewContainer addSubview:tableViewVC.view];
    
    
}


#pragma mark - Life Circle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
//    self.navigationItem.title = @"";    //应该改为隐藏效果
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}




@end
