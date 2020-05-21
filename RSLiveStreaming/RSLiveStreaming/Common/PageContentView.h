//
//  PageContentView.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/17.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PageContentView;
@protocol PageContentViewDelegate <NSObject>

@required
- (void)titleViewScrollWithContentView:(PageContentView *)pageContentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end


@interface PageContentView : UIView 

@property (nonatomic,weak) id<PageContentViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withChildVCS:(NSArray *)childVCS withParentVC:(UIViewController *)parentVC;
- (void)scrollToPageAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
