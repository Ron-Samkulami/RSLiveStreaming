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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //取消点击后的高亮效果
    
    return cell;
}


@end
