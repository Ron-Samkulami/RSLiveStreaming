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

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //覆盖navigationBar的分割线，并使navigationBar的背景显示为白色
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"";
    //先隐藏title，页面向上滚动时才显示出来，滚动到顶还是要隐藏！！！！！！！！！！！！！！
    
//    //测试:title显隐
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTitle)];
//    [self.navigationController.navigationBar addGestureRecognizer:tapGesture];
    
    
    UIStoryboard *tableViewSB = [UIStoryboard storyboardWithName:@"tableView" bundle:nil];
    UITableViewController *tableViewVC = [tableViewSB instantiateViewControllerWithIdentifier:@"tableViewID"];
    self.tableViewContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableViewVC.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:tableViewVC];
    [self.tableViewContainer addSubview:tableViewVC.view];
    
    
}


//- (void)showTitle {
//    //换成开始滚动的方法，还需要些 scrollToTop时再次隐藏！！！！！！！！
//    self.navigationItem.title = @"Ron";
//}

//测试:push页面跳转
//- (void)pushController{
//
//    //push新的viewController
//    self.tabBarController.tabBar.hidden = YES;                      //跳转后隐藏bottomBar
//    [self.navigationController pushViewController:newView animated:YES];
//
//    //以下写在newView的viewWillAppear方法中，隐藏导航栏并保持返回手势pop
////    [newView.navigationController setNavigationBarHidden:YES animated:YES];
////    newView.navigationController.interactivePopGestureRecognizer.delegate = newView;
////    newView.navigationController.interactivePopGestureRecognizer.enabled = YES;
//
//}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
