//
//  MessagesViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/14.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "MessagesViewController.h"




@interface MessagesViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation MessagesViewController

- (IBAction)showContacts:(id)sender {
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.title = @"联系人";
    
    
    //push新的viewController
    self.tabBarController.tabBar.hidden = YES;                          //跳转后隐藏bottomBar
    [self.navigationController pushViewController:newView animated:YES];
}

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
    
    //add title labels
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.text = title;
    label.textColor = [UIColor colorWithRed:129 * 1.0 / 255 green:216 * 1.0 / 255 blue:209 * 1.0 / 255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
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
    
//    cell.imageView.layer.cornerRadius = 25;
//    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.image = [UIImage imageNamed:@"photo01"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    UIViewController *newView = [[UIViewController alloc] init];
    newView.view.backgroundColor = [UIColor whiteColor];
    newView.title = @"互动消息";
    
    
    //push新的viewController
    self.tabBarController.tabBar.hidden = YES;                          //跳转后隐藏bottomBar
    [self.navigationController pushViewController:newView animated:YES];
}

#pragma mark - LifeCircle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;       //tabbar：跳转页面willAppear设置隐藏
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
