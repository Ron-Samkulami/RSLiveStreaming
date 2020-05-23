//
//  RSLiveHubCell.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/23.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "RSLiveHubCell.h"

@implementation RSLiveHubCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}
@end
