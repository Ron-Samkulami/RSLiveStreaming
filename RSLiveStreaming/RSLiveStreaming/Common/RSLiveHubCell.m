//
//  RSLiveHubCell.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/23.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "RSLiveHubCell.h"

@implementation RSLiveHubCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
//        self.contentView.backgroundColor = [UIColor greenColor];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"placeHolder"];
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
        //判断是否有图片数据，没有则使用占位图片
        bgView.image = placeholderImage;
        
    
        self.backgroundView = bgView;
        
        //引入数据模型，并把模型数据赋值到子控件上
//        [self.contentView addSubview:imgView];
        CGFloat cellW = ([UIScreen mainScreen].bounds.size.width - 15 ) / 2;
        CGFloat nicklabellW = cellW / 2;
        CGFloat nicklabelH = 30;
        CGFloat nicklabelX = 10;
        CGFloat nicklabelY = nicklabellW * 8 / 3 - nicklabelH - 5;
        //主播昵称
        UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(nicklabelX, nicklabelY, nicklabellW , nicklabelH)];
        nickLabel.text = @"主播昵称";
        nickLabel.textColor = [UIColor blueColor];
        nickLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:nickLabel];
        //城市标签
        NSString *city = @"广州";
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(nicklabelX, nicklabelY - nicklabelH , nicklabellW, nicklabelH)];
        cityLabel.text = [NSString stringWithString:city];
        cityLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:cityLabel];
    
        //观看人数
        NSInteger tmpCount = 71287;  //测试用
        UILabel *audienceCount = [[UILabel alloc] initWithFrame:CGRectMake(cellW * 3 / 5, nicklabelY - 1 , cellW / 5, nicklabelH)];
        audienceCount.text = [NSString stringWithFormat:@"%ld",tmpCount];
        audienceCount.textAlignment = NSTextAlignmentRight;
        audienceCount.font = [UIFont systemFontOfSize:14];
        [self addSubview:audienceCount];
        
        UILabel *tailLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellW * 4 / 5, nicklabelY, cellW /5, nicklabelH)];
        tailLabel.text = @"人在看";
        tailLabel.font = [UIFont systemFontOfSize:8];
        [self addSubview:tailLabel];
        
        
    }
    return self;
}
@end
