//
//  AVCaptreViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/27.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "AVCaptreViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVCaptreViewController () <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic,strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic,assign) BOOL isCapturing;
@end



@implementation AVCaptreViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, 120, 30)];
    [startBtn setTitle:@"startCapture" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startCapture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 120, 30)];
    [stopBtn setTitle:@"stopCapture" forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(stopCapture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    UIButton *switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 250, 120, 30)];
    [switchBtn setTitle:@"switchSence" forState:UIControlStateNormal];
    [switchBtn addTarget:self action:@selector(switchSence) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    [self startCapture];
    
}





- (void)startCapture {
    if (self.isCapturing == YES) {
        return;
    }
    //1、创建捕捉会话
       AVCaptureSession *session = [[AVCaptureSession alloc] init];
       self.session = session;
    //2、获取视频和音频
    [self videoCapture];
    [self audioCapture];
    
   
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer = previewLayer;
    self.previewLayer.frame = [[UIScreen mainScreen] bounds];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;   //设置全屏
    NSLog(@"%@",NSStringFromCGRect(self.previewLayer.frame));
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [self.session startRunning];
    self.isCapturing = YES;
}

- (void)videoCapture {
   
    //1、设置输入源
        
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];      // 获取所有摄像头
    NSArray *captureDeviceArray = [cameras filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"position == %d", AVCaptureDevicePositionFront]];  // 获取前置摄像头
    if (!captureDeviceArray.count)
    {
        NSLog(@"获取前置摄像头失败");
        return;
    }
        // 转化为输入设备
    AVCaptureDevice *camera = captureDeviceArray.firstObject;
    NSError *errorMessage = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&errorMessage];
    if (errorMessage)
    {
        NSLog(@"AVCaptureDevice转AVCaptureDeviceInput失败");
        return;
    }
    self.videoInput = videoInput;
    [self.session addInput:self.videoInput];
    //2、设置输出源
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        // 设置视频数据格式
    NSDictionary *videoSetting = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange], kCVPixelBufferPixelFormatTypeKey, nil];
    [videoOutput setVideoSettings:videoSetting];
        // 设置输出代理、串行队列和数据回调
    dispatch_queue_t videoQueue = dispatch_queue_create("ACVideoCaptureOutputQueue", DISPATCH_QUEUE_SERIAL);
        //dispatch_queue_t captureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
        // 丢弃延迟的帧
    videoOutput.alwaysDiscardsLateVideoFrames = YES;
    [self.session addOutput:videoOutput];
    self.videoOutput = videoOutput;
}

- (void)audioCapture {
    //1、设置输入源
        // 获取所有摄像头
    AVCaptureDevice *microphone = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        // 转化为输入设备
    NSError *errorMessage = nil;
    AVCaptureInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:microphone error:&errorMessage];
    if (errorMessage)
    {
        NSLog(@"AVCaptureDevice转AVCaptureDeviceInput失败");
        return;
    }
    [self.session addInput:audioInput];
    //3、设置输出源
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        // 设置输出代理、串行队列和数据回调
    dispatch_queue_t audioQueue = dispatch_queue_create("ACAudioCaptureOutputQueue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    [self.session addOutput:audioOutput];

}

- (void)stopCapture {
    [self.session stopRunning];
    [self.previewLayer removeFromSuperlayer];
    self.isCapturing = NO;
}

- (void)switchSence {
    AVCaptureDevicePosition prePosition = self.videoInput.device.position;
    AVCaptureDevicePosition currentPosition = prePosition == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSArray *captureDeviceArray = [cameras filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"position == %d", currentPosition]];
    if (!captureDeviceArray.count)
    {
        NSLog(@"获取摄像头失败");
        return;
    }
        // 转化为输入设备
    AVCaptureDevice *camera = captureDeviceArray.firstObject;
    NSError *errorMessage = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&errorMessage];
    if (errorMessage)
    {
        NSLog(@"AVCaptureDevice转AVCaptureDeviceInput失败");
        return;
    }
    //切换input
    [self.session beginConfiguration];
    [self.session removeInput:self.videoInput];
    [self.session addInput:videoInput];
    [self.session commitConfiguration];
    self.videoInput = videoInput;
    
    
}




- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == [self.videoOutput connectionWithMediaType:AVMediaTypeVideo]) {
//        NSLog(@"正在采集画面");
    } else {
//        NSLog(@"正在采集声音");
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //隐藏导航栏

    [self.navigationController setNavigationBarHidden:YES];
    //保持返回手势pop
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
