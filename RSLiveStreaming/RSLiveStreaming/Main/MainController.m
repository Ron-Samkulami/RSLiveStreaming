//
//  MainController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/16.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@property (nonatomic,assign) NSInteger currentSelectedItem;
@end

@implementation MainController

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index == self.currentSelectedItem) {
        //need to reload data
        //return;// or ignore duplicate click
    }
    [self animationWithIndex:index];
    self.currentSelectedItem = index;
    
}

//pulse animation while clicking tabbar button
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.1;
    pulse.repeatCount= 2;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




@end
