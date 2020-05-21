//
//  MainPageViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "MainPageViewController.h"

#pragma mark - 测试使用的类
//viewDidLoad中使用的类，用来了解UIView的生命周期
@interface TestView : UIView
@end

@implementation TestView
- (instancetype)init{
    self = [super init];
    if (self) {
    
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
}
- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
}
- (void)didMoveToWindow{
    [super didMoveToWindow];
}

@end

#pragma mark - MainPageViewController
@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.title = @"";    //应该改为隐藏效果
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //覆盖navigationBar的分割线，并使navigationBar的背景显示为白色
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"";
    //先隐藏title，页面向上滚动时才显示出来，滚动到顶还是要隐藏！！！！！！！！！！！！！！
    
    //测试:title显隐
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTitle)];
    [self.navigationController.navigationBar addGestureRecognizer:tapGesture];
    
    
    //测试:页面跳转
    TestView *view1 = [[TestView alloc] init];
    view1.backgroundColor = [UIColor blackColor];
    view1.frame = CGRectMake(150, 150, 100, 100);
    [self.view addSubview:view1];
    UITapGestureRecognizer *tapOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushController)];
    [view1 addGestureRecognizer:tapOnView];
    
}


- (void)showTitle {
    //换成开始滚动的方法，还需要些 scrollToTop时再次隐藏！！！！！！！！
    self.navigationItem.title = @"Ron";
}

//测试:push页面跳转
- (void)pushController{
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.navigationItem.title = @"Content";
    newView.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right_title" style:UIBarButtonItemStylePlain target:self action:nil];
    //push新的viewController
    self.hidesBottomBarWhenPushed = YES;            //跳转后隐藏bottomBar
//    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:newView animated:YES];
    
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
