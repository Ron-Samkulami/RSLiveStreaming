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

@interface HotspotViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSArray *liveHubs;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation HotspotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(cellWidth,cellWidth * 4 / 3);                                      //item尺寸
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
    self.collectionView.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
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

- (void)refreshData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        [self.collectionView reloadData];
        
        if ([self.collectionView.refreshControl isRefreshing]) {
            
            [self.collectionView.refreshControl endRefreshing];
        }
    });
}


- (void)getData {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //获取数据
        //    [[RSNetworkTools sharedManager] GET:@"http://baseapi.busi.inke.cn/live/LiveHotList" parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //        //
        //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        //
        //    }];
        
        AFHTTPSessionManager *manager = [RSNetworkTools sharedManager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *URLString = @"http://baseapi.busi.inke.cn/live/LiveHotList";
        //    NSDictionary *parameters = @{@"foo": @"bar", @"baz": @[@1, @2, @3]};
        NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
        
        //    GET http://baseapi.busi.inke.cn/live/LiveHotList?foo=bar&baz[]=1&baz[]=2&baz[]=3
        //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://baseapi.busi.inke.cn/live/LiveHotList"]];
        
        
        [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            //NSLog(@"%@",[filePath relativePath]);         //获取到的是绝对地址，转成相对地址
            NSData *responseData = [NSData dataWithContentsOfFile:[filePath relativePath] options:NSDataReadingMappedIfSafe error:nil];
            //NSLog(@"%@",responseData);                    //二进制文件
            NSError *myError;
            id responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&myError];
            if (error) {
                NSLog(@"解析JSON出错");
                return;
            }
            //NSLog(@"%@  ",responseJSON);
            //NSLog(@"类型：%@",[responseJSON class]);         //二进制文件转成字典
            
            NSArray *dataDicts = [responseJSON valueForKey:@"data"];    //获取第三个key的value
            NSLog(@"%@",dataDicts);
            NSMutableArray *arrayModels = [NSMutableArray array];
            for (NSDictionary *dict in dataDicts) {
                LiveHub *model = [LiveHub liveHubWithDict:dict];
                [arrayModels addObject:model];
            }
            self.liveHubs = arrayModels;                    //将获取到的数据转成模型
            [self.collectionView reloadData];               //更新UI
            
            
        }] resume];
        
    });
    [self.collectionView.refreshControl endRefreshing];
    
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
