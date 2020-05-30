//
//  HotspotViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/22.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "HotspotViewController.h"
#import "RSNetworkTools.h"
#import "RSLiveHubCell.h"
#import "LiveHub.h"
#import "LiveAddr.h"
#import "LiveRoomViewController.h"


@interface HotspotViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSArray *liveList;             //保存返回的热门主播列表
//@property (nonatomic,strong) NSArray *liveAddrs;            //保存点击的直播间拉流地址（flv,hls,rtmp）
@property (nonatomic,strong) LiveAddr *liveAddr;            //保存点击的直播间拉流地址（flv,hls,rtmp）
@property (nonatomic,copy) NSString *currentLiveImageUrl;
//@property (nonatomic,strong) NSDictionary *allRoomAddrs;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation HotspotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(cellWidth,cellWidth * 7 / 6);                                      //item尺寸
    layout.minimumLineSpacing = 5;                                                                  //行间距
    layout.minimumInteritemSpacing = ItemMargin;                                                    //item间距
    layout.sectionInset = UIEdgeInsetsMake(ItemMargin, ItemMargin, ItemMargin, ItemMargin);         //section四周边距
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collection.autoresizingMask = UIViewAutoresizingFlexibleHeight;         //collectionView高度适配父视图
    collection.backgroundColor = [UIColor whiteColor];
    collection.showsVerticalScrollIndicator = NO;
    collection.dataSource = self;                                           //数据源和代理
    collection.delegate = self;
    [collection registerNib:[UINib nibWithNibName:@"RSLiveHubCell" bundle:nil] forCellWithReuseIdentifier:CellId];
    
    self.collectionView = collection;
    [self.view addSubview:self.collectionView];
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    self.collectionView.refreshControl.tintColor = [UIColor grayColor];
    self.collectionView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"松手刷新"];
    [self.collectionView.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    //self.collectionView.alwaysBounceVertical = YES;     //collectionView填不满屏幕时也可刷新
    [self.collectionView addSubview:self.collectionView.refreshControl];
    
    //获取网络数据
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self getLiveList];
    });
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.liveList.count;
    //    return 100;
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    LiveHub *liveHub = self.liveList[indexPath.item];       //获取数据模型
    RSLiveHubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];    //创建单元格
    
    cell.layer.cornerRadius = 10.0f;            //设置圆角和边线
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.masksToBounds = YES;             //子view不出格
    cell.liveHubModel = liveHub;
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LiveHub *liveHub = self.liveList[indexPath.item];                       //获取数据模型
    NSNumber *uid = [NSNumber numberWithInt:[liveHub.uid intValue]];        //获取uid
    NSLog(@"%@",uid);
    [self pushLivePageWithUid:uid];
    
    
}

#pragma mark - Get/Refresh Data
- (void)refreshData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getLiveList];
        if ([self.collectionView.refreshControl isRefreshing]) {
            [self.collectionView.refreshControl endRefreshing];
        }
    });
}


- (void)getLiveList {
    //获取热门主播列表：http://baseapi.busi.inke.cn/live/LiveHotList
    AFHTTPSessionManager *manager = [RSNetworkTools sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *URLString = @"http://baseapi.busi.inke.cn/live/LiveHotList";
    [manager GET:URLString parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress process
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"GET:%@",responseObject);
        NSError *myError;
        id responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&myError];
        if (myError) {
            NSLog(@"解析JSON出错");
            return;
        }
        NSArray *dataDicts = [responseJSON valueForKey:@"data"];    //获取第三个key的value
        NSLog(@"%@",dataDicts);
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in dataDicts) {
            LiveHub *model = [LiveHub liveHubWithDict:dict];
            [arrayModels addObject:model];
        }
        self.liveList = arrayModels;                    //将获取到的数据转成模型
        [self.collectionView reloadData];               //更新UI
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //failure process
    }];
}

- (void)getLiveAddrAndCoverImageWithUid:(NSNumber *)uid {
    //获取单个主播地址：http://baseapi.busi.inke.cn/live/LiveInfo?channel_id=&uid=71167152&liveid=&_t=
    NSLog(@"根据主播uid：%@获取直播间地址数据",uid);
    AFHTTPSessionManager *manager = [RSNetworkTools sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *URLString = @"http://baseapi.busi.inke.cn/live/LiveInfo";
    
    [manager GET:URLString parameters:@{@"channel_id" : @"",
                                        @"uid" : uid,
                                        @"liveid" : @"",
                                        @"_t" : @""} headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress process
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *myError;
        id responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&myError];
        if (myError) {
            NSLog(@"解析JSON出错");
            return;
        }
        NSArray *dataDicts = [responseJSON valueForKey:@"data"];            //获取第三个key的value
        //获取直播间主播信息
        NSDictionary *liveInfoDicts = [dataDicts valueForKey:@"live_info"];
        self.currentLiveImageUrl = [liveInfoDicts valueForKey:@"cover_img"];
        
        //获取直播间拉流地址
        //        NSArray *liveAddrDicts = [dataDicts valueForKey:@"live_addr"];      //__NSSingleObjectArrayI，包含三个不同协议的流媒体网络地址
        //        NSMutableArray *addrSet = [NSMutableArray array];
        //        for (NSDictionary *dict in liveAddrDicts) {
        //            LiveAddr *model = [LiveAddr liveAddrWithDict:dict];
        //            [addrSet addObject:model];
        //        }
        //        self.liveAddrs = addrSet;                                        //将获取到的数据转成模型，并保存到数组中
        
        NSArray *liveAddrDicts = [dataDicts valueForKey:@"live_addr"];
        LiveAddr *addrModel = [LiveAddr liveAddrWithDict:liveAddrDicts[0]];
        self.liveAddr = addrModel;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

//跳转到直播页面
- (void)pushLivePageWithUid:(NSNumber *)uid{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取直播地址
        [self getLiveAddrAndCoverImageWithUid:uid];
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //        LiveAddr *liveAddr = self.liveAddrs[0];
            //        NSString *streamURL = liveAddr.stream_addr;                           //获取直播URL
            //        NSString *hlsURL = liveAddr.hls_stream_addr;
            //        NSString *rtmpURL = liveAddr.rtmp_stream_addr;
            //        NSLog(@"%@\r\t%@\r\t%@\r",streamURL,hlsURL,rtmpURL);
            
            //push新的viewController
            LiveRoomViewController *liveRoomVC = [[LiveRoomViewController alloc] init];
            liveRoomVC.liveUrl = self.liveAddr.stream_addr;
            liveRoomVC.imageUrl = self.currentLiveImageUrl;
            //        self.tabBarController.tabBar.hidden = YES;                                   //跳转后隐藏bottomBar
            [self.navigationController pushViewController:liveRoomVC animated:YES];
        });
    });
    //    [self.navigationController presentViewController:newView animated:YES completion:^{
    //        NSLog(@"Modal方式弹出房间界面");
    //    }];
    
    
    
}

#pragma mark - Life Circle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;       //tabbar：跳转页面willAppear设置隐藏
    
}

@end
