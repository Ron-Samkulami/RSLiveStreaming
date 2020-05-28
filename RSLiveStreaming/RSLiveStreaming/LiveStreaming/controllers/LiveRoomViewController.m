//
//  LiveRoomViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/27.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "LiveRoomViewController.h"

#import <UIImageView+WebCache.h>
//#import <Accelerate/Accelerate.h>
#import "RSLikesView.h"
@interface LiveRoomViewController () <UIGestureRecognizerDelegate>


@property (weak, nonatomic) UIView *PlayerView;

@property (nonatomic, strong)UIImageView *dimIamge;
@property (nonatomic, assign)int number;
@property (nonatomic, assign)CGFloat heartSize;


@end

@implementation LiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];

//    NSURL *url = [[NSURL alloc] initWithString:@"rtmp://wswebpull.inke.cn/live/1590656275055553?msUid=&auth_version=1&from=h5&ts=1590666440&md5sum=e83d"];
    
   
    UIView *displayView = [[UIView alloc] initWithFrame:self.view.bounds];  //创建UIview
    self.PlayerView = displayView;
    self.PlayerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.PlayerView];
    
   
    UIView *playerView = [[UIView alloc] init];                                //获取播放器的view
    playerView.frame = self.PlayerView.frame;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.PlayerView insertSubview:playerView atIndex:1];
    

    [self loadingView];
    [self changeBackBtn];
}
   
#pragma mark --------

// 加载图
- (void)loadingView
{
    self.dimIamge = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [_dimIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.ikstatic.cn/MTU4OTQ0MDYxMDYyOSM1ODUjanBn.jpg"]]];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = _dimIamge.bounds;
    [_dimIamge addSubview:visualEffectView];
    [self.view addSubview:_dimIamge];
    
}



// 按钮
- (void)changeBackBtn
{
    // 返回
    UIButton * backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    backBtn.frame = CGRectMake(10, 64 / 2 - 8, 33, 33);
    backBtn.frame = CGRectMake(50, 100, 33, 33);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:(UIControlEventTouchUpInside)];
    backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(0, 0);
    backBtn.layer.shadowOpacity = 0.5;
    backBtn.layer.shadowRadius = 1;
    [self.view addSubview:backBtn];
    
    // 暂停
    UIButton * playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    playBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 33-10, 64 / 2 - 8, 33, 33);
    playBtn.frame = CGRectMake(50, 150, 33, 33);
    
    if (self.number == 0) {
        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateNormal)];
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateSelected)];
    }else{
        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateNormal)];
        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateSelected)];
    }
    
    [playBtn addTarget:self action:@selector(play_btn:) forControlEvents:(UIControlEventTouchUpInside)];
    playBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    playBtn.layer.shadowOffset = CGSizeMake(0, 0);
    playBtn.layer.shadowOpacity = 0.5;
    playBtn.layer.shadowRadius = 1;
    [self.view addSubview:playBtn];
    
    // 点赞
    UIButton * likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    likeBtn.frame = CGRectMake(playBtn.frame.origin.x/2, [UIScreen mainScreen].bounds.size.height-33-10, 33, 33);
    likeBtn.frame = CGRectMake(50, 200, 33, 33);
    [likeBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
    [likeBtn addTarget:self action:@selector(showTheLove:) forControlEvents:(UIControlEventTouchUpInside)];
    likeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    likeBtn.layer.shadowOffset = CGSizeMake(0, 0);
    likeBtn.layer.shadowOpacity = 0.5;
    likeBtn.layer.shadowRadius = 1;
    likeBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:likeBtn];
    
    
}

// 返回
- (void)goBack
{
    // 停播
    [self.navigationController popViewControllerAnimated:true];
}

// 暂停开始
- (void)play_btn:(UIButton *)sender {
    sender.selected =! sender.selected;

}
// 点赞
-(void)showTheLove:(UIButton *)sender{
    RSLikesView* heart = [[RSLikesView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(([UIScreen mainScreen].bounds.size.width-_heartSize-10)/2 + _heartSize/2.0, self.view.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"SHOW"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --------

        

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏导航栏
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;  //保持返回手势pop
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  
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
