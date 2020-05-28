//
//  LiveAddr.h
//  网络请求功能
//
//  Created by Ron_Samkulami on 2020/5/26.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveAddr : NSObject
@property (nonatomic,copy) NSString *rtmp_stream_addr;
@property (nonatomic,copy) NSString *liveid;
@property (nonatomic,copy) NSString *stream_addr;
@property (nonatomic,copy) NSString *hls_stream_addr;


+ (instancetype)liveAddrWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
