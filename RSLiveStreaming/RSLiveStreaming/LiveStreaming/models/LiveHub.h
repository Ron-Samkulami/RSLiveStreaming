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
@property (nonatomic,copy) NSString *liveid;    //房间ID
@property (nonatomic,copy) NSString *image2;    //封面图片
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *uid;       //主播ID
@property (nonatomic,copy) NSString *nick;      //昵称
@property (nonatomic,assign) BOOL gender;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *portrait;  //头像小图
@property (nonatomic,copy) NSString *name;      //直播件标题
@property (nonatomic,copy) NSString *online_users;    //观看人数

+ (instancetype)liveHubWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end


NS_ASSUME_NONNULL_END
