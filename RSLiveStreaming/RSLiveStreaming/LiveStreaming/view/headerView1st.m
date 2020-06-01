//
//  headerView1st.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/6/1.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#define btnMargin 10
#define superViewW [UIScreen mainScreen].bounds.size.width
#import "headerView1st.h"

@interface headerView1st ()
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoppingBtn;
@property (weak, nonatomic) IBOutlet UIButton *partyBtn;
@property (weak, nonatomic) IBOutlet UIButton *funBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoppingLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UILabel *funLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreChannelLabel;



@end


@implementation headerView1st

- (IBAction)musicClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pushMusicView)]) {
        [self.delegate pushMusicView];
    }
}

- (IBAction)shoppingClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pushShoppingView)]) {
        [self.delegate pushShoppingView];
    }
}
- (IBAction)partyClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pushPartyView)]) {
        [self.delegate pushPartyView];
    }
}
- (IBAction)funClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pushFunView)]) {
        [self.delegate pushFunView];
    }
}
- (IBAction)moreChannelClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pushMoreChannelView)]) {
        [self.delegate pushMoreChannelView];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat btnWidth = (superViewW - btnMargin * 6) / 5;
    self.musicBtn.frame = CGRectMake(btnMargin, 10, btnWidth, 50);
    self.shoppingBtn.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 1, 10, btnWidth, 50);
    self.partyBtn.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 2, 10, btnWidth, 50);
    self.funBtn.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 3, 10, btnWidth, 50);
    self.moreBtn.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 4, 10, btnWidth, 50);
    
    self.musicLabel.frame = CGRectMake(btnMargin, 40, btnWidth, 50);
    self.shoppingLabel.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 1, 40, btnWidth, 50);
    self.partyLabel.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 2, 40, btnWidth, 50);
    self.funLabel.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 3, 40, btnWidth, 50);
    self.moreChannelLabel.frame = CGRectMake(btnMargin + (btnWidth + btnMargin) * 4, 40, btnWidth, 50);
    
    
}



@end
