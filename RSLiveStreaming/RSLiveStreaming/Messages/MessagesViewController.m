//
//  MessagesViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "MessagesViewController.h"
#import "RSStyleConfig.h"

@interface MessagesViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //页面标题
    UILabel *titleView = [self labelWithFrame:CGRectMake(0, 0, 80, 44) andText:@"消息"];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.leftBarButtonItem = titleItem;
    
    //覆盖navigationBar的分割线，并使navigationBar的背景显示为白色
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //页面内容tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.rowHeight = 80;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    [self.view addSubview:tableView];

}

- (UILabel *)labelWithFrame:(CGRect)frame andText:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.font = kHighlightTitleFont;
    label.text = title;
    label.textColor = kHighlightColor;
    label.frame = frame;

    return label;
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"people_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = @"妲己";
    cell.detailTextLabel.text = @"你好呀！小正太";
    cell.imageView.image = [UIImage imageNamed:@"photo01"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.title = @"来自妲己的互动消息";
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:newView animated:YES];
}

#pragma mark - Action

- (IBAction)showContacts:(id)sender {
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.title = @"好友";
    
    [self.navigationController pushViewController:newView animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

@end
