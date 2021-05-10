//
//  PageContentView.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/17.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "PageContentView.h"
#import "RSStyleConfig.h"
#import "RSBasicUITool.h"

#define CellReuseID @"CellReuseID"

@interface PageContentView() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *childVCS;
@property (nonatomic,weak) UIViewController *parentVC;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) CGFloat startOffseX;
@property (nonatomic,assign) CGFloat currentOffsetX;
@property (nonatomic,assign) BOOL isScrollDelegateForbidden;

@end

@implementation PageContentView 

- (instancetype)initWithFrame:(CGRect)frame withChildVCS:(NSArray *)childVCS withParentVC:(UIViewController *)parentVC {
    if (self = [super initWithFrame:frame]) {
        self.childVCS = childVCS;
        self.parentVC = parentVC;
        
        for (UIViewController *childVC in childVCS) {
            [parentVC addChildViewController:childVC];
        }
      
        self.collectionView = [self collectionViewWithFrame:frame];
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self addSubview:self.collectionView];
        self.isScrollDelegateForbidden = NO;
    }
    return self;
}


- (UICollectionView *)collectionViewWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionHeadersPinToVisibleBounds = NO;
    layout.itemSize = self.frame.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellReuseID];
    collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    return collectionView;
}



#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCS.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController *childVC = self.childVCS[indexPath.item];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isScrollDelegateForbidden = NO;
    self.startOffseX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isScrollDelegateForbidden) {
        return;
    }
    CGFloat progress;
    NSInteger sourceIndex;
    NSInteger targetIndex;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    self.currentOffsetX = scrollView.contentOffset.x;
    
    //scroll to left
    if (self.currentOffsetX > self.startOffseX) {
        progress = self.currentOffsetX / scrollViewW - floor(self.currentOffsetX / scrollViewW);
        sourceIndex = (NSInteger)(self.currentOffsetX / scrollViewW);
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVCS.count) {
            targetIndex = self.childVCS.count - 1;
        }
        //if scroll one page through
        if ((self.currentOffsetX - self.startOffseX) == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
        
    //scroll to right
    } else {
        progress = 1 - (self.currentOffsetX / scrollViewW - floor(self.currentOffsetX / scrollViewW));
        targetIndex = (NSInteger)(self.currentOffsetX / scrollViewW);
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCS.count) {
            sourceIndex = self.childVCS.count - 1;
        }
    }

    //scroll the matching title
    if ([self.delegate respondsToSelector:@selector(pageContentView:scrollProgress:sourceIndex:targetIndex:)]) {
        [self.delegate pageContentView:self scrollProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}


#pragma mark - publik
- (void)scrollToPageAtIndex:(NSInteger)index {
    //to avoid cycular msg_send, forbide delegate
    self.isScrollDelegateForbidden = YES;
    UICollectionView *collectionView = self.collectionView;
    CGFloat offsetX = index * collectionView.frame.size.width;
    [collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}

@end

