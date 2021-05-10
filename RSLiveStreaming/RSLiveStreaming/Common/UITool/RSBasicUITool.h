//
//  RSBasicUITool.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2021/5/10.
//  Copyright © 2021 Ron_Samkulami. All rights reserved.
//

#ifndef RSBasicUITool_h
#define RSBasicUITool_h

#define kIs_iphone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX (kScreenW >= 375.0f && kScreenH >= 812.0f && kIs_iphone)


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
#define kNavBarHeight 44.0
#define kTabBarHeight 49.0
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))

#endif /* RSBasicUITool_h */
