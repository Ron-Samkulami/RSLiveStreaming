//
//  RSLiveHubCell.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/23.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ItemMargin 5
#define cellWidth ([UIScreen mainScreen].bounds.size.width - ItemMargin * 3) / 2
#define CellId @"CellId"
 
NS_ASSUME_NONNULL_BEGIN
@class LiveHub;
@interface RSLiveHubCell : UICollectionViewCell

@property (nonatomic,strong) LiveHub *liveHubModel;

@end

NS_ASSUME_NONNULL_END
