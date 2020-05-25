//
//  RSNetworkTools.h
//  网络请求功能
//
//  Created by Ron_Samkulami on 2020/5/18.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//


#import <AFHTTPSessionManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface RSNetworkTools : AFHTTPSessionManager
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
