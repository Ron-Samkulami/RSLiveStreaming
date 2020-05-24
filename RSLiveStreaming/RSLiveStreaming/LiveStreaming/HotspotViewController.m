//
//  HotspotViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/22.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "HotspotViewController.h"
#import "RSLiveHubCell.h"

@interface HotspotViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation HotspotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    [collection registerClass:[RSLiveHubCell class] forCellWithReuseIdentifier:CellId];             //注册cell
    
    [self.view addSubview:collection];
    
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    RSLiveHubCell *cell = (RSLiveHubCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];

    //设置圆角和边线
    cell.layer.cornerRadius = 10.0f;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.masksToBounds = YES;     //子view不出格
//    cell.clipsToBounds = YES;
    return cell;
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
