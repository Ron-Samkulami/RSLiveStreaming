//
//  PageTitleView.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/16.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PageTitleView;
@protocol PageTitleViewDelegate <NSObject>

@required
- (void)pageTitleView:(PageTitleView *)pageTitleView didScrollToIndex:(NSInteger)index;

@end


@interface PageTitleView : UIView

@property (nonatomic,weak) id<PageTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles labelWidth:(CGFloat)labelWidth;

- (void)scrollTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end

NS_ASSUME_NONNULL_END
