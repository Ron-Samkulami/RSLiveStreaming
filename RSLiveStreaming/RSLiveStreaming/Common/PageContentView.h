//
//  PageContentView.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/17.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageTitleView.h"       //需要用到kScreenW和kscreenH

#define kIs_iphone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX (kScreenW >= 375.0f && kScreenH >= 812.0f && kIs_iphone)

#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
#define kNavBarHeight 44.0
#define kTabBarHeight 49.0
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
 /*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))




//#define RSStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//#define RSNavigationBarHeight self.navigationController.navigationBar.frame.size.height
//#define RSTabbarHeight self.tabBarController.tabBar.frame.size.height
//#define RSToolbarHeight self.navigationController.toolbar.frame.size.height
NS_ASSUME_NONNULL_BEGIN

@class PageContentView;
@protocol PageContentViewDelegate <NSObject>

@required
- (void)titleViewScrollWithContentView:(PageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end


@interface PageContentView : UIView 

@property (nonatomic,weak) id<PageContentViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withChildVCS:(NSArray *)childVCS withParentVC:(UIViewController *)parentVC;
- (void)scrollToPageAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
