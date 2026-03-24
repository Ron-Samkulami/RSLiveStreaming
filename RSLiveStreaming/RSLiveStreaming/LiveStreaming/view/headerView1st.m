//
//  headerView1st.m
//  RSLiveStreaming
//

#import "headerView1st.h"

static const CGFloat kBtnMargin = 10;

@interface headerView1st ()
@property (nonatomic, copy) NSArray<UIButton *> *actionButtons;
@property (nonatomic, copy) NSArray<UILabel *> *titleLabels;
@end

@implementation headerView1st

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self rs_installSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self rs_installSubviews];
    }
    return self;
}

- (void)rs_installSubviews {
    if (self.actionButtons.count > 0) {
        return;
    }
    NSArray<NSString *> *images = @[@"microphone", @"shoppingCar", @"heart&+", @"people", @"collectionView"];
    NSArray<NSString *> *titles = @[@"音乐", @"嗨购", @"派对", @"童趣大作战", @"更多频道"];
    NSMutableArray<UIButton *> *btns = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray<UILabel *> *labs = [NSMutableArray arrayWithCapacity:5];
    SEL actions[] = {
        @selector(musicClicked),
        @selector(shoppingClicked),
        @selector(partyClicked),
        @selector(funClicked),
        @selector(moreChannelClicked),
    };
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        b.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [b addTarget:self action:actions[i] forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [btns addObject:b];

        UILabel *l = [[UILabel alloc] init];
        l.text = titles[i];
        l.font = [UIFont systemFontOfSize:12];
        l.textColor = [UIColor colorWithWhite:0.6666666667 alpha:1];
        l.textAlignment = NSTextAlignmentCenter;
        l.numberOfLines = 1;
        l.adjustsFontSizeToFitWidth = YES;
        l.minimumScaleFactor = 0.8;
        [self addSubview:l];
        [labs addObject:l];
    }
    self.actionButtons = btns;
    self.titleLabels = labs;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.bounds);
    if (w < 1 || self.actionButtons.count != 5) {
        return;
    }
    CGFloat btnW = (w - kBtnMargin * 6) / 5.0;
    for (NSInteger i = 0; i < 5; i++) {
        CGFloat x = kBtnMargin + (btnW + kBtnMargin) * i;
        self.actionButtons[i].frame = CGRectMake(x, 10, btnW, 44);
        self.titleLabels[i].frame = CGRectMake(x, 54, btnW, 22);
    }
}

- (void)musicClicked {
    if ([self.delegate respondsToSelector:@selector(pushMusicView)]) {
        [self.delegate pushMusicView];
    }
}

- (void)shoppingClicked {
    if ([self.delegate respondsToSelector:@selector(pushShoppingView)]) {
        [self.delegate pushShoppingView];
    }
}

- (void)partyClicked {
    if ([self.delegate respondsToSelector:@selector(pushPartyView)]) {
        [self.delegate pushPartyView];
    }
}

- (void)funClicked {
    if ([self.delegate respondsToSelector:@selector(pushFunView)]) {
        [self.delegate pushFunView];
    }
}

- (void)moreChannelClicked {
    if ([self.delegate respondsToSelector:@selector(pushMoreChannelView)]) {
        [self.delegate pushMoreChannelView];
    }
}

@end
