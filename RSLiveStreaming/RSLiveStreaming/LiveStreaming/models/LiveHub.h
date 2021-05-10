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
///liveRoomID
@property (nonatomic,copy) NSString *liveid;
///cover image
@property (nonatomic,copy) NSString *image2;
///location city
@property (nonatomic,copy) NSString *city;
///userID
@property (nonatomic,copy) NSString *uid;
///nickName
@property (nonatomic,copy) NSString *nick;
///gender
@property (nonatomic,assign) BOOL gender;
///level
@property (nonatomic,copy) NSString *level;
///user icon
@property (nonatomic,copy) NSString *portrait;
///liveRoom title
@property (nonatomic,copy) NSString *name;
///audience count
@property (nonatomic,copy) NSString *online_users;


+ (instancetype)liveHubWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end


NS_ASSUME_NONNULL_END
