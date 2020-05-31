
//
//  RecommendViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/22.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//


#import "RecommendViewController.h"
#import "RSNetworkTools.h"
#import "RSLiveHubCell.h"
#import "LiveHub.h"
#import "LiveAddr.h"
#import "LiveRoomViewController.h"


@interface RecommendViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *liveList;             //保存返回的热门主播列表
//@property (nonatomic,strong) LiveAddr *liveAddr;                    //保存点击的直播间拉流地址（flv,hls,rtmp）
@property (nonatomic,strong) NSMutableDictionary *coverImageUrls;        //保存所有直播间背景图url
@property (nonatomic,strong) NSMutableDictionary *liveAddrs;             //保存所有直播流url
@property (nonatomic,strong) UICollectionView *collectionView;

@end


@implementation RecommendViewController


#pragma mark - LazyLoad
- (NSMutableDictionary *)coverImageUrls {
    if (_coverImageUrls == nil) {
        _coverImageUrls = [[NSMutableDictionary alloc] initWithCapacity:30];
    }
    return _coverImageUrls;
}

- (NSMutableDictionary *)liveAddrs {
    if (_liveAddrs == nil) {
        _liveAddrs = [[NSMutableDictionary alloc] initWithCapacity:30];
    }
    return _liveAddrs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderViewId];
    
    self.collectionView = collection;
    [self.view addSubview:self.collectionView];
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    self.collectionView.refreshControl.tintColor = [UIColor grayColor];
    self.collectionView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"松手刷新"];
    [self.collectionView.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    //self.collectionView.alwaysBounceVertical = YES;     //collectionView填不满屏幕时也可刷新
    [self.collectionView addSubview:self.collectionView.refreshControl];
    
    
    //获取网络数据
    //    dispatch_async(dispatch_get_global_queue(0,0), ^{
    [self getData];
    //    });
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.liveList.count;
//    //    return 100;
//
//}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 4;
    switch (section) {
        case 0:
            num = 4;
            break;
        case 1:
            num = 8;
            break;
        case 2:
            num = self.liveList.count - 12;
            break;
    }
    return num;
}

//cell
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //三个分组
    NSLog(@"单元格序号：%ld",indexPath.item);
    
    //获取数据模型
    NSInteger index = 0;
    if (indexPath.section == 0) {
        index = indexPath.item;
        
    } else if (indexPath.section == 1) {
        index = indexPath.item + 4;
    } else if (indexPath.section == 2) {
        index = indexPath.item + 12;
    }
    LiveHub *liveHub = self.liveList[index];
    
    //创建单元格
    RSLiveHubCell *cell = (RSLiveHubCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 10.0f;        //设置圆角和阴影
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.masksToBounds = YES;
    
    cell.liveHubModel = liveHub;        //把模型数据设置给单元格
    return cell;                        //返回单元格
}

//headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UIView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderViewId forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.backgroundColor = [UIColor systemGrayColor];
    } else if (indexPath.section ==1) {
        headerView.backgroundColor = [UIColor systemRedColor];
    } else {
        headerView.backgroundColor = [UIColor systemBlueColor];
    }
    
    return (UICollectionReusableView *)headerView;
    /*
     UICollectionReusableView *supplementaryView;
     if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
     RSHeaderView *view = (RSHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
     view.headerLabel.text = [NSString stringWithFormat:@"这是header:%ld",indexPath.section];
     supplementaryView = view;
     }
     return supplementaryView;
     */
}

//header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(cellWidth * 2, 100);
    } else if (section == 1) {
        return CGSizeMake(cellWidth * 2, 50);
    } else {
        return CGSizeMake(cellWidth * 2, 150);
    }
    
}
#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //获取数据模型
    NSInteger index = 0;
    if (indexPath.section == 0) {
        index = indexPath.item;
    } else if (indexPath.section == 1) {
        index = indexPath.item + 4;
    } else if (indexPath.section == 2) {
        index = indexPath.item + 12;
    }
    LiveHub *liveHub = self.liveList[index];
    
    NSNumber *uid = [NSNumber numberWithInt:[liveHub.uid intValue]];        //获取uid
    [self pushLivePageWithUid:uid];
    
    
}

#pragma mark - Get/Refresh Data
- (void)refreshData {
    [self getData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [self getData];
        if ([self.collectionView.refreshControl isRefreshing]) {
            [self.collectionView.refreshControl endRefreshing];
        }
    });
}

- (void)getData {
    
    //获取热门主播列表：http://baseapi.busi.inke.cn/live/LiveHotList
    AFHTTPSessionManager *manager = [RSNetworkTools sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *URLString = @"http://baseapi.busi.inke.cn/live/LiveHotList";
    [manager GET:URLString parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress process
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *myError;
        id responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&myError];
        if (myError) {
            NSLog(@"解析JSON出错");
            return;
        }
        NSArray *dataDicts = [responseJSON valueForKey:@"data"];    //获取第三个key的value
        //先清空已有的数据(获取到数据后再再清空，否则下拉会崩溃，'index 10 beyond bounds for empty array')
        [self.liveList removeAllObjects];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in dataDicts) {
            LiveHub *model = [LiveHub liveHubWithDict:dict];
            [arrayModels addObject:model];
        }
        self.liveList = arrayModels;                    //将获取到的数据转成模型
        [self.collectionView reloadData];               //更新UI
        
        //获取直播间地址
        //根据每个uid ,获取图片及直播间地址
        //先清空已有的数据
        [self.coverImageUrls removeAllObjects];
        [self.liveAddrs removeAllObjects];
        
        for ( LiveHub *liveHub in self.liveList) {
            NSNumber *uid = [NSNumber numberWithInt:[liveHub.uid intValue]];
            [self getLiveAddrAndCoverImageWithUid:uid];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //failure process
        }];
    
    
    
    
}

- (void)getLiveAddrAndCoverImageWithUid:(NSNumber *)uid {
    //获取单个主播地址：http://baseapi.busi.inke.cn/live/LiveInfo?channel_id=&uid=71167152&liveid=&_t=
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
        NSString *coverImageUrl = [liveInfoDicts valueForKey:@"cover_img"];
        [self.coverImageUrls setValue:coverImageUrl forKey:[NSString stringWithFormat:@"%@",uid]];      //根据uid增加键值对
        //获取直播间拉流地址
        NSArray *liveAddrDicts = [dataDicts valueForKey:@"live_addr"];
        LiveAddr *addrModel = [LiveAddr liveAddrWithDict:liveAddrDicts[0]];         //单元素数组，获取第一个元素（包含三个地址的字典）
        [self.liveAddrs setValue:addrModel forKey:[NSString stringWithFormat:@"%@",uid]];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

//跳转到直播页面
- (void)pushLivePageWithUid:(NSNumber *)uid{
    
    LiveAddr *liveAddr = [self.liveAddrs valueForKey:[NSString stringWithFormat:@"%@",uid]];
    NSString *imageUrl = [self.coverImageUrls valueForKey:[NSString stringWithFormat:@"%@",uid]];
    if (!(liveAddr && imageUrl)) {
        NSLog(@"数据未获取到");
        return;
    }
    LiveRoomViewController *liveRoomVC = [[LiveRoomViewController alloc] init];
    liveRoomVC.liveUrl = liveAddr.stream_addr;
    liveRoomVC.imageUrl = imageUrl;
    //        self.tabBarController.tabBar.hidden = YES;                                   //跳转后隐藏bottomBar
    [self.navigationController pushViewController:liveRoomVC animated:NO];
    
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


