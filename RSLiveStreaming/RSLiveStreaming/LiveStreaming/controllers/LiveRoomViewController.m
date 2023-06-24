//
//  LiveRoomViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/27.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "LiveRoomViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <UIImageView+WebCache.h>
#import "RSLikesView.h"

CGFloat heartSize = 30;

@interface LiveRoomViewController () <UIGestureRecognizerDelegate>

@property (atomic, retain) id <IJKMediaPlayback> player; // 播放器页面
@property (nonatomic, strong) UIImageView *dimImage; // 虚化背景图
@property (nonatomic, strong) UIView *toolView; // 工具按钮视图

@end

@implementation LiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    NSString *url = @"https://wswebhls.inke.cn/live/1590914820268938/playlist.m3u8?msUid=&auth_version=1&from=h5&ts=1590918726&md5sum=1154";    //hls
    
    /*
     IJKFFOptions *options = [IJKFFOptions optionsByDefault];
     // Set param
     [options setFormatOptionIntValue:1024 * 10 forKey:@"probsize"];
     [options setFormatOptionIntValue:5000 forKey:@"analyzeduration"];
     [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
     [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
     [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
     
     // Param for living
     [options setPlayerOptionIntValue:3000 forKey:@"max_cached_duration"];   // 最大缓存大小是3秒，可以依据自己的需求修改
     [options setPlayerOptionIntValue:1 forKey:@"infbuf"];  // 无限读
     [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];  //  关闭播放器缓冲
     
     self.player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:url withOptions:options];
     */
    
    _player = [[IJKAVMoviePlayerController alloc] initWithContentURLString:self.liveUrl];
    _player.shouldAutoplay = YES;
    
    UIView *playerView = [self.player view];
    playerView.frame = self.view.frame;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:playerView];
    
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    [self installMovieNotificationObservers];
    
    
    [self loadingView];
    
    self.toolView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.toolView];
    
    [self addSomeBtn];
}

#pragma mark -
// 按钮
- (void)addSomeBtn {
    // 返回
    UIButton * backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(10, 64, 60, 60);
    [backBtn setTitle:@"返回" forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:(UIControlEventTouchUpInside)];
    backBtn.layer.shadowColor = [UIColor redColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(0, 0);
    backBtn.layer.shadowOpacity = 0.5;
    backBtn.layer.shadowRadius = 1;
    [self.toolView addSubview:backBtn];
    
    // 暂停
    UIButton * pauseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    pauseBtn.frame = CGRectMake(self.view.frame.size.width - 90, 64, 60, 60);
    [pauseBtn setTitle:@"暂停" forState:(UIControlStateNormal)];
    [pauseBtn addTarget:self action:@selector(onClickPauseButton:) forControlEvents:(UIControlEventTouchUpInside)];
    pauseBtn.layer.shadowColor = [UIColor redColor].CGColor;
    pauseBtn.layer.shadowOffset = CGSizeMake(0, 0);
    pauseBtn.layer.shadowOpacity = 0.5;
    pauseBtn.layer.shadowRadius = 1;
    [self.toolView addSubview:pauseBtn];
    
    // 点赞
    UIButton * likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    likeBtn.frame = CGRectMake(self.view.frame.size.width/2 - 30, self.view.frame.size.height-90, 60, 60);
    [likeBtn setTitle:@"点赞" forState:(UIControlStateNormal)];
    likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [likeBtn addTarget:self action:@selector(onClickLikeButton:) forControlEvents:(UIControlEventTouchUpInside)];
    likeBtn.layer.shadowColor = [UIColor redColor].CGColor;
    likeBtn.layer.shadowOffset = CGSizeMake(0, 0);
    likeBtn.layer.shadowOpacity = 0.5;
    likeBtn.layer.shadowRadius = 1;
    likeBtn.adjustsImageWhenHighlighted = NO;
    [self.toolView addSubview:likeBtn];
    
    
}

// 加载过程显示毛玻璃背景
- (void)loadingView {
    self.dimImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //    [_dimIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ikstatic.cn/MTU4OTQ0MDYxMDYyOSM1ODUjanBn.jpg"]]];
    [_dimImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    _dimImage.contentMode = UIViewContentModeScaleAspectFill;
    _dimImage.clipsToBounds = YES;
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = _dimImage.bounds;
    [_dimImage addSubview:visualEffectView];
    [self.view addSubview:_dimImage];
    NSLog(@"加载背景图");
    
}


#pragma mark - Notification Selector

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    if ([self.player isPlaying]) {
        _dimImage.hidden = YES;
    }
    
    switch (_player.playbackState) {
            
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark - Install Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}



#pragma mark - Btn Selector
// 返回
- (void)goBack {
    // 停播
    [self.player shutdown];
    
    [self.navigationController popViewControllerAnimated:true];
    
}

// 暂停开始
- (void)onClickPauseButton:(UIButton *)sender {
    if (![self.player isPlaying]) {
        // 播放
        [self.player play];
        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
    } else {
        // 暂停
        [self.player pause];
        [sender setTitle:@"继续" forState:(UIControlStateNormal)];
    }
}

// 点赞
- (void)onClickLikeButton:(UIButton *)sender {
    RSLikesView* heart = [[RSLikesView alloc] initWithFrame:CGRectMake(0, 0, heartSize, heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(([UIScreen mainScreen].bounds.size.width- heartSize -10)/2 + heartSize/2.0, self.view.bounds.size.height - heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.toolView];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"SHOW"];
}




#pragma mark - life circle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];     //隐藏导航栏
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;  //保持返回手势pop
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 清理缓存
}


@end
