//
//  RSNetworkTools.m
//  网络请求功能
//
//  Created by Ron_Samkulami on 2020/5/18.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "RSNetworkTools.h"

@implementation RSNetworkTools


//封装单例manager
+ (instancetype)sharedManager {
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
//        config.timeoutIntervalForRequest = 15;                          //超时时长
        instance = [[self alloc] initWithBaseURL:nil sessionConfiguration:config];
    });
    return instance;
}

+ (instancetype)sharedManager1 {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        instance = [[self alloc] initWithBaseURL:nil sessionConfiguration:config];
    });
    return instance;
}
@end
