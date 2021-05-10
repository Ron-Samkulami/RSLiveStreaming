//
//  PageTitleView.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/16.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

//
#import "PageTitleView.h"
#import "RSStyleConfig.h"
#define kScrollLineTag 300

@interface PageTitleView ()

@property (nonatomic,strong) NSArray* titles;
@property (nonatomic,strong) NSMutableArray * titleLabels;
@property (nonatomic,assign) NSInteger currentLabelIndex;

@end

@implementation PageTitleView


- (NSMutableArray *)titleLabels {
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray new];
    }
    return _titleLabels;
}

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles labelWidth:(CGFloat)labelWidth {
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        
        UIScrollView *scrollView = [self scrollViewWithFrame:self.frame];
        [self addSubview:scrollView];
        
        //add title labels
        for (NSString * title in self.titles) {
            NSInteger index = [titles indexOfObject:title];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * index, 0, labelWidth, frame.size.height - kScrollLineH)];
            label.tag = index;                              //set tag
            label.font = kNormalTitleFont;
            label.text = title;
            label.textColor = kNormalColor;
            label.textAlignment = NSTextAlignmentCenter;
            
            [scrollView addSubview:label];
            [self.titleLabels addObject:label];
            
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleLabelClick:)];
            [label addGestureRecognizer:tapGes];
            
        }
        
        //highlight first label
        UILabel *firstLabel = [self.titleLabels firstObject];
        [firstLabel setFont:kHighlightTitleFont];
        [firstLabel setTextColor:kHighlightColor];
        
        //add scrollLine
        UIView *scrollLine = [[UIView alloc] init];
        scrollLine.backgroundColor = kHighlightColor;
        scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, scrollView.frame.origin.y + scrollView.frame.size.height  - kScrollLineH, labelWidth, kScrollLineH);
        [scrollLine setTag:kScrollLineTag];
        [self addSubview:scrollLine];
    }
    return self;
}

- (UIScrollView *)scrollViewWithFrame:(CGRect)frame {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.bounces = NO;
    scrollView.frame = frame;
    return scrollView;
}

#pragma mark - Action
- (void)onTitleLabelClick:(UITapGestureRecognizer *)tapGes {
    if (![tapGes.view isKindOfClass:NSClassFromString(@"UILabel")]){
        return;
        
    } else {
        UILabel *currentLabel = (UILabel *)tapGes.view;
        if (currentLabel.tag == self.currentLabelIndex) {
            return; //ignore duplicate tapGes
        } else {
            UILabel *preLabel = self.titleLabels[self.currentLabelIndex];
            // change font and color
            [currentLabel setFont:kHighlightTitleFont];
            [currentLabel setTextColor:kHighlightColor];
            [preLabel setFont:kNormalTitleFont];
            [preLabel setTextColor:kNormalColor];
            
            self.currentLabelIndex = currentLabel.tag;
            //scroll the scrollLine
            [UIView animateWithDuration:0.15 animations:^{
                CGRect tmpFrame = [self viewWithTag:kScrollLineTag].frame;
                tmpFrame.origin.x = currentLabel.frame.origin.x;
                [self viewWithTag:kScrollLineTag].frame = tmpFrame;
            }];
            
            if ([self.delegate respondsToSelector:@selector(pageTitleView:didScrollToIndex:)]) {
                [self.delegate pageTitleView:self didScrollToIndex:self.currentLabelIndex];
            }
        }
    }
}


- (void)scrollTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    
    //scrollLine scroll with progress
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    CGFloat moveX = (targetLabel.frame.origin.x - sourceLabel.frame.origin.x) * progress;
    CGRect tmpFrame = [self viewWithTag:kScrollLineTag].frame;
    tmpFrame.origin.x = sourceLabel.frame.origin.x + moveX;
    [self viewWithTag:kScrollLineTag].frame = tmpFrame;
    
    //change font and color with progress
    [sourceLabel setFont:[UIFont boldSystemFontOfSize:kBigFontSize-(kBigFontSize-kNormalFontSize)*progress]];
    [sourceLabel setTextColor:[UIColor colorWithRed:(129+(192-129)*progress)*1.0/255 green:(216+(192-216)*progress)*1.0/255 blue:(209+(170-209)*progress)*1.0/255 alpha:1]];
    [targetLabel setFont:[UIFont boldSystemFontOfSize:kNormalFontSize+(kBigFontSize-kNormalFontSize)*progress]];
    [targetLabel setTextColor:[UIColor colorWithRed:(192+(129-192)*progress)*1.0/255 green:(192+(216-192)*progress)*1.0/255 blue:(170+(209-170)*progress)*1.0/255 alpha:1]];
 
    //record currentIndex
    self.currentLabelIndex = targetIndex;
}


@end
