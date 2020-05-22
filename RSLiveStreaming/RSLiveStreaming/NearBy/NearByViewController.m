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
#import "RecommendViewController.h"

@interface NearByViewController () <PageTitleViewDelegate,PageContentViewDelegate>
@property (nonatomic,strong) NSArray *childVCS;

@end

@implementation NearByViewController

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
    [VCS addObject:[[RecommendViewController alloc] init]];
    for (int i = 0; i < titleArray.count - 1; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) * 1.0 / 255 green:arc4random_uniform(255) * 1.0 / 255 blue:arc4random_uniform(255) * 1.0 / 255 alpha:1];
        [VCS addObject:vc];
    }
    
    //创建collectionView
    PageContentView *contentView = [[PageContentView alloc] initWithFrame:contentFrame withChildVCS:VCS withParentVC:self];
    contentView.delegate = self;
    [contentView setTag:202];
    [self.view addSubview:contentView];
    
    
}

#pragma mark - PageTitleViewDelegate
- (void)contentViewScrollWithTitleView:(PageTitleView *)pageTitleView selectedIndex:(NSInteger)index {
    [[self.view viewWithTag:202] scrollToPageAtIndex:index];
}

#pragma mark - PageContentViewDelegate
- (void)titleViewScrollWithContentView:(PageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    [self.navigationItem.leftBarButtonItem.customView scrollTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    
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
