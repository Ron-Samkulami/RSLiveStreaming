//
//  LiveBroadcastViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/24.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "LiveBroadcastViewController.h"
#import "RSStyleConfig.h"

#define CellID @"CellID"

@interface LiveBroadcastViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LiveBroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = [NSString stringWithFormat:@"妲己%zd",indexPath.row];
    cell.detailTextLabel.text = @"tags";
    cell.imageView.image = [UIImage imageNamed:@"photo01"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 100)];
    [bgView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    UIColor *fadeMainColor = [kHighlightColor colorWithAlphaComponent:0.4];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)fadeMainColor.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(1.0, 0);
    gradientLayer.endPoint = CGPointMake(0.2, 0);
    gradientLayer.frame = bgView.bounds;
    [bgView.layer addSublayer:gradientLayer];
    
    [cell insertSubview:bgView atIndex:0];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.title = @"附近直播间";
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:newView animated:YES];
}

@end
