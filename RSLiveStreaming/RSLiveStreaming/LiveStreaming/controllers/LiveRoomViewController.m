//
//  LiveRoomViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/27.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "LiveRoomViewController.h"

#import <UIImageView+WebCache.h>
#import <TXLivePlayer.h>
#import "TRTCCdnPlayerManager.h"

@interface LiveRoomViewController () <UIGestureRecognizerDelegate,TXLivePlayListener>


@property (strong, nonatomic, nullable) TRTCCdnPlayerManager *cdnPlayer; //直播观众的CDN拉流播放页面
//@property (nonatomic, strong) TRTCCdnPlayerConfig *config;
//@property (nonatomic, strong) TXLivePlayer *player;
@property (strong, nonatomic) UIImageView *backImage;



@end

@implementation LiveRoomViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.


    //视频画面父view
    _videoParentView = [[UIView alloc] initWithFrame:self.view.frame];
    _videoParentView.backgroundColor = [UIColor systemPinkColor];
    _videoParentView.tag = FULL_SCREEN_PLAY_VIDEO_VIEW;
    [self.view addSubview:_videoParentView];
    [_videoParentView setHidden:YES];
    
    self.cdnPlayer = [[TRTCCdnPlayerManager alloc] initWithContainerView:_videoParentView delegate:self];

    
    [self loadingView];
}
   
#pragma mark --------



// 加载图
- (void)loadingView
{
    _backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_backImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = _backImage.bounds;
    [_backImage addSubview:visualEffectView];
    [self.view addSubview:_backImage];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Life Circle

        

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];     //隐藏导航栏
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;  //保持返回手势pop
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [self.cdnPlayer startPlay:self.liveUrl];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];  //必须在这里设置不隐藏，否则会消失
//    [self.cdnPlayer stopPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.cdnPlayer stopPlay];
}
#pragma mark - methods


- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    if (EvtID == PLAY_ERR_NET_DISCONNECT) {
//        [self toggleCdnPlay];
        NSLog(@"直播，网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启播放");
//        [self toastTip:(NSString *) param[EVT_MSG]];
    } else if (EvtID == PLAY_EVT_PLAY_END) {
//        [self toggleCdnPlay];
        NSLog(@"结束直播");
    }
}

- (void)onNetStatus:(NSDictionary *)param {
    //
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    //
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    //
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    //
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    return parentSize;
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    //
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    //
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    //
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    //
//}
//
//- (void)setNeedsFocusUpdate {
//    //
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    return NO;
//}
//
//- (void)updateFocusIfNeeded {
//    //
//}

@end
