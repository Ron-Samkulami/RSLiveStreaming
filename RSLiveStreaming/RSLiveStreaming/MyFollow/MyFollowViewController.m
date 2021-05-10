//
//  MyFollowViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "MyFollowViewController.h"
#import "PageTitleView.h"
#import "PageContentView.h"
#import "FollowedLiveViewController.h"
#import "DynamicViewController.h"
#import "RSBasicUITool.h"

@interface MyFollowViewController () <PageTitleViewDelegate,PageContentViewDelegate>
@property (nonatomic,strong) NSArray *childVCS;
@property (nonatomic,strong) PageContentView *contentView;

@end

@implementation MyFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    set titleView
    */
    NSArray *titleArray = @[@"直播",@"动态"];
    PageTitleView *titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, 0, 250, 44) andTitles:titleArray labelWidth:50];
    titleView.delegate = self;
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItem = titleItem;
    
    //覆盖navigationBar的分割线，并使navigationBar的背景显示为白色
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    /*
     set contentView
     */
    
    CGFloat contentH = kScreenH - kNavBarHeight - kTabBarHeight - kBottomSafeHeight;
    CGRect contentFrame = CGRectMake(0, kStatusBarHeight , kScreenW , contentH );
    
    
    
    //创建collectionView的子页面
    NSMutableArray *VCS = [[NSMutableArray alloc] init];
    [VCS addObject:[[FollowedLiveViewController alloc] init]];
    [VCS addObject:[[DynamicViewController alloc] init]];
    
    
    
    //创建collectionView
    PageContentView *contentView = [[PageContentView alloc] initWithFrame:contentFrame withChildVCS:VCS withParentVC:self];
    contentView.delegate = self;
  
    self.contentView = contentView;
    [self.view addSubview:self.contentView];
    
    
}

#pragma mark - PageTitleViewDelegate
- (void)pageTitleView:(PageTitleView *)pageTitleView didScrollToIndex:(NSInteger)index {
    [self.contentView scrollToPageAtIndex:index];

}

#pragma mark - PageContentViewDelegate
- (void)pageContentView:(PageContentView *)pageContentView scrollProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    [self.navigationItem.leftBarButtonItem.customView scrollTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}


@end
