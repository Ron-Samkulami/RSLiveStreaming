//
//  PageContentView.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/17.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "PageContentView.h"
@interface PageContentView() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *childVCS;
// 父类 用于处理添加子控制器  使用weak避免循环引用
@property (nonatomic,weak) UIViewController *parentVC;
@property (nonatomic,assign) CGFloat startOffseX;
@property (nonatomic,assign) CGFloat currentOffsetX;
@property (nonatomic,assign) BOOL isForbidScrollDelegate;   //是否禁止代理方法
@end

@implementation PageContentView 


- (instancetype)initWithFrame:(CGRect)frame withChildVCS:(NSArray *)childVCS withParentVC:(UIViewController *)parentVC {
    self = [super initWithFrame:frame];
    if (self) {
        self.childVCS = childVCS;
        self.parentVC = parentVC;
        
        for (UIViewController *childVC in childVCS) {
            [parentVC addChildViewController:childVC];
        }
      
        UICollectionView *collectionView = [self collectionViewWithFrame:frame];
        [collectionView setTag:200];            //controller中设置的tag不能和这里的tag相同
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self addSubview:collectionView];
        self.isForbidScrollDelegate = NO;       //默认不禁止代理方法
    }
    return self;
}

//创建collectionView
- (UICollectionView *)collectionViewWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionHeadersPinToVisibleBounds = NO;
    layout.itemSize = self.frame.size;          //这里有些问题
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
//    collectionView.backgroundColor = [UIColor redColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"contentId"];
    collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    return collectionView;
}



#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCS.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    //创建cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentId" forIndexPath:indexPath];
    //设置cell内容
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController *childVC = self.childVCS[indexPath.item];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];
    //NSLog(@"创建cell%ld",(long)indexPath.item);
    return cell;
    
}

#pragma mark - CollectionView Delegate

//监听PageContent的滚动，设置pageTitleView高亮位置偏移，调用controller中实现的PageContentViewDelegate代理方法，设置title滚动

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isForbidScrollDelegate = NO;                       //允许执行代理方法
    self.startOffseX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isForbidScrollDelegate) {                      //如果禁用了代理方法，return
        return;
    }
    CGFloat progress;
    NSInteger sourceIndex;
    NSInteger targetIndex;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    self.currentOffsetX = scrollView.contentOffset.x;
    
    if (self.currentOffsetX > self.startOffseX) {
        //左滑
        progress = self.currentOffsetX / scrollViewW - floor(self.currentOffsetX / scrollViewW);        //计算滑动进度progress
        sourceIndex = (NSInteger)(self.currentOffsetX / scrollViewW);                                   //计算sourceIndex
        targetIndex = sourceIndex + 1;                                                                  //计算targetIndex
        if (targetIndex >= self.childVCS.count) {
            targetIndex = self.childVCS.count - 1;
        }
        //如果完全滑过去
        if ((self.currentOffsetX - self.startOffseX) == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    } else {
        //右滑
        progress = 1 - (self.currentOffsetX / scrollViewW - floor(self.currentOffsetX / scrollViewW));
        targetIndex = (NSInteger)(self.currentOffsetX / scrollViewW);
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCS.count) {
            sourceIndex = self.childVCS.count - 1;
        }
    }

    //调用代理方法，滚动title
    if ([self.delegate respondsToSelector:@selector(titleViewScrollWithContentView:progress:sourceIndex:targetIndex:)]) {
        [self.delegate titleViewScrollWithContentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}


#pragma mark - PageContent随PageTitle滚动

/*
 暴露给controller调用的方法（controller中实现pageTitleView的代理方法调用次方法设置pageContent）
 */
- (void)scrollToPageAtIndex:(NSInteger)index {
    //titleView的点击事件不应该触发pageContentView的代理方法（该代理方法会触发titleView的切换，造成循环）
    //设置禁止执行代理方法
    self.isForbidScrollDelegate = YES;
    
    UICollectionView *collectionView = [self viewWithTag:200];
    CGFloat offsetX = index * collectionView.frame.size.width;
    [collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
   
}
@end

