//
//  RecommendViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/21.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "RecommendViewController.h"
#import "RSLiveHubCell.h"




@interface RecommendViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation RecommendViewController

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
    //    layout.sectionHeadersPinToVisibleBounds = YES;                              //header悬浮
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collection.autoresizingMask = UIViewAutoresizingFlexibleHeight;             //collectionView高度适配父视图
    collection.backgroundColor = [UIColor whiteColor];                          //底色为白色
    collection.showsVerticalScrollIndicator = NO;
    
    collection.dataSource = self;                                               //数据源和代理
    collection.delegate = self;
    
    [collection registerNib:[UINib nibWithNibName:@"RSLiveHubCell" bundle:nil] forCellWithReuseIdentifier:CellId];
//    [collection registerClass:[RSLiveHubCell class] forCellWithReuseIdentifier:CellId];       //注册cell
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderViewId];
    [self.view addSubview:collection];
    
}

#pragma mark - Life Circle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //
    
}

#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 8;
    }
    return 10;
}

//cell
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //有三组不同的数据
    NSLog(@"%ld",indexPath.item);
    
    //获取数据模型
//    RSLiveHub *liveHub == self.liveHubs[indexPath.item];

    //创建单元格
//    RSLiveHubCell *cell = [RSLiveHubCell liveHutCellWithTableView:tableView];
    RSLiveHubCell *cell = (RSLiveHubCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    //设置圆角和阴影
    cell.layer.cornerRadius = 10.0f;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.masksToBounds = YES;

    
    
    //把模型数据设置给单元格
//    cell.liveHubModel = liveHub;
    //返回单元格
    return cell;
}

//header
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
    NSLog(@"点击了item：%@",indexPath);
}

#pragma mark - UICollectionView Delegate FlowLayout
/*
 //两个cell之间的间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
 return 5;
 }
 
 //两行cell之间的间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
 return 5;
 }
 
 //定义每个Cell的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 CGSize size = CGSizeMake(80,80);
 return size;
 }
 
 //定义每个Section的四边间距
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
 return UIEdgeInsetsMake(15, 15, 5, 15);     //分别为上、左、下、右
 }
 */


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
