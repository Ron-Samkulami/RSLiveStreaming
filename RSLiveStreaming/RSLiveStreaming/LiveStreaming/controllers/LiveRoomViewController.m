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


@interface LiveRoomViewController () <UIGestureRecognizerDelegate,TXLivePlayListener>



@property (strong, nonatomic) UIImageView *backImage;
@property (nonatomic, strong) UIView  *videoParentView;
@property (nonatomic, strong) TXLivePlayer *txLivePlayer;


@end

@implementation LiveRoomViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadingView];
    // Do any additional setup after loading the view.
    
    _videoParentView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_videoParentView];
    _txLivePlayer = [[TXLivePlayer alloc] init];
    [_txLivePlayer setupVideoWidget:CGRectZero containView:_videoParentView insertIndex:0];
    _txLivePlayer.delegate = self;

//    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, [UIScreen mainScreen].bounds.size.height - 60, 20, 20)];
//    closeBtn.titleLabel.text = @"关闭";
//    [closeBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:closeBtn atIndex:2];
    
    
    

    
}

#pragma mark --------
//- (void)closeVC {
//    NSLog(@"关闭直播间");
//    [self.navigationController popViewControllerAnimated:NO];
//}
// 加载图
- (void)loadingView
{
    _backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_backImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    _backImage.contentMode = UIViewContentModeScaleAspectFill;
    _backImage.clipsToBounds = YES;
    //添加蒙版
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
    
    [_txLivePlayer startPlay:self.liveUrl type:PLAY_TYPE_LIVE_FLV];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];  //必须在这里设置不隐藏，否则会消失
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // 停止播放
    [_txLivePlayer stopPlay];
    [_txLivePlayer removeVideoWidget]; // 记得销毁view控件
}
#pragma mark - Listener


- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    if (EvtID == PLAY_ERR_NET_DISCONNECT) {
        NSLog(@"直播，网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启播放");
        //直播可能已经结束，显示直播主页
    } else if (EvtID == PLAY_EVT_PLAY_END) {
        //    [self toggleCdnPlay];
        NSLog(@"结束直播");
    } else if (EvtID == PLAY_EVT_PLAY_BEGIN) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backImage.alpha = 0.3;
        } completion:^(BOOL finished) {
//            self.backImage.hidden = YES;
            self.backImage.alpha = 0.1;
        }];
    
    }
}

- (void)onNetStatus:(NSDictionary *)param {
    //
}


@end
