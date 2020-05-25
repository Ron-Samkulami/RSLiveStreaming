//
//  LiveStreamingViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "LiveStreamingViewController.h"
#import "PageTitleView.h"
#import "PageContentView.h"
#import "RecommendViewController.h"
#import "HotspotViewController.h"

@interface LiveStreamingViewController () <PageTitleViewDelegate,PageContentViewDelegate>
@property (nonatomic,strong) NSArray *childVCS;
@property (nonatomic,strong) PageContentView *contentView;

@end

@implementation LiveStreamingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     set titleView
     */
    NSArray *titleArray = @[@"推荐",@"热门"];
    PageTitleView *titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, 0, 250, 44) andTitles:titleArray labelWidth:80];
    titleView.delegate = self;
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItem = titleItem;
    //    [self.navigationItem.leftBarButtonItem.customView setTag:102];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];     //去掉navigationBar的分割线
    
    /*
     set contentView
     */
    
    CGFloat contentH = kScreenH - kNavBarHeight - kTabBarHeight - kBottomSafeHeight;    //再减去 kStatusBarHeight 会使iPhone8小屏幕底下出现空白
    CGRect contentFrame = CGRectMake(0, kStatusBarHeight , kScreenW , contentH );       //若y值加上navigationBar的高度，会使页contentView面下移
    
//    NSLog(@"RSScreenH---%lf contentH---%lf ",kScreenH,contentH);
//    NSLog(@"statusbar---%lf navheight---%d tabBarHeight---%lf toolBarHeight---%lf ",kStatusBarHeight,kNavBarHeight,kTabBarHeight,self.navigationController.toolbar.frame.size.height);
    
    //创建当前Tab页面的子控制器集合
    NSMutableArray *VCS = [[NSMutableArray alloc] init];
    [VCS addObject:[[RecommendViewController alloc] init]];
    [VCS addObject:[[HotspotViewController alloc] init]];
    
    //创建contentView
    PageContentView *contentView = [[PageContentView alloc] initWithFrame:contentFrame withChildVCS:VCS withParentVC:self];   
//    contentView.backgroundColor = [UIColor redColor];
    contentView.delegate = self;

    self.contentView = contentView;
    [self.view addSubview:self.contentView];
    

}

#pragma mark - PageTitleViewDelegate
- (void)contentViewScrollWithTitleView:(PageTitleView *)pageTitleView selectedIndex:(NSInteger)index {
    //PageContentView *contentView = [self.view viewWithTag:202];
    //[contentView scrollToPageAtIndex:index];
    [self.contentView scrollToPageAtIndex:index];
}

#pragma mark - PageContentViewDelegate
- (void)titleViewScrollWithContentView:(PageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    //PageTitleView *titleView = self.navigationItem.leftBarButtonItem.customView;
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
