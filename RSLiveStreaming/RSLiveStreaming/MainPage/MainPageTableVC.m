//
//  MainPageTableVC.m
//  RSLiveStreaming
//

#import "MainPageTableVC.h"

@interface MainPageTableVC ()
@property (nonatomic, copy) NSArray<NSArray<NSDictionary *> *> *menuData;
@end

@implementation MainPageTableVC

- (instancetype)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _menuData = @[
            @[
                @{@"title": @"我的勋章", @"sys": @"tag"},
                @{@"title": @"礼物贡献榜", @"sys": @"doc.text"},
                @{@"title": @"我的特权", @"sys": @"bookmark"},
                @{@"title": @"我的背包", @"sys": @"bag"},
                @{@"title": @"购物助手", @"sys": @"cart"},
            ],
            @[
                @{@"title": @"派对房间", @"asset": @"collectionView"},
                @{@"title": @"主播中心", @"asset": @"me"},
            ]
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)self.menuData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.menuData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"mainMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *item = self.menuData[indexPath.section][indexPath.row];
    cell.textLabel.text = item[@"title"];
    NSString *sys = item[@"sys"];
    if (sys) {
        cell.imageView.image = [UIImage systemImageNamed:sys];
    } else {
        cell.imageView.image = [UIImage imageNamed:item[@"asset"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
