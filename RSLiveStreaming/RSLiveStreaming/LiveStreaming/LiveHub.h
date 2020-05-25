//
//  LiveHub.h
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/25.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveHub : NSObject
@property (nonatomic,copy) NSString *liveid;
@property (nonatomic,copy) NSString *image2;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,assign) BOOL gender;
@property (nonatomic,assign) NSString *level;
@property (nonatomic,copy) NSString *portrait;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSString *online_users;

+ (instancetype)liveHubWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end


NS_ASSUME_NONNULL_END
