//
//  LiveAddr.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/26.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "LiveAddr.h"

@implementation LiveAddr
+ (instancetype)liveAddrWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
