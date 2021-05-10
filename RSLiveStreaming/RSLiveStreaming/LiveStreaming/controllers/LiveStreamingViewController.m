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
#import "RSBasicUITool.h"
#import "RSStyleConfig.h"

@interface LiveStreamingViewController () <PageTitleViewDelegate,PageContentViewDelegate>
@property (nonatomic,strong) NSArray *childVCS;
@property (nonatomic,strong) PageTitleView *pageTitleView;
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

    
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:newView animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set titleView
    NSArray *titleArray = @[@"推荐",@"热门"];
    self.pageTitleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, 0, 250, 44) andTitles:titleArray labelWidth:50];
    self.pageTitleView.delegate = self;
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:self.pageTitleView];
    self.navigationItem.leftBarButtonItem = titleItem;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];     // hide the separater below navigationBar
    
    //rightBarbuttonItem
    self.searchBtn.tintColor = kHighlightColor;
    self.startLiveBtn.tintColor = kHighlightColor;

    //set contentView
    CGFloat contentH = kScreenH - kNavBarHeight - kTabBarHeight - kBottomSafeHeight;
    CGRect contentFrame = CGRectMake(0, kStatusBarHeight , kScreenW , contentH );
    
    //create
    NSMutableArray *VCS = [[NSMutableArray alloc] init];
    [VCS addObject:[[RecommendViewController alloc] init]];
    [VCS addObject:[[HotspotViewController alloc] init]];
    
    //contentView
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
