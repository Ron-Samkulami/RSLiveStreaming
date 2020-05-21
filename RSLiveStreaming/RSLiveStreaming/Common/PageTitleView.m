//
//  PageTitleView.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/16.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

//
#import "PageTitleView.h"

typedef struct {
    CGFloat RValue;
    CGFloat GValue;
    CGFloat BValue;
} RSRGBVlaues;

RSRGBVlaues normalRGB = {192,192,170};          //普通样式RGB值
RSRGBVlaues hilightRGB = {129,216,209};         //高亮样式RGB值

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
    
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        
        //add scrollView
        UIScrollView *scrollView = [self scrollViewWithFrame:self.frame];
        [self addSubview:scrollView];
        
        //add title labels
        for (NSString * title in self.titles) {
            UILabel *label = [[UILabel alloc] init];        //创建label
            
            NSInteger index = [titles indexOfObject:title]; //设置label属性
            label.tag = index;                              //设置tag
            label.font = [UIFont systemFontOfSize:14];
            label.text = title;
            label.textColor = [UIColor colorWithRed:normalRGB.RValue / 255 green:normalRGB.GValue /255 blue:normalRGB.BValue /255 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(labelWidth * index, 0, labelWidth, frame.size.height - RSScrollLineH);
            
            [scrollView addSubview:label];
            [self.titleLabels addObject:label];
//            NSLog(@"PageTitleView:创建第%ld个label",(long)index);
            
            
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
            [label addGestureRecognizer:tapGes];
            
        }
        
        UILabel *firstLabel = [self.titleLabels firstObject];       //页面加载完毕第一个label突出显示
        firstLabel.textColor = [UIColor colorWithRed:hilightRGB.RValue / 255 green:hilightRGB.GValue /255 blue:hilightRGB.BValue /255 alpha:1];
        [firstLabel setFont:[UIFont systemFontOfSize:20]];
        
        
        //add scrollLine
        UIView *scrollLine = [[UIView alloc] init];
        //设置scrollLine的颜色，与UITabBar.appearance.tintColor（AppDelegate中）相同
        scrollLine.backgroundColor = [UIColor colorWithRed:129 * 1.0 / 255 green:216 * 1.0 / 255 blue:209 * 1.0 /255 alpha:1];
//        scrollLine.backgroundColor = [UIColor colorWithRed:hilightRGB.RValue / 255 green:hilightRGB.GValue /255 blue:hilightRGB.BValue /255 alpha:1];
        scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, scrollView.frame.origin.y + scrollView.frame.size.height  - RSScrollLineH, labelWidth, RSScrollLineH);
        [scrollLine setTag:300];
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

- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes {
    if (![tapGes.view isKindOfClass:NSClassFromString(@"UILabel")]) {
        return;
    }
    UILabel *currentLabel = (UILabel *)tapGes.view;                         //获取当前label
    if (currentLabel.tag == self.currentLabelIndex) {
        return;                                                             //重复点击不做任何操作
    }
    UILabel *preLabel = self.titleLabels[self.currentLabelIndex];           //获取之前的label
    
    [currentLabel setFont:[UIFont systemFontOfSize:20]];                    //切换label的字体大小和颜色
    currentLabel.textColor = [UIColor colorWithRed:hilightRGB.RValue / 255 green:hilightRGB.GValue /255 blue:hilightRGB.BValue /255 alpha:1];
    [preLabel setFont:[UIFont systemFontOfSize:14]];
    preLabel.textColor = [UIColor colorWithRed:normalRGB.RValue / 255 green:normalRGB.GValue /255 blue:normalRGB.BValue /255 alpha:1];
    
    self.currentLabelIndex = currentLabel.tag;                              //保存最新label的下标值
        
    [UIView animateWithDuration:0.15 animations:^{
        CGRect tmpFrame = [self viewWithTag:300].frame;                     //滚动scrollLine
        tmpFrame.origin.x = currentLabel.frame.origin.x;
        [self viewWithTag:300].frame = tmpFrame;
    }];
    
    //contentView随titleView滚动
    if ([self.delegate respondsToSelector:@selector(contentViewScrollWithTitleView:selectedIndex:)]) {
        [self.delegate contentViewScrollWithTitleView:self selectedIndex:self.currentLabelIndex];
    }
}

#pragma mark - PageTitle随PageContent滚动
/*
    暴露给controller调用的方法（controller中实现pageContentView的代理方法调用此方法设置title）
 */
- (void)scrollTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    
    //scrollLine随contentPage而滚动
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    CGFloat moveX = (targetLabel.frame.origin.x - sourceLabel.frame.origin.x) * progress;
    CGRect tmpFrame = [self viewWithTag:300].frame;
    tmpFrame.origin.x = sourceLabel.frame.origin.x + moveX;
    [self viewWithTag:300].frame = tmpFrame;
    
    //先设置所有label样式为normal，再单独设置targetLabel为亮高
    for (UILabel * everyLabel in self.titleLabels) {
        [everyLabel setFont:[UIFont systemFontOfSize:14]];
        everyLabel.textColor = [UIColor colorWithRed:normalRGB.RValue / 255 green:normalRGB.GValue /255 blue:normalRGB.BValue /255 alpha:1];
    }
    [targetLabel setFont:[UIFont systemFontOfSize:20]];
    targetLabel.textColor = [UIColor colorWithRed:hilightRGB.RValue / 255 green:hilightRGB.GValue /255 blue:hilightRGB.BValue /255 alpha:1];
    
    //屏幕滑动时，记录最新的currentLabelindex
    self.currentLabelIndex = targetIndex;

}
    

   
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
