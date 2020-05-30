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
@property (nonatomic,strong) NSArray *liveHubs;             //保存返回的热门主播列表
@property (nonatomic,strong) NSArray *liveAddrs;            //保存获取到的直播地址
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
    [self getData];
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.liveHubs.count;
    //    return 100;
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    LiveHub *liveHub = self.liveHubs[indexPath.item];       //获取数据模型
    RSLiveHubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];    //创建单元格
    
    cell.layer.cornerRadius = 10.0f;            //设置圆角和边线
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.masksToBounds = YES;             //子view不出格
    //cell.clipsToBounds = YES;                 //效果与上一行代码相同
    //NSLog(@"%ld",indexPath.item);
    cell.liveHubModel = liveHub;
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"点击了item：%ld",indexPath.item);
    LiveHub *liveHub = self.liveHubs[indexPath.item];                       //获取数据模型
    NSNumber *uid = [NSNumber numberWithInt:[liveHub.uid intValue]];        //获取uid
    NSLog(@"%@",uid);
    [self pushLivePageWithUid:uid];
    
    
}

#pragma mark - Get/Refresh Data
- (void)refreshData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getData];
        if ([self.collectionView.refreshControl isRefreshing]) {
            [self.collectionView.refreshControl endRefreshing];
        }
    });
}


- (void)getData {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //获取数据
        //热门主播列表：http://baseapi.busi.inke.cn/live/LiveHotList
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
            self.liveHubs = arrayModels;                    //将获取到的数据转成模型
            [self.collectionView reloadData];               //更新UI
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //failure process
        }];
    });
    [self.collectionView.refreshControl endRefreshing];
    
}


//测试:push页面跳转
- (void)pushLivePageWithUid:(NSNumber *)uid{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"获取直播间地址数据");
        //单个主播地址：http://baseapi.busi.inke.cn/live/LiveInfo?channel_id=&uid=71167152&liveid=&_t=
        AFHTTPSessionManager *manager = [RSNetworkTools sharedManager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *URLString = @"http://baseapi.busi.inke.cn/live/LiveInfo";
        
        [manager GET:URLString parameters:@{@"channel_id" : @"",
                                            @"uid" : uid,
                                            @"liveid" : @"",
                                            @"_t" : @""} headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            //progress process
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"GET:%@",responseObject);
            NSError *myError;
            id responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&myError];
            if (myError) {
                NSLog(@"解析JSON出错");
                return;
            }
            NSArray *dataDicts = [responseJSON valueForKey:@"data"];            //获取第三个key的value
            //NSLog(@"%@",dataDicts);
            //NSLog(@"%@",[dataDicts valueForKey:@"live_info"] );
            
            NSArray *liveAddrDicts = [dataDicts valueForKey:@"live_addr"];      //__NSSingleObjectArrayI
            NSMutableArray *liveModels = [NSMutableArray array];
            for (NSDictionary *dict in liveAddrDicts) {
                LiveAddr *model = [LiveAddr liveAddrWithDict:dict];
                [liveModels addObject:model];
            }
            self.liveAddrs = liveModels;                                        //将获取到的数据转成模型，并保存到数组中
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //
        }];
        
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_WALLTIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LiveAddr *liveAddr = self.liveAddrs[0];
        NSString *streamURL = liveAddr.stream_addr;                           //获取直播URL
        NSString *hlsURL = liveAddr.hls_stream_addr;
        NSString *rtmpURL = liveAddr.rtmp_stream_addr;
        NSLog(@"%@\r\t%@\r\t%@\r",streamURL,hlsURL,rtmpURL);
        //push新的viewController
         LiveRoomViewController *liveRoomVC = [[LiveRoomViewController alloc] init];
        //liveRoomVC.liveUrl =   //在获取热门主播列表时，将所有的URL也转成模型存储起来
        self.tabBarController.tabBar.hidden = YES;                                   //跳转后隐藏bottomBar
        [self.navigationController pushViewController:liveRoomVC animated:YES];
        //    liveRoomVC.liveUrl =
    });
    
    
    
    
//    [self.navigationController presentViewController:newView animated:YES completion:^{
//        NSLog(@"Modal方式弹出房间界面");
//    }];

    
    
    
    
    
    
}

#pragma mark - Life Circle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

@end
