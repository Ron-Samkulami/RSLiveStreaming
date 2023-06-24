
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
#import "headerView1st.h"

@interface RecommendViewController () <UICollectionViewDataSource,UICollectionViewDelegate,headerView1stDelegate>

@property (nonatomic,strong) NSArray *liveList;             //保存返回的热门主播列表
//@property (nonatomic,strong) LiveAddr *liveAddr;                    //保存点击的直播间拉流地址（flv,hls,rtmp）
@property (nonatomic,strong) NSMutableDictionary *coverImageUrls;        //保存所有直播间背景图url
@property (nonatomic,strong) NSMutableDictionary *liveAddrs;             //保存所有直播流url
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *contentLabel;

@end


@implementation RecommendViewController

#pragma mark - LazyLoad
- (NSArray *)liveList {
    if (_liveList == nil) {
        _liveList = [[NSArray alloc] init];
    }
    return _liveList;
}

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
    // create a special view
    self.contentLabel = [[UILabel alloc]  initWithFrame:CGRectMake(70, 0, 280, 50)];
    self.contentLabel.text = @"敖丙妲己连线PK 谁才是天使吻过的嗓音";
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor whiteColor];
    
    
    //collectionLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(cellWidth,cellWidth * 7 / 6);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = ItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(ItemMargin, ItemMargin, ItemMargin, ItemMargin);
    
    //collectionView
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collection.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    collection.backgroundColor = [UIColor whiteColor];
    collection.showsVerticalScrollIndicator = NO;
    collection.dataSource = self;
    collection.delegate = self;
    
    //register nib
    [collection registerNib:[UINib nibWithNibName:@"RSLiveHubCell" bundle:nil] forCellWithReuseIdentifier:CellId];
    [collection registerNib:[UINib nibWithNibName:@"headerView1st" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView1st"];
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView2"];
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView3"];
    
    self.collectionView = collection;
    [self.view addSubview:self.collectionView];
    
    //add refreshControl
    self.collectionView.refreshControl = [[UIRefreshControl alloc] init];
    self.collectionView.refreshControl.tintColor = [UIColor grayColor];
    self.collectionView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"松手刷新"];
    [self.collectionView.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.collectionView.alwaysBounceVertical = YES;     //can refresh when collectionView doesn't fill full screen
    [self.collectionView addSubview:self.collectionView.refreshControl];
    
    //fectch data
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self getData];
    });
}


#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

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
            if (self.liveList != nil && ![self.liveList isKindOfClass:[NSNull class]] && self.liveList.count != 0){
                num = self.liveList.count - 12;
            }
            break;
    }
    return num;
}

//cell
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    RSLiveHubCell *cell = (RSLiveHubCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.layer.cornerRadius = 10.0f;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.masksToBounds = YES;
    
    //calcuate index
    NSInteger index = 0;
    if (indexPath.section == 0) {
        index = indexPath.item;
    } else if (indexPath.section == 1) {
        index = indexPath.item + 4;
    } else if (indexPath.section == 2) {
        index = indexPath.item + 12;
    }
    
    if (self.liveList != nil && ![self.liveList isKindOfClass:[NSNull class]] && self.liveList.count != 0){
        if (index < self.liveList.count) {
            cell.liveHubModel = self.liveList[index];
            }
    }
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        headerView1st *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView1st" forIndexPath:indexPath];
        headerView.delegate = self;
        return headerView;
        
    } else if (indexPath.section == 1) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView2" forIndexPath:indexPath];
        UIView *pinView1 = [[UIView alloc] initWithFrame:CGRectMake(5, 0, cellWidth * 2 + 5, 50)];
        pinView1.backgroundColor = [UIColor orangeColor];
        pinView1.layer.cornerRadius = 10.0f;
        pinView1.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
        label.text = @"直播头条";
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 2;
        [pinView1 addSubview:label];
        [pinView1 addSubview:self.contentLabel];
        [headerView addSubview:pinView1];

        return headerView;
        
    } else {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView3" forIndexPath:indexPath];
        UIView *pinView2 = [[UIView alloc] initWithFrame:CGRectMake(5, 0, cellWidth * 2 + 5, 140)];
        pinView2.backgroundColor = [UIColor colorWithRed:129 * 1.0 / 255 green:216 * 1.0 / 255 blue:209 * 1.0 /255 alpha:1];
        pinView2.layer.cornerRadius = 10.0f;
        pinView2.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 250, 120)];
        label.text = @"绿色直播\r\t\t今夜谁当红";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont monospacedDigitSystemFontOfSize:34 weight:3.0];
        
        label.numberOfLines = 2;
        [pinView2 addSubview:label];
        [headerView addSubview:pinView2];
        return headerView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(cellWidth * 2, 80);
    } else if (section == 1) {
        return CGSizeMake(cellWidth * 2, 50);
    } else {
        return CGSizeMake(cellWidth * 2, 140);
    }
    
}


