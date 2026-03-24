//
//  MainPageViewController.m
//  RSLiveStreaming
//

#import "MainPageViewController.h"
#import "MainPageTableVC.h"

@interface MainPageViewController ()
@property (nonatomic, strong) UIView *tableViewContainer;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemGray6Color];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    UIImage *gear = [UIImage systemImageNamed:@"gearshape"];
    UIImage *qr = [UIImage systemImageNamed:@"qrcode.viewfinder"];
    self.navigationItem.rightBarButtonItems = @[
        [[UIBarButtonItem alloc] initWithImage:qr style:UIBarButtonItemStylePlain target:nil action:nil],
        [[UIBarButtonItem alloc] initWithImage:gear style:UIBarButtonItemStylePlain target:nil action:nil]
    ];

    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 12;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stack];

    UIView *header = [self rs_makeProfileHeader];
    [stack addArrangedSubview:header];

    self.tableViewContainer = [[UIView alloc] init];
    self.tableViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableViewContainer.backgroundColor = UIColor.clearColor;
    [stack addArrangedSubview:self.tableViewContainer];
    [self.tableViewContainer.heightAnchor constraintEqualToConstant:300].active = YES;

    MainPageTableVC *tableVC = [[MainPageTableVC alloc] init];
    [self addChildViewController:tableVC];
    tableVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableViewContainer addSubview:tableVC.view];
    [NSLayoutConstraint activateConstraints:@[
        [tableVC.view.topAnchor constraintEqualToAnchor:self.tableViewContainer.topAnchor],
        [tableVC.view.leadingAnchor constraintEqualToAnchor:self.tableViewContainer.leadingAnchor],
        [tableVC.view.trailingAnchor constraintEqualToAnchor:self.tableViewContainer.trailingAnchor],
        [tableVC.view.bottomAnchor constraintEqualToAnchor:self.tableViewContainer.bottomAnchor],
    ]];
    [tableVC didMoveToParentViewController:self];

    UILayoutGuide *g = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:g.topAnchor constant:8],
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8],
        [stack.bottomAnchor constraintLessThanOrEqualToAnchor:g.bottomAnchor],
    ]];
}

- (UIView *)rs_makeProfileHeader {
    UIView *box = [[UIView alloc] init];
    box.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeHolder"]];
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    avatar.layer.cornerRadius = 40;
    avatar.clipsToBounds = YES;

    UILabel *name = [[UILabel alloc] init];
    name.text = @"RonCoding";
    name.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    name.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *uid = [[UILabel alloc] init];
    uid.text = @"ID:1402434985@qq.com";
    uid.font = [UIFont systemFontOfSize:10];
    uid.textColor = [UIColor secondaryLabelColor];
    uid.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *stats = [[UILabel alloc] init];
    stats.text = @"关注 2    粉丝 4    最近来访 25    好友 1";
    stats.font = [UIFont systemFontOfSize:12];
    stats.textColor = [UIColor secondaryLabelColor];
    stats.numberOfLines = 0;
    stats.translatesAutoresizingMaskIntoConstraints = NO;

    UIStackView *textCol = [[UIStackView alloc] initWithArrangedSubviews:@[name, uid, stats]];
    textCol.axis = UILayoutConstraintAxisVertical;
    textCol.spacing = 6;
    textCol.translatesAutoresizingMaskIntoConstraints = NO;

    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[avatar, textCol]];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 12;
    row.alignment = UIStackViewAlignmentCenter;
    row.translatesAutoresizingMaskIntoConstraints = NO;

    [box addSubview:row];
    [NSLayoutConstraint activateConstraints:@[
        [avatar.widthAnchor constraintEqualToConstant:80],
        [avatar.heightAnchor constraintEqualToConstant:80],
        [row.topAnchor constraintEqualToAnchor:box.topAnchor constant:8],
        [row.leadingAnchor constraintEqualToAnchor:box.leadingAnchor constant:8],
        [row.trailingAnchor constraintEqualToAnchor:box.trailingAnchor constant:-8],
        [row.bottomAnchor constraintEqualToAnchor:box.bottomAnchor constant:-8],
    ]];
    return box;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
