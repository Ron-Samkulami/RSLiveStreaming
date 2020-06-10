//
//  RSLiveHubCell.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/23.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "RSLiveHubCell.h"

#import "LiveHub.h"
#import <UIImageView+WebCache.h>

@interface RSLiveHubCell ()
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation RSLiveHubCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    NSLog(@"从xib中");
}

#pragma mark - 引入模型并赋值显示

//引入数据模型，并把模型数据赋值到子控件上
- (void)setLiveHubModel:(LiveHub *)liveHubModel {
    _liveHubModel = liveHubModel;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:liveHubModel.image2]];
    self.nickLabel.text = liveHubModel.nick;
    self.cityLabel.text = liveHubModel.city;
    int count = [liveHubModel.online_users intValue];
    if (count > 9999) {
        self.onlineCountLabel.text = [NSString stringWithFormat:@"%.01f万",(count / 1000) * 0.1];
    } else {
       self.onlineCountLabel.text = [NSString stringWithFormat:@"%d",count];
    }
    
}

@end
