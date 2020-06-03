//
//  NearByViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "NearByViewController.h"
#import "PageTitleView.h"
#import "PageContentView.h"
#import "PeopleViewController.h"
#import "LiveBroadcastViewController.h"
#import "DynamicViewController.h"

@interface NearByViewController () <PageTitleViewDelegate,PageContentViewDelegate>
@property (nonatomic,strong) NSArray *childVCS;
@property (nonatomic,strong) PageContentView *contentView;

@end

@implementation NearByViewController
- (IBAction)addActivity:(id)sender {
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.title = @"发布动态";
    
    
    //push新的viewController
    self.tabBarController.tabBar.hidden = YES;                          //跳转后隐藏bottomBar
    [self.navigationController pushViewController:newView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     set titleView
     */
    NSArray *titleArray = @[@"附近的人",@"附近直播",@"附近动态"];
    PageTitleView *titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, 0, 280, 44) andTitles:titleArray labelWidth:90];
    titleView.delegate = self;
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItem = titleItem;
    
    //覆盖navigationBar的分割线，并使navigationBar的背景显示为白色
    //隐藏tabbar分割线，在AppDelegate.m中设置
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    /*
     set contentView
     */
    
    CGFloat contentH = kScreenH - kNavBarHeight - kTabBarHeight - kBottomSafeHeight;
    CGRect contentFrame = CGRectMake(0, kStatusBarHeight , kScreenW , contentH );
    
    
    //创建collectionView的子页面
    NSMutableArray *VCS = [[NSMutableArray alloc] init];
    [VCS addObject:[[PeopleViewController alloc] init]];
    [VCS addObject:[[LiveBroadcastViewController alloc] init]];
    [VCS addObject:[[DynamicViewController alloc] init]];
    
    //创建collectionView
    PageContentView *contentView = [[PageContentView alloc] initWithFrame:contentFrame withChildVCS:VCS withParentVC:self];
    contentView.delegate = self;
   
    self.contentView = contentView;
    [self.view addSubview:self.contentView];
    
    
    
}

#pragma mark - PageTitleViewDelegate
- (void)contentViewScrollWithTitleView:(PageTitleView *)pageTitleView selectedIndex:(NSInteger)index {
    [self.contentView scrollToPageAtIndex:index];
}

#pragma mark - PageContentViewDelegate
- (void)titleViewScrollWithContentView:(PageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    [self.navigationItem.leftBarButtonItem.customView scrollTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    
}


#pragma mark - LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;       //tabbar：跳转页面willAppear设置隐藏
}


@end
