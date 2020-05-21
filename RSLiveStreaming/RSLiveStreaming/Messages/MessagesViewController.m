//
//  MessagesViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "MessagesViewController.h"




@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleView = [self labelWithFrame:CGRectMake(0, 0, 80, 44) andText:@"消息"];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItem = titleItem;
    
    //覆盖navigationBar的分割线，并使navigationBar的背景显示为白色
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

}

- (UILabel *)labelWithFrame:(CGRect)frame andText:(NSString *)title {
    
    //add title labels
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.text = title;
    label.textColor = [UIColor colorWithRed:129 * 1.0 / 255 green:216 * 1.0 / 255 blue:209 * 1.0 / 255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = frame;

    return label;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
