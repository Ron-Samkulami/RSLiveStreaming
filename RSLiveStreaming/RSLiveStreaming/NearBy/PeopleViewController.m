//
//  PeopleViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/24.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "PeopleViewController.h"

@interface PeopleViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.rowHeight = 120;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellEditingStyleNone; //不显示分割线
    
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"people_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"敖丙丙%zd",indexPath.row];
    cell.detailTextLabel.text = @"tags";
    cell.imageView.image = [UIImage imageNamed:@"photo01"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消点击后的高亮效果
    
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.title = @"附近的人详情页";
    
    
    //push新的viewController
    self.tabBarController.tabBar.hidden = YES;                          //跳转后隐藏bottomBar
    [self.navigationController pushViewController:newView animated:YES];
}

@end
