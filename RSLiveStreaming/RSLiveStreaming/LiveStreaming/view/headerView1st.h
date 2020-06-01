//
//  headerView1st.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/6/1.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol headerView1stDelegate <NSObject>

- (void)pushMusicView;
- (void)pushShoppingView;
- (void)pushPartyView;
- (void)pushFunView;
- (void)pushMoreChannelView;

@end

@interface headerView1st : UICollectionReusableView

@property (nonatomic,weak) id<headerView1stDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
