//
//  RSStyleConfig.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2021/5/10.
//  Copyright © 2021 Ron_Samkulami. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kScrollLineH 2
#define kNormalFontSize 14
#define kBigFontSize 21
#define kNormalColor [UIColor colorWithRed:192*1.0/255 green:192*1.0/255 blue:170*1.0/255 alpha:1]
#define kHighlightColor [UIColor colorWithRed:129*1.0/255 green:216*1.0/255 blue:209*1.0/255 alpha:1]
#define kNormalTitleFont [UIFont boldSystemFontOfSize:kNormalFontSize]
#define kHighlightTitleFont [UIFont boldSystemFontOfSize:kBigFontSize]

NS_ASSUME_NONNULL_BEGIN

@interface RSStyleConfig : NSObject

@end

NS_ASSUME_NONNULL_END
