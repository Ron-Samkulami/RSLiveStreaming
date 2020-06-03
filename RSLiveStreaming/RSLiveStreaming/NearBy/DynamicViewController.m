//
//  DynamicViewController.m
//  RSLiveStreaming
//
//  Created by Ron_Samkulami on 2020/5/24.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "DynamicViewController.h"
#import "MomentCell.h"

@interface DynamicViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.rowHeight = 400;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"MomentCell" bundle:nil] forCellReuseIdentifier:@"people_cell"];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"people_cell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    cell.model赋值
//    cell.textLabel.text = [NSString stringWithFormat:@"动态%zd",indexPath.row];
//    cell.detailTextLabel.text = @"正文";
//    cell.imageView.image = [UIImage imageNamed:@"placeHolder"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消点击后的高亮效果
    
    return cell;
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
