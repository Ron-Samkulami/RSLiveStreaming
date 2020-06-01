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
#import "AVCaptreViewController.h"

@interface LiveStreamingViewController () <PageTitleViewDelegate,PageContentViewDelegate>
@property (nonatomic,strong) NSArray *childVCS;
@property (nonatomic,strong) PageContentView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startLiveBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBtn;

@end

@implementation LiveStreamingViewController
- (IBAction)searchAnchor:(id)sender {
    NSLog(@"查找主播");
}

- (IBAction)startLive:(id)sender {
    NSLog(@"开启直播");
    AVCaptreViewController *newView = [[AVCaptreViewController alloc] init];
    newView.view.backgroundColor = [UIColor blueColor];

    //push新的viewController
    self.tabBarController.tabBar.hidden = YES;                          //跳转后隐藏bottomBar
    [self.navigationController pushViewController:newView animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set titleView
    NSArray *titleArray = @[@"推荐",@"热门"];
    PageTitleView *titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, 0, 250, 44) andTitles:titleArray labelWidth:50];
    titleView.delegate = self;
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItem = titleItem;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];     //去掉navigationBar的分割线
    
    //rightBarbuttonItem
    self.searchBtn.tintColor = [UIColor colorWithRed:129 * 1.0 / 255 green:216 * 1.0 / 255 blue:209 * 1.0 /255 alpha:1];
    self.startLiveBtn.tintColor = [UIColor colorWithRed:129 * 1.0 / 255 green:216 * 1.0 / 255 blue:209 * 1.0 /255 alpha:1];

    
    
    //set contentView
    CGFloat contentH = kScreenH - kNavBarHeight - kTabBarHeight - kBottomSafeHeight;  //再减去 kStatusBarHeight会使iPhone8小屏幕底下出现空白
    CGRect contentFrame = CGRectMake(0, kStatusBarHeight , kScreenW , contentH );     //若y值加上navigationBar的高度，会使页contentView面下移
    //创建当前Tab页面的子控制器集合
    NSMutableArray *VCS = [[NSMutableArray alloc] init];
    [VCS addObject:[[RecommendViewController alloc] init]];
    [VCS addObject:[[HotspotViewController alloc] init]];
    
    //创建contentView
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