#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = 0;
    if (indexPath.section == 0) {
        idx = indexPath.item;
    } else if (indexPath.section == 1) {
        idx = indexPath.item + 4;
    } else if (indexPath.section == 2) {
        idx = indexPath.item + 12;
    }
    
    //avoid out of index
    if (self.liveList != nil && ![self.liveList isKindOfClass:[NSNull class]] && self.liveList.count != 0){
        if (idx < self.liveList.count) {
            LiveHub *liveHub = self.liveList[idx];
            NSNumber *uid = [NSNumber numberWithInt:[liveHub.uid intValue]];
            //skip into a liveRoom
            [self pushLivePageWithUid:uid];
        }
    } else {
        return;
    }
}

#pragma mark - Get/Refresh Data
- (void)refreshData {
    [self getData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.collectionView.refreshControl isRefreshing]) {
            [self.collectionView.refreshControl endRefreshing];
        }
    });
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    //url：http://baseapi.busi.inke.cn/live/LiveHotList
    AFHTTPSessionManager *manager = [RSNetworkTools sharedManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *URLString = @"http://baseapi.busi.inke.cn/live/LiveHotList";
    [manager GET:URLString parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //progress process
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        typeof(weakSelf) strongSelf = weakSelf;
        //json serialization
        NSError *myError;
        id responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&myError];
        if (myError) {
            NSLog(@"JSONSerialization error:%@",myError.domain);
            return;
        }
        
        //convert data to model
        NSArray *dataDicts = [responseJSON valueForKey:@"data"];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in dataDicts) {
            LiveHub *model = [LiveHub liveHubWithDict:dict];
            [arrayModels addObject:model];
        }
        strongSelf.liveList = [arrayModels copy];
        
        //reload
        if (strongSelf.liveList) {
            [strongSelf.collectionView reloadData];
        }
        
        //get coverImageUrls and liveAddress
        [strongSelf.coverImageUrls removeAllObjects];
        [strongSelf.liveAddrs removeAllObjects];
        for ( LiveHub *liveHub in strongSelf.liveList) {
            NSNumber *uid = [NSNumber numberWithInt:[liveHub.uid intValue]];
            [strongSelf getLiveAddrAndCoverImageWithUid:uid];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //failure process
    }];
}

- (void)getLiveAddrAndCoverImageWithUid:(NSNumber *)uid {
    //single liveroom url：http://baseapi.busi.inke.cn/live/LiveInfo?channel_id=&uid=71167152&liveid=&_t=
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
            NSLog(@"JSONSerialization error:%@",myError.domain);
            return;
        }
        
        //get liveInfo from data
        NSArray *dataDicts = [responseJSON valueForKey:@"data"];
        //cover image
        NSDictionary *liveInfoDicts = [dataDicts valueForKey:@"live_info"];
        NSString *coverImageUrl = [liveInfoDicts valueForKey:@"cover_img"];
        [self.coverImageUrls setValue:coverImageUrl forKey:[NSString stringWithFormat:@"%@",uid]];
        //live address
        NSArray *liveAddrDicts = [dataDicts valueForKey:@"live_addr"];
        if (liveAddrDicts != nil && ![liveAddrDicts isKindOfClass:[NSNull class]] && liveAddrDicts.count != 0){
            LiveAddr *addrModel = [LiveAddr liveAddrWithDict:liveAddrDicts[0]];
            [self.liveAddrs setValue:addrModel forKey:[NSString stringWithFormat:@"%@",uid]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

//skip to a live room
- (void)pushLivePageWithUid:(NSNumber *)uid{
    
    LiveAddr *liveAddr = [self.liveAddrs valueForKey:[NSString stringWithFormat:@"%@",uid]];
    NSString *imageUrl = [self.coverImageUrls valueForKey:[NSString stringWithFormat:@"%@",uid]];
    if (!(liveAddr && imageUrl)) {
        NSLog(@"NULL Data");
        return;
    }
    LiveRoomViewController *liveRoomVC = [[LiveRoomViewController alloc] init];
    liveRoomVC.liveUrl = liveAddr.hls_stream_addr;
    liveRoomVC.imageUrl = imageUrl;
    [self.navigationController pushViewController:liveRoomVC animated:NO];
    
}

#pragma mark - Life Circle

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
    
    //添加动画
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveAnimation.duration = 0.5;//动画时间
    moveAnimation.fromValue = @(self.contentLabel.center.y-25);
    moveAnimation.toValue = @(self.contentLabel.center.y);
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnimation.repeatCount = 1;
    moveAnimation.removedOnCompletion = YES;
    moveAnimation.fillMode = kCAFillModeForwards;
    [self.contentLabel.layer addAnimation:moveAnimation forKey:@"key"];
}

#pragma mark - HeaderView1st Delegate
- (void)pushMusicView {
    NSLog(@"点击了音乐");
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor blueColor];
    
    //skip to new page
    [self.navigationController pushViewController:newView animated:YES];
    
}

- (void)pushShoppingView {
    NSLog(@"点击了嗨购");
}

- (void)pushPartyView {
    NSLog(@"点击了派对");
}

- (void)pushFunView {
    NSLog(@"点击了童趣大作战");
}

- (void)pushMoreChannelView {
    NSLog(@"点击了更多频道");
}

@end


